class Product
  @@po_number = 100000

  def self.generate_product_number
  	@@po_number += 1
  	"P#{@@po_number}"
  end
end