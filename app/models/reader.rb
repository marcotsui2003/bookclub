class Reader < ActiveRecord::Base

	has_secure_password

	has_many :reviews
	has_many :books, through: :reviews

	has_many :categories, through: :reviews


	validates :username, {presence: true, uniqueness: true}
	validates :password, {presence: true, length:{minimum: 8}, confirmation: true}
  validates :password_confirmation, presence: true

  def self.valid_params?(params)
    return !params[:username].empty? && !params[:password].empty?
  end

  def books_read_by_others
  	Book.all.uniq - self.books.uniq
  end

end


=begin
	create_table "readers", force: :cascade do |t|
		t.string "username"
		t.string "email"
		t.string "password_digest"
		t.string "password_confirmation"
	end
=end
