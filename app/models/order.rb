class Order < ApplicationRecord
  has_many :order_items



  def calculate_total
    total = 0
    self.order_items.each do |item|
      total += item.product.price * item.quantity
    end
  end # calculate_total

  #DL WORKING ON THIS METHOD
  def update_status
    self.order_items.each do |item|
      if item.shipped_status == false
        # require 'pry'
        # binding.pry
        self.status = "paid"
        self.save
        return
      end
    end
    self.status = "shipped"
    return self.save

  end


end
