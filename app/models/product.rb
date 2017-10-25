class Product < ApplicationRecord
  belongs_to :merchant
  has_and_belongs_to_many :categories
  has_many :order_items
  has_many :reviews
  has_many :orders, through: :order_items

  validates :name, presence: {message: "A product must have a name."}, uniqueness: true
  validates :price, presence: {message: "A product must have a price."}, numericality: { only_float: true, greater_than: 0 }
  validates :inventory, presence: true, numericality: {only_integer: true, greater_than: - 1}


  def self.reduce_inventory(order)
    order.order_items.each do |item|
      puts item
      puts item.product.name
      puts item.product.inventory
      item.product.inventory -= item.quantity
      item.product.save
    end
  end



end
