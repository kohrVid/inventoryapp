require "minitest/autorun"
require "minitest/pride"
require "./lib/cd"
require "pry"

class CdSpec < MiniTest::Spec
  before do
    @cd = Cd.new({ title: "Raspberry Beret", artist_name: "Prince", description: "Fun Prince song", release_date: Time.local(1985, 05, 15), stock_level: 19})
    @cd2 = Cd.new({ title: "Treats", artist_name: "Sleigh Bells", description: "Sleigh Bells' debut album", release_date: Time.local(2010, 05, 24), stock_level: 25})
    Product.delete_all
  end

  describe Cd do
    it "should have an artist name" do
      @cd.artist_name.wont_be_nil
    end

    it "should have a release date" do
      @cd.release_date.wont_be_nil
    end

    describe "CRUD methods" do
      it "should save and load cds" do
	File.delete("./cd.yml") if File.exist?("./cd.yml")
	original_count = Cd.count
	Cd.add(@cd)
	Cd.add(@cd2)
	Cd.save("./cd.yml")
	Cd.load("./cd.yml")
	Cd.count.must_equal original_count + 2
	File.exist?("./cd.yml").must_equal true
      end

      it "should be able to delete a cd" do
	Cd.add(@cd)
	Cd.add(@cd2)
	Cd.delete(@cd.id)
	Cd.all.wont_include(@cd)
      end

      it "should be able to find CDs by title" do
	Cd.add(@cd)
	Cd.add(@cd2)
	Cd.find_by_title("Raspberry").first.id.must_equal @cd.id
      end
    end
  end
end
