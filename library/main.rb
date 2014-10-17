require File.expand_path(File.dirname(__FILE__)) + '/author'
require File.expand_path(File.dirname(__FILE__)) + '/book'
require File.expand_path(File.dirname(__FILE__)) + '/reader'
require File.expand_path(File.dirname(__FILE__)) + '/order'
require File.expand_path(File.dirname(__FILE__)) + '/library'
require 'yaml'

# ----------------------------------------------------------------------------------------------------------------------
author1 = Author.new('Nick Hornby');
book1 = Book.new('About A Boy', author1);
book2 = Book.new('How To Be Good', author1);
reader1 = Reader.new('Sergey V.', 's_vonsarov@mail.ru');
reader2 = Reader.new('Ivan D.', 'ivan@mail.ru');

library = Library.new
#library.add_order(Order.new(book1, reader1))
#library.add_order(Order.new(book2, reader1))
#library.add_order(Order.new(book1, reader2))
#library.add_order(Order.new(book2, reader2))
#library.add_order(Order.new(book2, reader2))
library.get_data

reader = library.get_the_biggest_fan_of_book(book2)
if reader.nil?
  puts 'Nobody ordered ' + book2
else
  puts 'The biggest fan of ' + book2 +' is ' + reader
end

book = library.get_the_most_popular_book
if book.nil?
  puts 'There are no books ordered'
else
  puts 'The most popular book is ' + book
end

people_amount = library.get_amount_of_people_who_ordered_books(1).to_s
puts 'The amount of people ordered one of the three most popular books is ' + people_amount

#library.save_data