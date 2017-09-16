class AddColumnsToOrder < ActiveRecord::Migration[5.1]
  def change
    add_column :orders, :customer_email, :string
    add_column :orders, :customer_birthday, :string
    add_column :orders, :customer_address, :string
  end
end
