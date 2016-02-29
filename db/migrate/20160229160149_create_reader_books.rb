class CreateReaderBooks < ActiveRecord::Migration
  def change
  	create_table :reader_books do |t|
  		t.integer :reader_id
  		t.integer :book_id
  	end
  end
end
