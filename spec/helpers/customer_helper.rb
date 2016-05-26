require "./spec/helpers/product_helper"
require "./lib/customer"

module CustomerHelper
  def self.customer
    Product.add(ProductHelper.product)
    Customer.new(
      first_name: "Alexas",
      last_name: "Krauss",
      email_address: "alexas@bitterrivals.us",
      phone_number: "0207-456-1234",
      product_loaned: Product.all.first)
  end

  def self.customer2
    Customer.new(
      first_name: "Amelia",
      last_name: "Tan",
      email_address: "amelia.arsenic@angelspit.net",
      phone_number: "0207-456-1234",
      product_loaned: nil )
  end
end
