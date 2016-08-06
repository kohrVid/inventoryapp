require "./lib/product"
require "./lib/book"
require "./lib/cd"
require "./lib/customer"
require "./lib/product_loan_count"
require "./lib/toy"

Product.load("./products.yml")
Book.load("./books.yml")
Cd.load("./cds.yml")
Customer.load("./customers.yml")
Toy.load("./toys.yml")
$font_colour = "#f7f7f7"


Shoes.app(title: "Inventory", width: 1200) do
  background "#000".."#1eff9e" 
  @window = stack do 
    def home
      banner "Inventory", stroke: $font_colour
      flow do
	para strong "What type of product would you like to search for today?", stroke: $font_colour
      end

      flow margin: 10 do
	button "All Products" do
	  product
	end
	button "Books" do
	  book
	end
	button "CDs" do
	  cd
	end
	button "Toys" do
	  toy
	end
      end
    
      flow margin: 10 do
	button "All Customers" do
	  customer
	end
	button "All Outstanding Loans" do
	  outstanding_loans
	end
      end
    end



    ##Controllers##
    
    def product
      @window.clear do
	search(Product)
	para link(strong "Add new product", stroke: $font_colour).click do
	  @window.clear do
	    new(Product)
	  end
	end
	@output = flow do
	  output_grid(Product.all)
	end
      end
    end
    
    def book
      @window.clear do
	search(Book)
	para link(strong "Add new book", stroke: $font_colour).click do
	  @window.clear do
	    new(Book)
	  end
	end
	@output = flow do
	  output_grid(Book.all)
	end
      end
    end
    
    def cd
      @window.clear do
	search(Cd)
	para link(strong "Add new CD", stroke: $font_colour).click do
	  @window.clear do
	    new(Cd)
	  end
	end
	@output = flow do
	  output_grid(Cd.all)
	end
      end
    end
    
    def customer
      @window.clear do
	search(Customer)
	para link(strong "Add new Customer", stroke: $font_colour).click do
	  @window.clear do
	    new(Customer)
	  end
	end
	@output = flow do
	  output_grid(Customer.all)
	end
      end
    end
    
    def toy
      @window.clear do
	search(Toy)
	para link(strong "Add new toy", stroke: $font_colour).click do
	  @window.clear do
	    new(Toy)
	  end
	end
	@output = flow do
	  output_grid(Toy.all)
	end
      end
    end

    def outstanding_loans
      @window.clear do
	#columns = ProductLoanCount.all.first.product.instance_variables
	columns = Product.instance_vars
	column_width = "#{100/(columns.size + 1)}%"
	title_width = "#{100/(columns.size - 1)}%"
	title "Outstanding Loans", stroke: $font_colour
	para link(strong "Go back home", stroke: $font_colour).click do
	  @window.clear do
	    home
	  end
	end
	flow do
	  ["", "id", "title", "count"].each do |heading|
	    stack width: "#{heading == "title" ? title_width : column_width}", margin: 1 do
	      para strong heading, stroke: $font_colour
	    end
	  end
	  ProductLoanCount.all.each do |row|
	    flow do
	      stack width: column_width do
		para strong "#{row.product.class}", stroke: $font_colour
	      end
	      stack width: column_width do
		para strong "#{row.product.id}", stroke: $font_colour
	      end
	      stack width: title_width do
		para link(strong "#{row.product.title}", stroke: $font_colour).click do
		  @window.clear do
		    show(row.product)
		  end
		end
	      end
	      stack width: column_width do
		para strong "#{row.count}", stroke: $font_colour
	      end
	    end
	  end
	end
      end
    end
    
    home



    ##Partials##

    def search(klass)
      flow do
	title "#{klass == Cd ? "CD" : klass}s", stroke: $font_colour
	flow do
	  para strong "Search alphabetically, using a search term or the advanced search tool", stroke: $font_colour
	end
	flow width: "90%", margin: 5 do
	  @search_input = edit_line width: 100
	  [*"A".."Z"].map do |b|
	    button b do
	      @output.clear do
		output_grid(klass.find_by_letter(b))
	      end
	    end
	  end
	  button "All #{klass}s" do
	    @output.clear do
	      output_grid(klass.all)
	    end
	  end
	  button "Go home" do
	    @window.clear do
	      home
	    end
	  end
	end
      end
    end


    def output_grid(objects)
      if objects == []
	para strong "Nothing to see here", stroke: $font_colour
      else
	columns = objects.first.instance_variables
	column_width = "#{100/(columns.size + 6)}%"
	title_width = "#{100/(columns.size - 1)}%"
	columns.each do |key|
	  stack width: "#{(key == :@description)|| (key == :@title) || (key == :@email_address) || (key == :@product_loaned) || (key == :@phone_number) ? title_width : column_width}", margin: 1 do
	    para strong column_name(key), stroke: $font_colour
	    objects.each do |item|
	      flow width: "100%" do
		if key == :@title
		  para link(strong "#{item.instance_variable_get(key)}", stroke: $font_colour).click do
		    @window.clear do
		      show(item)
		    end
		  end
		elsif key == :@last_name
		  para link(strong "#{item.instance_variable_get(key)}", stroke: $font_colour).click do
		    @window.clear do
		      show(item)
		    end
		  end
		elsif key == :@product_loaned
		  product_loaned = item.instance_variable_get(key)
		  para strong "#{product_loaned.title unless product_loaned.nil?}", stroke: $font_colour
		else
		  para strong "#{item.instance_variable_get(key)}", stroke: $font_colour
		end
	      end
	    end
	  end
	end
	
	stack width: column_width, margin: 1 do
	  para strong "Actions", stroke: $font_colour
	  objects.each do |item|
	    flow width: "300%" do
	      inscription link(strong "Sell/Loan", stroke: $font_colour).click do
		@window.clear do
		  sell_loan(item)
		end
	      end
	      inscription link(strong "Edit", stroke: $font_colour).click do
		@window.clear do
		  edit(item)
		end
	      end
	      inscription link(strong "Delete", stroke: $font_colour).click do
		if confirm("Are you sure you wanna delete this, bruv?")
		  @window.clear do
		    klass = objects.first.class
		    klass.delete(item.id)
		    klass.save(file_name)
		    home
		  end
		end
	      end
	    end
	  end
	end
      end
    end
  end

  def form(hash, item)
    flow do
      item.class.instance_vars.each do |val|
	flow do
	  para strong column_name(val), stroke: $font_colour
	end
	flow do
	  hash[val] = edit_line "#{item.instance_variable_get(to_ivar_name(val))}"
	end
      end
    end
  end


  ##Helpers##

  def column_name(instance_var)
    instance_var.to_s.gsub("@", "").split("_").map(&:capitalize).join(" ")
  end

  def to_ivar_name(instance_var)
    "@#{instance_var.to_s}".to_sym
  end

  def klass_hash
    { 
      Product => Proc.new { product },
      Book => Proc.new { book },
      Toy => Proc.new { toy },
      Cd => Proc.new { cd }
    }
  end
  
  def all_items(klass)
    para link(strong "All #{klass}s", stroke: $font_colour).click do
      klass_hash.each do |k, v|
        v.call if klass == k
      end
    end
  end

  def file_names(klass)
    { 
      Product => "./products.yml",
      Book => "./books.yml", 
      Cd => "./cds.yml", 
      Toy => "./toys.yml", 
      Customer => "./customers.yml"
    }.each do |k,v|
      return v if klass == k
    end
  end


  ##Actions##
  
  def new(klass)
    file_name = file_names(klass)
    title "New #{klass}", stroke: $font_colour
    form(@inventory_create = {}, klass.new())
    flow margin: 5 do
      button "Submit" do
	@inventory_create.map{ |k,v| @inventory_create[k] = v.text }
	klass.add(klass.new(@inventory_create))
	klass.save(file_name)
	@window.clear do
	  klass_hash.each do |k, v|
	    v.call if klass == k 
	  end
	end
      end
    end
    stack margin: 5 do
      all_items(klass)
    end
  end
  
  def edit(item)
    file_name = file_names(item.class)
    title "Edit #{item.title}", stroke: $font_colour
    form(@inventory_update = {}, item)
    stack margin: 5 do
      button "Submit" do
	@inventory_update.map{|k,v| @inventory_update[k] = v.text}
	item.edit(@inventory_update)
	item.class.save(file_name)
	@window.clear do
	  home
	end
      end
    end
    stack margin: 5 do
      all_items(item.class)
    end
  end
  
  def show(item)
    file_name = file_names(item.class)
    flow do
      if item.class == Customer
	title "#{item.full_name}", stroke: $font_colour
      else
	title "#{item.title}", stroke: $font_colour
      end
	
      item.instance_variables.each do |key|
	#key_sym = key.to_s.gsub("@", "").to_sym
	flow do
	  para strong column_name(key), stroke: $font_colour
	end
	flow do
	  para "#{item.instance_variable_get(key)}", stroke: $font_colour
	end
      end
      stack margin: 5 do
	all_items(item.class)
      end
    end
  end
  
  def sell_loan(item)
    file_name = file_names(item.class)
    title "Sell or Loan \"#{item.title}\"", stroke: $font_colour
    subtitle "Sell", stroke: $font_colour
    flow do
      para "Quantity:", stroke: $font_colour
      para
      @quantity = edit_line width: 25
      para
      button "sell" do
	alert(item.sold(@quantity.text.to_i))
	item.class.save(file_name)
	@window.clear do
	  show(item)
	end
      end
    end
    subtitle "Loan", stroke: $font_colour
    para "Select a customer", stroke: $font_colour
    flow do
      @customers = {}
      Customer.all.each{|customer|
	@customers[customer.full_name] = customer
      }
      list_box items: @customers.keys, width: 250, choose: @customers.keys.first do |name|
	key = name.text
	@customer = @customers[key.to_s]
      end
      para
      button "loan" do
       alert(item.loaned_to(@customer))
	item.class.save(file_name)
	Customer.save("./customers.yml")
	@window.clear do
	  show(item)
	end
      end
    end
    stack margin: 5 do
      all_items(item.class)
    end
  end
  
end 
