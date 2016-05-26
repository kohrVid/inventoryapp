require "./lib/product"
class Book < Product
  attr_reader :id
  attr_accessor :title, :author, :description, :genre
  def initialize(params = {})
    @id = (@@count += 1)
    params.each do |k, v|
      self.instance_variable_set "@#{k.to_s}", v
    end
  end
end
