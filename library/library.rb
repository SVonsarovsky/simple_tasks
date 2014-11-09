class Library

  attr_reader :books, :orders, :readers, :authors
  def initialize
    @books = []
    @orders = []
    @readers = []
    @authors = []
  end

  def add_book(book)
    raise 'Incorrect type of @book param' unless book.instance_of?(Book)
    @books << book
    @authors << book.author unless @authors.include? book.author
  end

  def add_reader(reader)
    raise 'Incorrect type of @reader param' unless reader.instance_of?(Reader)
    @readers << reader
  end

  def add_order(order)
    raise 'Incorrect type of @order param' unless order.instance_of?(Order)
    add_book(order.book) unless @books.include?(order.book)
    add_reader(order.reader) unless @readers.include?(order.reader)
    @orders << order
  end

  def get_the_most_popular_books(cnt = 1)
    books = @orders.map {|order| order.book}
    result = books.uniq.map {|book| [books.count(book), book]}
    return result.sort_by{|k,v| -k}.map{|v| v[1]}[0...cnt]
  end

  # What is the most popular book
  def get_the_most_popular_book
    get_the_most_popular_books()[0]
  end

  # How many people ordered one of the three most popular books
  def get_amount_of_people_who_ordered_books(popular_books_amount = 3)
    unique_readers = []
    for order in @orders
      for popular_book in get_the_most_popular_books(popular_books_amount);
        if order.book == popular_book && !unique_readers.include?(order.reader)
          unique_readers << order.reader
        end
      end
    end
    return unique_readers.length #unique_readers.uniq.length
  end

  # Who often takes the book
  def get_the_biggest_fan_of_book(book, fan_in_order = 0)
    raise 'Incorrect type of @book param' unless book.instance_of?(Book)
    readers = @orders.select{|order| order.book == book}.map{|order| order.reader }
    readers.length <= 0 ? nil : readers.uniq.map{|reader| [readers.count(reader), reader]}.sort_by{|k, v| -k}[fan_in_order][1]
  end

  # Save all Library data to file(s)
  def save_data
    #File.open('./data/orders.yml', 'w') {|f| f.write @orders.to_yaml }
    for attr in instance_variables
      f = File.open(get_file_for_attr(attr), 'w')
      f.write instance_variable_get(:"#{attr}").to_yaml
      f.close
    end
  end

  # Get all Library data from file(s)
  def get_data
    #@orders = YAML.load_file('./data/orders.yml')
    for attr in instance_variables
      v = YAML::load_file(get_file_for_attr(attr))
      instance_variable_set :"#{attr}", v
    end
  end

  private
    def get_file_for_attr(attr)
      File.expand_path(File.dirname(__FILE__))+'/data/'+attr.to_s[1..-1]+'.yml'
    end
end
