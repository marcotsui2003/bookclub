class Book < ActiveRecord::Base

	has_many :reader_books
	has_many :readers, through: :reader_books

	has_many :book_categories
	has_many :categories, through: :book_categories

end
