require "./lib/repository"
class Product
  include Repository
  attr_reader :id
  attr_accessor :title, :description, :stock_level

  @@count = 100000

  def initialize(params = {})
    @id = (@@count += 1)
    params.each do |k, v|
      self.instance_variable_set "@#{k.to_s}", v
    end
  end

  def self.instance_vars
    [:title, :description, :stock_level]
  end

  def edit(params ={})
    params.each do |k, v|
      self.instance_variable_set "@#{k.to_s}", v
    end
  end

  def self.find_by_letter(letter)
    Product.all.select {|item| item.title.start_with?(letter) }
  end

  def on_stock_threshold_reached(threshold)
    if self.stock_level < threshold
      self.stock_level += 20
      "Running low on stock - ordered more stock"
    end
  end

  def sold(quantity)
    output = []
    if (self.stock_level - quantity) <= 0
      output << "Item is out of stock - your order has been cancelled."
    else
      self.stock_level -= quantity
      output << "Item has been sold"
    end
    output << on_stock_threshold_reached(10)
    output.join("\n")
  end
  
  def loaned_to(customer)
    if (self.stock_level - 1) <= 0
      output = "Item is out of stock"
    elsif customer.product_loaned == self
      output = "You have already borrowed this item"
    elsif !customer.product_loaned.nil?
      output = "You have already borrowed an item. Please return your loaned item before borrowing another."
    else
      self.stock_level -= 1
      customer.product_loaned = self
      output = "\"#{self.title}\" has been successfully loaned to #{customer.full_name}"
    end
    on_stock_threshold_reached(10)
    output
  end
  
  def returned_by(customer)
    if customer.product_loaned != self
      output = "You have not borrowed any new items"
    else
      self.stock_level += 1
      customer.product_loaned = nil
      output = "\"#{self.title}\" was successfully returned."
    end
    output
  end
end
