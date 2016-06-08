class Review < ActiveRecord::Base

	belongs_to :book
	belongs_to :reader

	has_many :review_categories
	has_many :categories, through: :review_categories

	def content=(content)
		if content.blank?
			super(nil)
		else
			super(content)
		end
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
