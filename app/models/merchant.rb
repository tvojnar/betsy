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
    # merchant_products = Product.where()
    # merchant_order_items = OrderItem.where(product_id:  #is the same as the merchant.id)
    if moi
    moi.each do |item|
      total += 0#item.cost
    end
  end
    return total
  end

  def merchant_order_items(merchant)
    merchant_order_items = []
    products = Product.where(merchant_id: merchant.id) #params[:id])
    products.each do |product|
      product.order_items.each do |order_item|
        merchant_order_items << order_item
      end
    end
    return merchant_order_items
  end

  def total_revenue_by_status(merchant)
    @pending_total = 0
    @paid_total = 0
    @shipped_total = 0
    @completed_total = 0
    @pending_number = 0
    @paid_number = 0
    @shipped_number = 0
    @completed_number = 0

    merchant_order_items(merchant).each do |item|
      if item.shipped_status == "pending"
        @pending_total += item.price
        @pending_number += 1
      elsif item.shipped_status == "paid"
        @paid_total += item.price
        @paid_number += 1
      elsif item.shipped_status == "shipped"
        @shipped_total += item.price
        @shipped_number += 1
      elsif item.shipped_status == "completed"
        @completed_total += item.price
        @completed_number += 1
      end
    end
  end
end
