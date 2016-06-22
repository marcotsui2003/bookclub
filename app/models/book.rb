class Book < ActiveRecord::Base


	has_many :reviews
	has_many :readers, through: :reviews

	has_many :categories, -> { distinct }, through: :reviews

	validates :title, {presence: true, uniqueness: true}


  #cannot use self.title = title.strip.titlecase
	def title=(title)
	    super(title.strip.titlecase)
			#self[:title] = title.strip
	end

	#def categories
	#	super.uniq
	#end

  def category_array
  	categories.map(&:name).uniq
  end

	def category_list
		categories.category_names
	end



end

=begin
	create_table "books", force: :cascade do |t|
		t.string "title"
	end
=end
