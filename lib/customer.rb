require "./lib/repository"
class Customer
  include Repository
  attr_reader :id
  attr_accessor :first_name, :last_name, :email_address, :phone_number, :product_loaned
  @@count = 0
  def initialize(params = {})
    @id = (@@count += 1)
    params.each do |k,v|
      self.instance_variable_set "@#{k.to_s}", v
    end
  end

  def self.instance_vars
    [:first_name, :last_name, :email_address, :phone_number, :product_loaned] 
  end

  def edit(params ={})
    params.each do |k, v|
      self.instance_variable_set "@#{k.to_s}", v
    end
  end

  def full_name
    "#{self.first_name} #{self.last_name}"
  end

  def self.find_by_first_name(search_term)
    Customer.all.select {|customer| customer.class == Customer && customer.first_name.include?(search_term) }
  end
  
  def self.find_by_last_name(search_term)
    Customer.all.select {|customer| customer.class == Customer && customer.last_name.include?(search_term) }
  end
end
