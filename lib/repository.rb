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

    def add(item)
      all << item
    end

    def find(id)
      all.select {|item| item.id == id }.first
    end

    def save
      file = File.open("./entries.yml", "w")
      file.write(all.to_yaml)
      file.close
    end

    def load
      all = YAML.load_file("./entries.yml")
    end

    def delete(id)
      all.delete_if {|item| item.id == id}
    end

    def delete_all
      @entries = []
    end
  end
end
