class RemoveUserInfoFromOrder < ActiveRecord::Migration[5.1]
  def change
    remove_column :orders, :cc_name
    remove_column :orders, :address
    remove_column :orders, :email
    remove_column :orders, :cc_number
    remove_column :orders, :cc_exp
    remove_column :orders, :cc_cvv
    remove_column :orders, :zip
  end
end
