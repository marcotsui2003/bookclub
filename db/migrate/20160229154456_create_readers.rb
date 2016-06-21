class CreateReaders < ActiveRecord::Migration
  def change
  	create_table :readers do |t|
  		t.string :username
  		t.string :email
  		t.string :password_digest
  	end
  end
end
