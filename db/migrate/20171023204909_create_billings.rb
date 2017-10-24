class CreateBillings < ActiveRecord::Migration[5.1]
  def change
    create_table :billings do |t|
      t.string :email
      t.string :address
      t.string :cc_name
      t.string :cc_number
      t.date :cc_exp
      t.string :cc_cvv
      t.string :zip
      t.integer :order_id

      t.timestamps
    end
  end
end
