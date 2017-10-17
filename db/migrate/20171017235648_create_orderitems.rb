class CreateOrderitems < ActiveRecord::Migration[5.1]
  def change
    create_table :orderitems do |t|
      t.integer :product_id
      t.integer :order_id
      t.integer :quantity
      t.float :cost
      t.boolean :shipped_status, default: false

      t.timestamps
    end
  end
end
