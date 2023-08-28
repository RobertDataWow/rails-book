class AddUserToBook < ActiveRecord::Migration[7.0]
  def change
    add_reference :books, :user, null: true, foreign_key: true
    add_reference :reviews, :user, null: true, foreign_key: true
  end
end
