require "yaml"
module Repository
  include Enumerable

  def self.included(klass)
    klass.extend(ClassMethods)
  end

  module ClassMethods
    def all
      @entries ||= []
    end

    def each
      if block_given?
	all.each {|e| yield(e)}
      else
	all.each
      end
    end

    def count
      all.count
    end

    def act_on_all_repository(item, &block)
      this_class = item.class
      while this_class.included_modules.include?(Repository)
	block.call(this_class, item)
	this_class = this_class.superclass
      end
    end

    def add(item)
     act_on_all_repository(item) { |this_class, i| this_class.all << i }
    end

    def find(id)
      all.select {|item| item.id == id }.first
    end

    def load(file_name)
      delete_all
      all = YAML.load_file(file_name)
      all.each{|item| add(item)}
    end

    def save(file_name)
      file = File.open(file_name, "w")
=begin
      if load.select { |item|
	item.instance_variables.map{|i| item.instand_variable_get(i)}
      } == []
	raise "#{self} already exists"
	file.close
      else
=end
	file.write(all.to_yaml)
	file.close
    #  end
    end

    def delete(id)
      item = self.find(id)
      act_on_all_repository(item) { |this_class, i| this_class.all.delete(item) }
    end

    def delete_all
      @entries = []
    end
  end
end
