class Book < ActiveRecord::Base

	has_many :reader_books
	has_many :readers, through: :reader_books

	has_many :book_categories
	has_many :categories, -> { distinct }, through: :book_categories

	has_many :reviews

	validates :title, {presence: true, uniqueness: true}



	def self.valid_params?(params)
    return !params[:title].empty?
  end

  def categories_list
  	self.categories.map {|category| category.name}
  end

end

=begin
	create_table "books", force: :cascade do |t|
		t.string "title"
	end
=end
