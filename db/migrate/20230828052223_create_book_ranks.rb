class CreateBookRanks < ActiveRecord::Migration[7.0]
  def change
    create_table :book_ranks do |t|
      t.references :book, null: true, foreign_key: true
      t.references :rank, null: true, foreign_key: true
      t.integer :view
      t.integer :order_id

      t.timestamps
    end
  end
end
