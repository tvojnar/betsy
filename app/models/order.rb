class Order < ApplicationRecord
  has_many :order_items



def calculate_total
  total = 0
  self.order_items.each do |item|
    total += item.product.price * item.quantity
  end
end # calculate_total




end
