class AddNullFalseToUidInMerchant < ActiveRecord::Migration[5.1]
  def change
    change_column :merchants, :uid, :string, null: false 
  end
end
