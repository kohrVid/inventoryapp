require "minitest/autorun"
require "minitest/pride"
require "pry"
require "./lib/customer"
require "./spec/helpers/customer_helper"

class CustomerSpec < MiniTest::Spec
  before do
    @customer = CustomerHelper.customer
    @customer2 = CustomerHelper.customer2
    @product = @customer.product_loaned
    Customer.delete_all
  end

  describe Customer do
    it "should have a first name" do
      @customer.first_name.wont_be_nil
    end
    
    it "should have a last name" do
      @customer.last_name.wont_be_nil
    end

    it "should have a full name" do
      @customer.full_name.must_equal "Alexas Krauss"
    end
    
    it "should have an email address" do
      @customer.email_address.wont_be_nil
    end

    it "should have a phone number" do
      @customer.phone_number.wont_be_nil
    end

    it "should have a product object stored once they have loaned a product" do
      Customer.add(@customer)
      @customer.product_loaned.must_equal @product
    end
    
    describe "CRUD methods" do
      it "should load customers" do
	original_count = Customer.count
	Customer.add(@customer)
	Customer.add(@customer2)
	Customer.load("./customers.yml")
	Customer.count.must_equal original_count + 2
      end
      
      it "should save customers" do
	File.delete("./customers.yml") if File.exist?("./customers.yml")
	original_count = Customer.count
	Customer.add(@customer)
	Customer.add(@customer2)
	Customer.save("./customers.yml")
	Customer.count.must_equal original_count + 2
	File.exist?("./customers.yml").must_equal true
      end
      
      it "should be possible to update a customer" do
	Customer.add(@customer)
	@customer.edit({first_name: "Andrew", last_name: "Eldritch"})
	@customer.first_name.must_equal "Andrew"
	@customer.last_name.must_equal "Eldritch"
      end

      it "should be able to delete a customer" do
	Customer.add(@customer)
	Customer.add(@customer2)
	Customer.delete(@customer.id)
	Customer.all.wont_include(@customer)
      end
      
      it "should be able to find a customer by ID" do
	Customer.add(@customer)
	Customer.find(@customer.id).first_name.must_equal "Alexas"
      end

      it "should be able to find customers by first name" do
	Customer.add(@customer)
	Customer.add(@customer2)
	Customer.find_by_first_name("Ale").first.id.must_equal @customer.id
      end

      it "should be able to find customers by last name" do
	Customer.add(@customer)
	Customer.add(@customer2)
	Customer.find_by_last_name("Ta").first.id.must_equal @customer2.id
      end
    end 
  end
end
