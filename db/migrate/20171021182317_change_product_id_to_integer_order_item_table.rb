class ChangeProductIdToIntegerOrderItemTable < ActiveRecord::Migration[5.1]
  def change
    change_column :order_items, :product_id,  'integer USING CAST(product_id AS integer)'
  end
end
