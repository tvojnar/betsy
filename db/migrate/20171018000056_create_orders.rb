class CreateOrders < ActiveRecord::Migration[5.1]
  def change
    create_table :orders do |t|
      t.string :email
      t.string :address
      t.string :cc_name
      t.string :cc_number
      t.date :cc_exp
      t.string :cc_cvv
      t.string :zip
      t.string :status, default: "pending"
      t.date :date_submitted

      t.timestamps
    end
  end
end
