require "./lib/product"
require "./lib/customer"

class ProductLoanCount
  attr_reader :product, :count

  def initialize(product, count)
    @product = product
    @count = count
  end

  def self.instance_vars
    [:product, :count] 
  end

  def self.all
    result = []
    Product.all.each do |product|
      count = Customer.all.select{|i| i.product_loaned == product }.count
      result << ProductLoanCount.new(product, count)
    end
    result
  end
end
