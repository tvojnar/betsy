class Order < ApplicationRecord
  has_many :order_items
  has_many :products, through: :order_items
  has_one :billing


  def calculate_total
    total = 0
    self.order_items.each do |item|
      total += item.product.price * item.quantity
    end
    return total
  end # calculate_total
#DL ADDED ^ 'RETURN TOTAL' TO CALC TOTAL METHOD FOR ORDER SUMMARY PAGE

  #DL WORKING ON THIS METHOD
  def update_status
    self.order_items.each do |item|
      if item.shipped_status == false
        self.status = "paid"
        self.save
        puts "StATUS = PAID"
        return
      end
    end
    self.status = "shipped"
    self.save
    puts "STATUS = SHIPPED"
  end


end
