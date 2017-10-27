class Order < ApplicationRecord
  has_many :order_items
  has_many :products, through: :order_items
  has_one :billing

  def self.filter_by_merchant(merchant_id)
    m_o = []
    all_orders = Order.all
    all_orders.each do |order|
      order.order_items.each do |oi|
        if oi.product
          if oi.product.merchant_id == merchant_id
            if !(m_o.include?(order))
              m_o << order
            end
          end
        end # if
      end  # .each
    end  # .each
    return m_o
  end # self.filter_by_merchant

  def self.filter_by_status(o, status)
    by_status = []
    o.each do |item|
      if item.status == status
        if !(by_status.include?(item))
          by_status << item
        end
      end
    end
    return by_status
  end


  def find_merchants_oi_in_order(session)
    m_order_items = []
    self.order_items.each do |oi|
      if oi.product.merchant_id == session
        m_order_items << oi
      end # if
    end # .each
    return m_order_items
  end

  def calculate_total
    total = 0
    self.order_items.each do |item|
      total += item.product.price * item.quantity
    end
    return total.round(2)
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
