require "test_helper"

describe Order do
  let(:order) { Order.new }

  describe "relationships" do
    it "has a collection of order items" do
      p_id = Product.first.id
      o = Order.new
      o.save!


      o.must_respond_to :order_items
      o.order_items.must_be :empty?
      oi = OrderItem.create!(product_id: p_id, quantity: 1, order: o)
      puts "%" * 50
      puts oi.inspect
      puts oi.class
      puts "&" * 50
      # o.order_items << oi
      o.order_items.must_include oi
    end

    it "has a collection of products through order_item" do
      p_id = Product.first.id
      o = Order.new
      o.save!


      o.must_respond_to :products
      o.products.must_be :empty?
      o.products.wont_include Product.first
      oi = OrderItem.create!(product_id: p_id, quantity: 1, order: o)
      o.products.must_include Product.first
    end # it has a collection of producs
  end # relationships
end
