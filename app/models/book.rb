class Book < ActiveRecord::Base


	has_many :reviews
	has_many :readers, through: :reviews

	has_many :categories, -> { distinct }, through: :reviews

	validates :title, {presence: true, uniqueness: true}


  #cannot use self.title = title.strip.titlecase
	def title=(title)
	    super(standardize_title(title))
			#self[:title] = title.strip
	end

  def category_array
  	categories.map(&:name).uniq
  end

	def category_list
		categories.category_names
	end

  private
	def standardize_title(title)
		title.strip.downcase.titlecase
	end
	
end

=begin
	create_table "books", force: :cascade do |t|
		t.string "title"
	end
=end
