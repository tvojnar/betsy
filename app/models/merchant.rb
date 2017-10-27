class Merchant < ApplicationRecord
  has_many :products
  validates :name, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true



  def self.from_auth_hash(provider, auth_hash)
    merchant = new
    merchant.provider = provider
    merchant.uid = auth_hash['uid']
    # NOTE: we should only set merchant.name to one thing, and since we don't have a username for merchant, we will just set 'name' to the 'nickname' passed in my rails
    # merchant.name = auth_hash['info']['name']
    merchant.email = auth_hash['info']['email']
    merchant.name = auth_hash['info']['nickname']

    return merchant
  end

  def total_revenue(merchant)
    total = 0
    moi = merchant.merchant_order_items(merchant)
    moi.each do |item|
      total += item.product.price * item.quantity
    end
    return total.round(2)
  end

  def merchant_order_items(merchant)
    merchant_order_items = []
    products = Product.where(merchant_id: merchant.id) #params[:id])
    products.each do |pr|
      pr.order_items.each do |oi|
        merchant_order_items << oi
      end
    end
    return merchant_order_items
  end

  def pending_revenue(merchant)
    pending_total = 0
    merchant_order_items(merchant).each do |item|
      if item.order.status == "pending"
        pending_total += item.quantity * item.product.price
      end
    end
    return pending_total
  end

  def paid_revenue(merchant)
    paid_total = 0
    merchant_order_items(merchant).each do |item|
      if item.order.status == "paid"
        paid_total += item.quantity * item.product.price
      end
    end
    return paid_total
  end

  def shipped_revenue(merchant)
    shipped_total = 0
    merchant_order_items(merchant).each do |item|
      if item.order.status == "shipped"
        shipped_total += item.quantity * item.product.price
      end
    end
    return shipped_total
  end

  def completed_revenue(merchant)
    completed_total = 0
    merchant_order_items(merchant).each do |item|
      if item.order.status == "completed"
        completed_total += item.quantity * item.product.price
      end
    end
    return completed_total
  end

  def pending_number(merchant)
    pending_num = 0
    merchant_order_items(merchant).each do |item|
      if item.order.status == "pending"
        pending_num += 1
      end
    end
    return pending_num
  end



  def paid_number(merchant)
    paid_num = 0
    merchant_order_items(merchant).each do |item|
      if item.order.status == "paid"
        paid_num += 1
      end
    end
    return paid_num
  end

  def shipped_number(merchant)
    shipped_num = 0
    merchant_order_items(merchant).each do |item|
      if item.order.status == "shipped"
        shipped_num += 1
      end
    end
    return shipped_num
  end

  def completed_number(merchant)
    completed_num = 0
    merchant_order_items(merchant).each do |item|
      if item.order.status == "completed"
        completed_num += 1
      end
    end
    return completed_num
  end


  def orders(merchant)
    merchant_orders = []
    merchant_order_items(merchant).each do |item|
      if merchant_orders == []
        merchant_orders << item.order
      end
      merchant_orders.each do |mo|
        if item.order != mo
          merchant_orders << item.order
        end
      end
    end
    return merchant_orders
  end

  # def total_revenue_by_status(merchant)
  #   @pending_total = 0
  #   @paid_total = 0
  #   @shipped_total = 0
  #   @completed_total = 0
  #   @pending_number = 0
  #   @paid_number = 0
  #   @shipped_number = 0
  #   @completed_number = 0
  #
  #   merchant_order_items(merchant).each do |item|
  #     #If the order that is contained in the order_item status is pending
  #     if Order.find_by(id: item.order_id) == "pending"
  #       @pending_total += item.quantity * item.product.price
  #       @pending_number += 1
  #     elsif Order.find_by(id: item.order_id) == "paid"
  #       @pending_total += item.quantity * item.product.price
  #       @paid_number += 1
  #     elsif Order.find_by(id: item.order_id) == "shipped"
  #       @pending_total += item.quantity * item.product.price
  #       @shipped_number += 1
  #     elsif Order.find_by(id: item.order_id) == "completed"
  #       @pending_total += item.quantity * item.product.price
  #       @completed_number += 1
  #     end
  #   end
  # end

end
