class Review < ActiveRecord::Base

	belongs_to :book, inverse_of: :reviews
	belongs_to :reader, inverse_of: :reviews

	has_many :review_categories
	has_many :categories, through: :review_categories

	def content=(content)
		content.blank? ? super(nil): super(content)
	end

	def category_list
		categories.category_names
	end


end

=begin
	create_table "reviews", force: :cascade do |t|
		t.integer "reader_id"
		t.integer "book_id"
		t.integer "rating"
		t.text    "content"
	end
=end
