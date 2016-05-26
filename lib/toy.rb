require "./lib/product"
class Toy < Product
  attr_reader :id
  attr_accessor :title, :description, :age_range
  def initialize(params = {})
    @id = (@@count += 1)
    params.each do |k, v|
      self.instance_variable_set "@#{k.to_s}", v
    end
  end

end
