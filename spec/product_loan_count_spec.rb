require "minitest/autorun"
require "minitest/autorun"
require "./spec/helpers/product_helper"
require "./spec/helpers/customer_helper"
require "./lib/product_loan_count"

class ProductLoanCountSpec < MiniTest::Spec
  before do
    Customer.delete_all
    @customer = CustomerHelper.customer2
    @product = ProductHelper.product
    @product2 = ProductHelper.product2
    Product.add(@product)
    Product.add(@product2)
    Customer.add(@customer)
  end

  describe ProductLoanCount do
    it "should list all Products currently out on loan" do
      @product2.loaned_to(@customer)
      product_loan_counts = ProductLoanCount.all
      product_loan_counts.count.must_equal Product.all.count
      product_loan_counts.select { |plc| plc.product == @product2 }.first.count.must_equal 1
      product_loan_counts.reject { |plc| plc.product == @product2 }.inject(0){|sum, plc| sum += plc.count }.must_equal 0
    end
  end
end
