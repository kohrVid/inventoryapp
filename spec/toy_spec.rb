require "minitest/autorun"
require "minitest/pride"
require "./lib/toy"

class ToySpec < MiniTest::Spec
  before do
    @toy = Toy.new({title: "Azul", description: "Blue teddy bear from the Iberian Peninsula", age_range: "3-10 years"})
    @toy2 = Toy.new({title: "Lucretzia My Purrfection", description: "Stuffed Persian cat", age_range: "3-10 years"})
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
      it "should save and load cds" do
	File.delete("./toy.yml") if File.exist?("./toy.yml")
	original_count = Toy.count
	Toy.add(@toy)
	Toy.add(@toy2)
	Toy.save("./toy.yml")
	Toy.load("./toy.yml")
	Toy.count.must_equal original_count + 2
	File.exist?("./toy.yml").must_equal true
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
