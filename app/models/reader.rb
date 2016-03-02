class Reader < ActiveRecord::Base

	has_secure_password

	has_many :reader_books
	has_many :books, through: :reader_books
	
	has_many :categories, through: :books
  has_many :reviews

  def self.valid_params?(params)
    return !params[:username].empty? && !params[:password].empty?
  end

  def books_read_by_others
  	Book.all.uniq - self.books.uniq
  end

  



end