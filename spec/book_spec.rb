require "minitest/autorun"
require "minitest/pride"
require "./lib/book"

class BookSpec < MiniTest::Spec
  before do
    @book = Book.new({title: "Debt: The First 5000 Years", author: "David Graeber", description: "Book about the origins of money and debt", genre: "Anthropology"})
    @book2 = Book.new({title: "The Second Sex", author: "Simone de Beauvoir", description: "A book about women", genre: "Anthropology/Philosophy"})
  end

  describe Book do
    it "should have a unique auto-generated ID" do
      @book.id.wont_be_nil
      @book2.id.wont_be_nil
      @book.id.wont_equal @book2.id
    end

    it "should have a title" do
      @book.title.wont_be_nil
    end

    it "should have a author" do
      @book.author.wont_be_nil
    end

    it "should have a description" do
      @book.description.wont_be_nil
    end

    it "should have a genre" do
      @book.genre.wont_be_nil
    end
    
    describe "CRUD methods" do
      it "should load books" do
	original_count = Book.count
	Book.add(@book)
	Book.add(@book2)
	Book.load("./book.yml")
	Book.count.must_equal original_count + 2
      end

      it "should save books" do
	File.delete("./book.yml") if File.exist?("./book.yml")
	original_count = Book.count
	Book.add(@book)
	Book.add(@book2)
	Book.save("./book.yml")
	Book.count.must_equal original_count + 2
	File.exist?("./book.yml").must_equal true
      end

      it "should be able to delete a book" do
	Book.add(@book)
	Book.add(@book2)
	Book.delete(@book.id)
	Book.all.wont_include(@book)
      end
    end
  end
end
