class CreateOrderColors < ActiveRecord::Migration[5.1]
  def change
    create_table :order_colors do |t|
      t.integer :quantity
      t.string :product_code
      t.string :color
      t.integer :target_id
      t.string :target_type

      t.timestamps
    end
  end
end
