class CreateRepays < ActiveRecord::Migration[5.1]
  def change
    create_table :repays do |t|
      t.string :customer_phone
      t.string :product_code
      t.date :sent_date
      t.date :repay_date
      t.integer :quantity
      t.string :product_status
      t.text :note

      t.timestamps
    end
  end
end
