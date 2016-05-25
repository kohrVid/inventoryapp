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
end
