class Reader < ActiveRecord::Base

	has_secure_password
	has_many :reader_books
	has_many :books, through: :reader_books
	has_many :categories, through: :books

end