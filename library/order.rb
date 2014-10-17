class Order

  attr_accessor :book, :reader, :date

  def initialize(book, reader, date = Time.now)
    unless book.instance_of?(Book)
      raise 'Incorrect type of @book param'
    end
    unless reader.instance_of?(Reader)
      raise 'Incorrect type of @reader param'
    end
    @book = book
    @reader = reader
    @date = date
  end
end
