class Category < ActiveRecord::Base

	has_many :review_categories
	has_many :reviews, through: :review_categories

	has_many :books, through: :reviews
	has_many :readers, through: :reviews

end
