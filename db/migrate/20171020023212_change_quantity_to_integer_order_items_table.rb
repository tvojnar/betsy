class ChangeQuantityToIntegerOrderItemsTable < ActiveRecord::Migration[5.1]
  def change
    change_column :order_items, :quantity,  'integer USING CAST(quantity AS integer)'
  end
end
