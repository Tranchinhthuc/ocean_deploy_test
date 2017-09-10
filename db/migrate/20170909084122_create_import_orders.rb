class CreateImportOrders < ActiveRecord::Migration[5.1]
  def change
    create_table :import_orders do |t|
      t.string :product_code
      t.integer :product_type
      t.integer :quantity
      t.date :import_date

      t.timestamps
    end
  end
end
