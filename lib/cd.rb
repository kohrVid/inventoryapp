require "./lib/product"
class Cd < Product
  attr_reader :id
  attr_accessor :title, :artist_name, :release_date, :description, :stock_level
  def initialize(params = {})
    @id = (@@count += 1)
    params.each do |k, v|
      self.instance_variable_set "@#{k.to_s}", v
    end
  end
  
  def self.instance_vars
    super + [:artist_name, :release_date, :stock_level]
  end

  def self.find_by_title(search_term)
    Product.all.select {|cd| cd.class == Cd && cd.title.include?(search_term) }
  end
end
