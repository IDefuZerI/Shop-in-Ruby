class CreateProducts < ActiveRecord::Migration[7.0]
  def change
    create_table :products do |t|
      t.string :name
      t.text :description
      t.decimal :price
      t.references :category, null: false, foreign_key: true
      t.integer :weight
      t.text :ingredients
      t.string :manufacturer
      t.string :origin_country
      t.string :image
      t.datetime :added_at

      t.timestamps
    end
  end
end
