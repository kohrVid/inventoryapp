require "minitest/autorun"
require "minitest/pride"
require "./lib/product"
require "pry"

class ProductSpec < MiniTest::Spec
  before do
    @product = Product.new({title: "Some Girls Wander By Mistake", description: "Compilation album", stock_level: 43})
    @product2 = Product.new({title: "Juju", description: "An 80s album", stock_level: 13})
  end

  after do
    Product.delete_all
  end

  describe Product do
    it "should have an auto-generated ID" do
      @product.id.wont_be_nil
      @product2.id.wont_be_nil
      @product.id.wont_equal @product2.id
    end

    it "should have a title" do
      @product.title.wont_be_nil
    end
    
    it "should have a description" do
      @product.description.wont_be_nil
    end

    it "should have a stock level" do
      @product.stock_level.wont_be_nil
    end
    
    describe "CRUD actions" do
      it "should be able to add a product" do
	original_count = Product.count
	Product.add(@product)
	Product.count.must_equal original_count + 1
      end

      it "should be able to list all products" do
	original_count = Product.count
	Product.add(@product)
	Product.add(@product2)

	Product.all.must_include(@product)
	Product.all.must_include(@product2)
	Product.count.must_equal original_count + 2
      end

      it "should be able to find a product by ID" do
	Product.add(@product)
	Product.find(@product.id).title.must_equal "Some Girls Wander By Mistake"
      end

      it "should save and load products" do
	File.delete("./entries.yml") if File.exist?("./entries.yml")
	original_count = Product.count
	Product.add(@product)
	Product.add(@product2)
	Product.save
	Product.load
	Product.count.must_equal original_count + 2
	File.exist?("./entries.yml").must_equal true
      end

      it "should be able to delete a product" do
	Product.add(@product)
	Product.add(@product2)
	Product.delete(@product.id)
	Product.all.wont_include(@product)
      end

      it "should be able to delete all products" do
	Product.add(@product)
	Product.add(@product2)
	Product.delete_all
	Product.count.must_equal 0
      end
    end
  end
end
