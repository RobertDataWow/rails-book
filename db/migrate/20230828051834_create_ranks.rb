class CreateRanks < ActiveRecord::Migration[7.0]
  def change
    create_table :ranks do |t|
      t.datetime :date
    end
  end
end
