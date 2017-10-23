require "test_helper"

describe Product do
  let(:product) { Product.new }

  describe "relationships" do
    it "has many orders through order_items" do
      prod = Product.first
      prod_id = prod.id
      o = Order.new
      o.save!


      prod.must_respond_to :orders
      # prod.orders.must_be :empty?
      # prod.orders.wont_include o
      oi = OrderItem.create!(product_id: prod_id, quantity: 1, order: o)
      prod.orders.must_include o
    end # has many orders through order_items
  end # relationships
end
