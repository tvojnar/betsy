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


  describe "update_status" do
    it "changes order status to shipped if all order items are shipped" do
      o = Order.new(status: "paid")
      oi = OrderItem.create!(product_id: Product.first.id, quantity: 1, order: o)
      oi2 = OrderItem.create!(product_id: Product.last.id, quantity: 5, order: o)
      oi.shipped_status = true
      oi.save
      oi2.shipped_status = true
      oi2.save
      o.status.must_equal "paid"
      o.update_status
      o.status.must_equal "shipped"
    end

    it "does not change order status to shipped if not all order items are shipped" do
      o = Order.new(status: "paid")
      oi = OrderItem.create!(product_id: Product.first.id, quantity: 1, order: o)
      oi2 = OrderItem.create!(product_id: Product.last.id, quantity: 5, order: o)
      oi.shipped_status = true
      oi.save
      oi2.shipped_status = false
      oi2.save
      o.status.must_equal "paid"
      o.update_status
      o.status.must_equal "paid"
    end

    it "changes order status back to paid if one or more order items are unmarked as shipped" do
      o = Order.new(status: "paid")
      oi = OrderItem.create!(product_id: Product.first.id, quantity: 1, order: o)
      oi2 = OrderItem.create!(product_id: Product.last.id, quantity: 5, order: o)
      oi.shipped_status = true
      oi.save
      oi2.shipped_status = true
      oi2.save
      o.status.must_equal "paid"
      o.update_status
      o.status.must_equal "shipped"
      oi2.shipped_status = false
      oi2.save
      o.update_status
      o.status.must_equal "paid"
    end


  end

end
