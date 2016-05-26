require "./lib/product"

module ProductHelper
  def self.product
    Product.new(
      title: "Some Girls Wander By Mistake",
      description: "Compilation album",
      stock_level: 43
    )
  end

  def self.product2
    @product2 = Product.new(
      title: "Juju",
      description: "An 80s album",
      stock_level: 13
    )
  end
end
