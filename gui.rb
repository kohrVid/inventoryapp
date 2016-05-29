require "./lib/product"
require "./lib/book"
require "./lib/cd"
require "./lib/customer"
require "./lib/toy"

Product.load("./products.yml")
Book.load("./books.yml")
Cd.load("./cds.yml")
Customer.load("./customers.yml")
Toy.load("./toys.yml")


Shoes.app(title: "Inventory", width: 1200) do
  background "#000".."#1eff9e" 
  @window = stack do 
    def home
      banner "Inventory", stroke: "#f7f7f7"
      flow do
	para strong "What type of product would you like to search for today?", stroke: "#f7f7f7"
      end

      flow do
	button "All Products", background: "#f00" do
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
    end
    
    def product
      @window.clear do
	search(Product, "./products.yml")
	para link(strong "Add new product", stroke: "#f7f7f7").click do
	  @window.clear do
	    new(Product, "./products.yml")
	  end
	end
	@output = flow do
	  output_grid(Product.all, "./products.yml")
	end
      end
    end
    def book
      @window.clear do
	search(Book, "./books.yml")
	para link(strong "Add new book", stroke: "#f7f7f7").click do
	  @window.clear do
	    new(Book, "./books.yml")
	  end
	end
	@output = flow do
	  output_grid(Book.all, "./books.yml")
	end
      end
    end
    def cd
      @window.clear do
	search(Cd, "./cds.yml")
	para link(strong "Add new CD", stroke: "#f7f7f7").click do
	  @window.clear do
	    new(Cd, "./cds.yml")
	  end
	end
	@output = flow do
	  output_grid(Cd.all, "./cds.yml")
	end
      end
    end
    def toy
      @window.clear do
	search(Toy, "./toys.yml")
	para link(strong "Add new toy", stroke: "#f7f7f7").click do
	  @window.clear do
	    new(Toy, "./toys.yml")
	  end
	end
	@output = flow do
	  output_grid(Toy.all, "./toys.yml")
	end
      end
    end
    
    home

    def search(klass, file_name)
      flow do
	title "#{klass == Cd ? "CD" : klass}s", stroke: "#f7f7f7"
	flow do
	  para strong "Search alphabetically, using a search term or the advanced search tool", stroke: "#f7f7f7"
	end
	flow width: "90%", margin: 5 do
	  @search_input = edit_line width: 100
	  [*"A".."Z"].map do |b|
	    button b do
	      @output.clear do
		output_grid(klass.find_by_letter(b), file_name)
	      end
	    end
	  end
	  button "All #{klass}s" do
	    @output.clear do
	      output_grid(klass.all, file_name)
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


    def output_grid(objects, file_name)
      if objects == []
	para strong "Nothing to see here", stroke: "#f7f7f7"
      else
	columns = objects.first.instance_variables
	column_width = "#{100/(columns.size + 6)}%"
	title_width = "#{100/(columns.size - 1)}%"
	columns.each do |key|
	  stack width: "#{(key == :@description)|| (key == :@title) ? title_width : column_width}", margin: 1 do
	    para strong key.to_s.gsub("@", ""), stroke: "#f7f7f7"
	    objects.each do |item|
	      flow width: "100%" do
		if key == :@title
		  para link(strong "#{item.instance_variable_get(key)}", stroke: "#f7f7f7").click do
		    @window.clear do
		      show(item, file_name)
		    end
		  end
		else
		  para strong "#{item.instance_variable_get(key)}", stroke: "#f7f7f7"
		end
	      end
	    end
	  end
	end
	
	stack width: column_width, margin: 1 do
	  para strong "Actions", stroke: "#f7f7f7"
	  objects.each do |item|
	    flow width: "300%" do
	      inscription link(strong "Sell/Loan", stroke: "#f7f7f7").click do
		@window.clear do
		  sell_loan(item, file_name)
		end
	      end
	      inscription link(strong "Edit", stroke: "#f7f7f7").click do
		@window.clear do
		  edit(item, file_name)
		end
	      end
	      inscription link(strong "Delete", stroke: "#f7f7f7").click do
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
      item.instance_variables.each do |key|
	key_sym = key.to_s.gsub("@", "").to_sym
	unless key == :@id
	  flow do
	    para strong key.to_s.gsub("@", ""), stroke: "#f7f7f7"
	  end
	  flow do
	    hash[key_sym] = edit_line "#{item.instance_variable_get(key)}"
	  end
	end
      end
    end
  end
  
  def all_items(item)
    para link(strong "All #{item.class}s", stroke: "#f7f7f7").click do
      if item.class == Product
	product
      elsif item.class == Book
	book
      elsif item.class == Cd
	cd
      elsif item.class == Toy
	toy
      end
    end
  end

  def new(klass, file_name)
    title "New #{klass}", stroke: "#f7f7f7"
    instance_vars  = klass.all.first.instance_variables.map{|i| i.to_s.gsub("@","").to_sym}.reject{|i| i == :id}
    form(@inventory_create = {}, klass.new(instance_vars))
    flow do
      button "Submit" do
	@inventory_create.map{|k,v| @inventory_create[k] = v.text}
	klass.add(klass.new(@inventory_create))
	klass.save(file_name)
	@window.clear do
	  if klass == Product
	    product
	  elsif klass == Book
	    book
	  elsif klass == Cd
	    cd
	  elsif klass == Toy
	    toy
	  end
	end
      end
    end
    stack margin: 5 do
      all_items(klass.all.first)
    end
  end
  
  def edit(item, file_name)
    title "Edit #{item.title}", stroke: "#f7f7f7"
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
      all_items(item)
    end
  end
  
  def show(item, file_name)
    flow do
      title "#{item.title}", stroke: "#f7f7f7"
      item.instance_variables.each do |key|
	key_sym = key.to_s.gsub("@", "").to_sym
	flow do
	  para strong key.to_s.gsub("@", ""), stroke: "#f7f7f7"
	end
	flow do
	  para "#{item.instance_variable_get(key)}", stroke: "#f7f7f7"
	end
      end
      stack margin: 5 do
	all_items(item)
      end
    end
  end
  
  def sell_loan(item, file_name)
    title "Sell or Loan \"#{item.title}\"", stroke: "#f7f7f7"
    subtitle "Sell", stroke: "#f7f7f7"
    flow do
      para "Quantity:", stroke: "#f7f7f7"
      para
      @quantity = edit_line width: 25
      para
      button "sell" do
	alert(item.sold(@quantity.text.to_i))
	item.class.save(file_name)
	@window.clear do
	  show(item, file_name)
	end
      end
    end
    subtitle "Loan", stroke: "#f7f7f7"
    para "Select a customer", stroke: "#f7f7f7"
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
	  show(item, file_name)
	end
      end
    end
    stack margin: 5 do
      all_items(item)
    end
  end
  
end 
