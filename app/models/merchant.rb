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

  def total_revenue
    total = 0
    merchant_order_items = OrderItem.where(merchant_id: params[:id])
    merchant_order_items.each do |item|
      total += item.price
    end
    return total
  end

  def merchant_order_items
    @merchant_order_items = []
    products = Product.where(merchant_id: session[:merchant_id]) #params[:id])
    products.each do |product|
      product.order_items.each do |order_item|
        @merchant_order_items << order_item
      end
    end
    return @merchant_order_items
  end

  def total_revenue_by_status
    @pending_total = 0
    @paid_total = 0
    @shipped_total = 0
    @completed_total = 0
    merchant_order_items.each do |item|
      if item.status == "pending"
        pending_total += item.price
      elsif item.status == "paid"
        paid_total += item.price
      elsif item.status == "shipped"
        shipped_total += item.price
      elsif item.status == "completed"
        completed_total += item.price
      end
    end
  end
end
