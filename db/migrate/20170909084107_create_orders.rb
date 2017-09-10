class CreateOrders < ActiveRecord::Migration[5.1]
  def change
    create_table :orders do |t|
      t.string :customer_name
      t.string :product_code
      t.string :ship_code
      t.string :customer_phone
      t.string :product_cost
      t.string :ship_cost
      t.date :sent_date
      t.text :note
      t.integer :product_type
      t.integer :quantity

      t.timestamps
    end
  end
end
