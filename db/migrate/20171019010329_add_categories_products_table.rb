class AddCategoriesProductsTable < ActiveRecord::Migration[5.1]
  def change
    create_table :categories_products do |t|
      t.integer :category_id
      t.integer :product_id
  
      t.timestamps
    end
  end
end
