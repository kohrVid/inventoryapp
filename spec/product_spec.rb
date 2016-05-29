require "minitest/autorun"
require "minitest/pride"
require "./lib/product"
require "./spec/helpers/product_helper"
require "./spec/helpers/customer_helper"
require "./lib/product_loan_count"
require "pry"

class ProductSpec < MiniTest::Spec
  before do
    @customer = CustomerHelper.customer
    @customer2 = CustomerHelper.customer2
    @product = ProductHelper.product
    @product2 = ProductHelper.product2
  end

  after do
    Product.delete_all
  end

  describe Product do
    it "should have a unique auto-generated ID" do
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
=begin
      it "should raise an exception if a duplicate product is added" do
	original_count = Product.count
	Product.add(@product)
	Product.add(@product).must_raise "Product already exists"
	Product.all.count.must_equal original_count
      end
=end

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

      it "should be able to search product titles alphabetically" do
	Product.add(@product)
	Product.add(@product2)
	Product.find_by_letter("J").first.title.must_equal "Juju"
      end

      it "should load products" do
	original_count = Product.count
	Product.add(@product)
	Product.add(@product2)
	Product.load("./products.yml")
	Product.count.must_equal original_count + 2
      end
      
      it "should save products" do
	File.delete("./products.yml") if File.exist?("./products.yml")
	original_count = Product.count
	Product.add(@product)
	Product.add(@product2)
	Product.save("./products.yml")
	Product.count.must_equal original_count + 2
	File.exist?("./products.yml").must_equal true
      end

      it "should be possible to update a product" do
	Product.add(@product)
	@product.edit({title: "Vision Thing", description: "One of their other albums"})
	@product.title.must_equal "Vision Thing"
	@product.description.must_equal "One of their other albums"
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
    
    describe "Event-driven sales actions" do
      it "should deduct 1 from stock_level whenever an item is sold" do
	Product.add(@product)
	original_stock = @product.stock_level
	@product.sold(1)
	@product.stock_level.wont_equal original_stock
        @product.stock_level.must_equal original_stock - 1
      end

      it "should alert the retailer if the transaction was successful" do
	Product.add(@product)
	proc{ puts @product.sold(1) }.must_output "Item has been sold\n"
      end

      it "should alert the retailer if the stock level falls below 10" do
	Product.add(@product2)
	proc{ puts @product2.sold(4) }.must_output "Item has been sold\nRunning low on stock - ordered more stock\n"
	@product2.stock_level.must_equal 29
      end

      it "should not allow items with stock levels of 0 to be sold" do
	Product.add(@product2)
	proc { puts @product2.sold(14) }.must_output "Item is out of stock - your order has been cancelled.\n"
	@product2.stock_level.must_equal 13
      end
    end
    
    describe "Event-driven loan actions" do
      before do
	Customer.delete_all
	Product.add(@product)
	@customer = CustomerHelper.customer2
	Customer.add(@customer)
      end
      
      it "should deduct 1 from stock_level whenever an item is loaned" do
	original_stock = @product.stock_level
	@product.loaned_to(@customer)
        @product.stock_level.must_equal original_stock - 1
      end
      
      it "should alert the retailer if the loan was successful" do
	proc{ puts @product.loaned_to(@customer) }.must_output "\"Some Girls Wander By Mistake\" has been successfully loaned to Amelia Tan\n"
      end

      it "should not allow customers to borrow the same item twice" do
	original_stock = @product.stock_level
	@product.loaned_to(@customer)
	proc { puts @product.loaned_to(@customer) }.must_output "You have already borrowed this item\n"
	@product.stock_level.wont_equal original_stock - 2
        @product.stock_level.must_equal original_stock - 1
      end
      
      it "should not allow customers to borrow more than one item at a time" do
	original_stock = @product2.stock_level
	@product.loaned_to(@customer)
	proc { puts @product2.loaned_to(@customer) }.must_output "You have already borrowed an item. Please return your loaned item before borrowing another.\n"
	@product2.stock_level.wont_equal original_stock - 1
      end
    end
    
    describe "Event-driven return actions" do
      before do
	Customer.delete_all
	@customer = CustomerHelper.customer
	@product3 = @customer.product_loaned
	Customer.add(@customer)
      end
      
      it "should increment by 1 from stock_level whenever an item is returned" do
	original_stock = @product3.stock_level
	@product3.returned_by(@customer)
	@product3.stock_level.wont_equal original_stock
        @product3.stock_level.must_equal original_stock + 1
      end
      it "should increment by 1 from stock_level whenever an item is returned" do
	proc{ puts @product3.returned_by(@customer) }.must_output "\"Some Girls Wander By Mistake\" was successfully returned.\n"
      end

      it "should alert the customer when an item is returned successfully" do
	original_stock = @product3.stock_level
	@product3.returned_by(@customer)
	proc { puts @product3.returned_by(@customer) }.must_output "You have not borrowed any new items\n"
	@product3.stock_level.wont_equal original_stock + 2
        @product3.stock_level.must_equal original_stock + 1
      end
    end
  end
end
