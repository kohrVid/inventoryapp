require "./lib/product"
require "./lib/customer"
require "./lib/book"
require "./lib/cd"
require "./lib/toy"

Product.load("./products.yml")
Book.load("./books.yml")
Cd.load("./cds.yml")
Customer.load("./customers.yml")
Toy.load("./toys.yml")


Shoes.app do
  background "images/bg.jpg"#"#000"..."#545454"
  @window = stack do 
    def home
      banner "Inventory", stroke: "#f7f7f7"
      flow do
	para strong "What type of product would you like to search for today?", stroke: "#f7f7f7"
      end

      flow do
	button "All Products" do
	  @window.clear do
	    search(Product)
	    @output = flow do
	      output_grid(Product.all)
	    end
	  end
	end
	button "Books" do
	  @window.clear do
	    search(Book)
	    @output = flow do
	      output_grid(Book.all)
	    end
	  end
	end
	button "CDs" do
	  @window.clear do
	    search(Cd)
	    @output = flow do
	      output_grid(Cd.all)
	    end
	  end
	end
	button "Toys" do
	  @window.clear do
	    search(Toy)
	    @output = flow do
	      output_grid(Toy.all)
	    end
	  end
	end
      end
    end
    home

    def search(klass)
      flow do
	title "#{klass == Cd ? "CD" : klass}s", stroke: "#f7f7f7"
	flow do
	para strong "Search alphabetically, using a search term or the advanced search tool", stroke: "#f7f7f7"
	end
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


    def output_grid(objects)
      if objects == []
	para strong "Nothing to see here", stroke: "#f7f7f7"
      else
	columns = objects.first.instance_variables
	column_width = "#{100/columns.size}%"
	columns.each do |key|
	  stack width: column_width, margin: 10 do
	    para strong key.to_s.gsub("@", ""), stroke: "#f7f7f7"
	    objects.each do |item|
	      flow do
		para strong "#{item.instance_variable_get(key)}", stroke: "#f7f7f7"
	      end
	    end
	  end
	end
      end
    end
  
  end
end
