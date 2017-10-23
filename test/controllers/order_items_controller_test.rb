require "test_helper"

describe OrderItemsController do
  describe "create" do
    it "will add an order_item and create a new instance of Order if the product exists" do
      start_num_itmes = OrderItem.count
      start_orders = Order.count
      id = Product.first.id
      item_params = {
        order_item: {
          quantity: 1,
          product_id: id
        }
      }

      post order_items_path, params: item_params

      must_respond_with :redirect
      # TODO: change this when we decide where to redirect to!
      must_redirect_to root_path
      # check that a new OrderItem was created
      OrderItem.count.must_equal start_num_itmes + 1
      # check that a new Order was created
      Order.count.must_equal start_orders + 1
      # TODO: figure out why this is returning a string! The id # is the same but the 'actual' is a string and the expected is an integer....
      Order.last.order_items.first.product_id.must_equal id
    end

    it "won't add a order_item or save the order if the product doesn't exist" do
      start_num_itmes = OrderItem.count
      start_orders = Order.count
      id = Product.last.id + 1
      item_params = {
        order_item: {
          quantity: 1,
          product_id: id
        }
      }

      post order_items_path, params: item_params
      must_respond_with :not_found
      OrderItem.count.must_equal start_num_itmes
      Order.count.must_equal start_orders
    end # won't add if product doesn't exist

    it "wont add the product if inventory = 0 " do
      start_num_itmes = OrderItem.count
      start_orders = Order.count
      prod = products(:tulip_bulb)
      item_params = {
        order_item: {
          quantity: 1,
          product_id: prod.id
        }
      }

      post order_items_path, params: item_params
      # QUESTION: is not_found the right way to do this?
      must_respond_with :redirect
      flash[:message].must_equal "Sorry, there isn't enough stock. There are 0 Tulip bulb's in stock."
      must_redirect_to product_path(prod)
      OrderItem.count.must_equal start_num_itmes
      Order.count.must_equal start_orders
    end # only add if stock is at 0

    it "won't add the product to the OrderItem if quantity requested > inventory" do
      start_num_itmes = OrderItem.count
      start_orders = Order.count
      prod = products(:spider_plant)
      item_params = {
        order_item: {
          quantity: 11,
          product_id: prod.id
        }
      }

      post order_items_path, params: item_params
      # QUESTION: is not_found the right way to do this?
      must_respond_with :redirect
      # TODO: test the flash message!
      flash[:message].must_equal "Sorry, there isn't enough stock. There are 5 Spider Plant's in stock."
      must_redirect_to product_path(prod)
      OrderItem.count.must_equal start_num_itmes
      Order.count.must_equal start_orders
    end # won't add if quantity < inventory
  end # create

  describe "destroy" do
    it "returns success and deletes the order_item when given a valid order_item ID" do
      count = OrderItem.count
      oi = OrderItem.first

      delete order_item_path(oi)

      must_respond_with :redirect
      must_redirect_to order_path(oi.order.id)
      OrderItem.count.must_equal count - 1
    end # works when given valid order_item

    it "wont delete the OrderItem if the OrderItem doesn't exist" do
      count = OrderItem.count
      id = OrderItem.last.id + 1

      delete order_item_path(id)

      must_respond_with :not_found
      OrderItem.count.must_equal count
    end # wont delete the OrderItem if the OrderItem doesn't exist
  end # destroy

  describe "mark_shipped" do
    it "marks an order item that belongs to a paid order as shipped" do
      #I DONT KNOW WHY THIS IS FAILING, THE SHIPPED STATUS SAVES IN THE MARK_SHIPPED METHODDDDD
      oi = order_items(:four)
      puts "********************************************* "
      puts oi.order.status
      oi.shipped_status.must_equal false
      patch mark_order_item_path(oi.id)
      must_redirect_to root_path
      oi.shipped_status.must_equal true
    end

    it "will not mark an orderitem that belongs to a pending, shipped, or complete order as shipped" do
      oi = order_items(:one)
      oi.shipped_status.must_equal false
      patch mark_order_item_path(oi.id)
      oi.shipped_status.must_equal false

    end # it
  end # destroy

  describe "update" do
    let(:oi) { order_items(:ten)}
    let(:update_data) {{
        order_item:   {
          quantity: 3
        }
}}
    it "will change the quantity if the OrderItem exists" do
      id = Product.first.id
      item_params = {
        order_item: {
          quantity: 1,
          product_id: id
        }
      }

      post order_items_path, params: item_params
      cart = Order.find_by(id: session[:order_id])

      patch order_item_path(oi), params: update_data
      must_respond_with :redirect
      must_redirect_to order_path(cart)
      oi.quantity.must_equal 3

    end # change q if OI exists in O

    it "won't change the quantity if the OrderItem doesn't exist" do
      oi_id = OrderItem.last.id + 1

      patch order_item_path(oi_id), params: update_data

      must_respond_with :not_found
      
      # TODO
    end # wont change q if OI isn't in order
    # it "returns success when passed valid order_id" do
  end # update

end #OrderItemsController
