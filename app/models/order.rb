class Order < ApplicationRecord
  has_many :order_items
  has_many :products, through: :order_items

  # validates :cc_name, presence: true
  # validates :cc_number, presence: true
  # validates :cc_



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
        self.status = "paid"
        self.save
        return
      end
    end
    self.status = "shipped"
    self.save
  end


end
