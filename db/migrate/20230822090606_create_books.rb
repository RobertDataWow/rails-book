class CreateBooks < ActiveRecord::Migration[7.0]
  def change
    create_table :books do |t|
      t.string :name, null: false, default: ''
      t.text :description
      t.datetime :release, null: false

      t.timestamps
    end
  end
end