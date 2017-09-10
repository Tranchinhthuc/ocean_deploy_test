class CreateProducts < ActiveRecord::Migration[5.1]
  def change
    create_table :products do |t|
      t.string :code
      t.string :colors
      t.float :cost
      t.integer :bought_quantity
      t.integer :remain_quantity
      t.integer :category_id
      t.integer :note
      t.integer :product_type

      t.timestamps
    end
  end
end
