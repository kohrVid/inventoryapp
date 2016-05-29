require "minitest/autorun"
require "minitest/pride"
require "./lib/toy"
require "pry"

class ToySpec < MiniTest::Spec
  before do
    @toy = Toy.new({title: "Azul", description: "Blue teddy bear from the Iberian Peninsula", age_range: "3-10 years", stock_level: 15})
    @toy2 = Toy.new({title: "Lucretzia My Purrfection", description: "Stuffed Persian cat", age_range: "3-10 years", stock_level: 11})
    Toy.delete_all
  end

  describe Toy do
    it "should have a unique auto-generated ID" do
      @toy.id.wont_be_nil
      @toy2.id.wont_be_nil
      @toy.id.wont_equal @toy2.id
    end

    it "should have a title" do
      @toy.title.wont_be_nil
    end
    
    it "should have a description" do
      @toy.description.wont_be_nil
    end

    it "should have an age-range" do
      @toy.age_range.wont_be_nil
    end
    
    describe "CRUD methods" do
      it "should load cds" do
	original_count = Toy.count
	Toy.add(@toy)
	Toy.add(@toy2)
	Toy.load("./toys.yml")
	Toy.count.must_equal original_count + 2
      end

      it "should save cds" do
	File.delete("./toys.yml") if File.exist?("./toys.yml")
	original_count = Toy.count
	Toy.add(@toy)
	Toy.add(@toy2)
	Toy.save("./toys.yml")
	Toy.count.must_equal original_count + 2
	File.exist?("./toys.yml").must_equal true
	binding.pry
      end

      it "should be able to delete a toy" do
	Toy.add(@toy)
	Toy.add(@toy2)
	Toy.delete(@toy.id)
	Toy.all.wont_include(@toy)
      end
    end
  end
end
