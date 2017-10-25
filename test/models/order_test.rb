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

    it "has one billing" do
      o = Order.new
      o.save!

      o.must_respond_to :billing
      o.billing.must_equal nil
      b = Billing.create!(order_id: o.id, zip: "123", cc_name: "di", cc_number: "1234", cc_exp: Date.today, cc_cvv: "1234", address: "whatever", email: "yahoo")
      Order.find(o.id).billing.must_equal b
    end

  end # relationships


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
      #TODO: Diane fix this test a la Jaimie
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
      oi2.save!
      puts "OI2.SHIPPED_STATUS #{oi2.shipped_status}"
      o.update_status
      o2 = Order.find(o.id)
      # require 'pry'
      # binding.pry
      Order.find(o2.id).status.must_equal "paid"
    end
  end


  describe "calculate_total" do
    it "will calculate the total when there are items in the order" do
      o = orders(:pending)
      total = 67.75
      o.calculate_total.must_equal total
    end # works when there are items in the cart

    it "will calculate the total as $0 if there are no items in the order" do
      o = orders(:empty)
      total = 0
      o.calculate_total.must_equal total
    end # works when there are no items in the cart
  end # calculate_total

  describe "find_merchants_oi_in_order" do
    it "will print out the correct order_items" do
      merchant = merchants(:tamira)
      oi_1 = order_items(:one)
      oi_2 = order_items(:two)
      oi_3 = order_items(:eleven)
      o = orders(:pending)
      o.find_merchants_oi_in_order(merchant.id).must_be_kind_of Array
      o.find_merchants_oi_in_order(merchant.id).must_include oi_1
      o.find_merchants_oi_in_order(merchant.id).must_include oi_2
      o.find_merchants_oi_in_order(merchant.id).wont_include oi_3

    end # print out the correct order items
  end # find_merchants_oi_in_order
end
