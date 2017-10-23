class ChangeOrderIdInOrderItemsToInteger < ActiveRecord::Migration[5.1]
  def change
    change_column :order_items, :order_id,  'integer USING CAST(order_id AS integer)'

  end
end
