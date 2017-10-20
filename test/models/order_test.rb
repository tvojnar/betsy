require "test_helper"

describe Order do
  let(:order) { Order.new }

  describe "validations" do
    it "has a collection of order items" do
      p_id = Product.first.id
      o = Order.new
      o.save!
      puts "*" * 50
      puts o.inspect
      puts o.class
      puts "=" * 50

      o.must_respond_to :order_items
      o.order_items.must_be :empty?
      # QUESTION: why does oi not get created and
      oi = OrderItem.create!(product_id: p_id, quantity: 1, order: o)
      puts "%" * 50
      puts oi.inspect
      puts oi.class
      puts "&" * 50
      # o.order_items << oi
      o.order_items.must_include oi
    end
  end
end
