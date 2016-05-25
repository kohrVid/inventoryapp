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

  def on_stock_threshold_reached(threshold)
    if self.stock_level < threshold
      self.stock_level += 20
      puts "Running low on stock - ordered more stock"
    end
  end

  def sold(quantity)
    if (self.stock_level - quantity) <= 0
      puts "Item is out of stock"
    else
      self.stock_level -= quantity
    end
    on_stock_threshold_reached(10)
  end
end
