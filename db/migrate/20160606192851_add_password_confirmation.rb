class AddPasswordConfirmation < ActiveRecord::Migration
  def change
    add_column :readers, :password_confirmation, :string 
  end
end
