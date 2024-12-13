
class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :email, null: false, unique: true
      t.string :password_digest, null: false
      t.string :name
      t.string :surname
      t.string :phone_number
      t.string :role, default: "customer", null: false

      t.timestamps
    end
    add_index :users, :email, unique: true
  end
end
