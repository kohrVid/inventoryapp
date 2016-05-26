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

  end
end
