class CreateOrderItems < ActiveRecord::Migration[5.1]
  def change
    create_table :order_items do |t|
      t.string :product_id
      t.string :order_id
      t.string :quantity
      t.float :cost
      t.boolean :shipped_status, default: false

      t.timestamps
    end
  end
end
