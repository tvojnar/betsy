class CreateProducts < ActiveRecord::Migration[5.1]
  def change
    create_table :products do |t|
      t.integer :merchant_id
      t.integer :inventory
      t.float :price
      t.text :description
      t.boolean :visible, default: true 
      t.string :image_url

      t.timestamps
    end
  end
end
