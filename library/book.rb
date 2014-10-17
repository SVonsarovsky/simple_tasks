class Book

  attr_accessor :title, :author

  def initialize(title, author)
    unless author.instance_of?(Author)
      raise 'Incorrect type of @author param'
    end
    @title = title
    @author = author
  end
  def ==(other_book)
    unless other_book.instance_of?(Book)
      raise 'Incorrect type of @other_book param'
    end
    return (@title == other_book.title && @author.name == other_book.author.name)
  end
  def to_s
    '<"' +@title + '"' +' by ' + @author.name + '>'
  end
  def to_str
    to_s
  end
end
