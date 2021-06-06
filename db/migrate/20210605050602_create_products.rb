class CreateProducts < ActiveRecord::Migration[6.1]
  def change
    create_table :products do |t|
      t.string :price_list
      t.string :brand, null: false
      t.string :code, null: false
      t.integer :stock, default: 0, null: false
      t.decimal :cost, precision: 12, scale: 2, null: false
      t.string :name

      t.timestamps
    end
    add_index :products, [:code, :brand, :price_list], unique: true
    add_index :products, :price_list
  end
end
