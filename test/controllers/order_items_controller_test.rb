require "test_helper"

describe OrderItemsController do
  describe "create" do
    it "will add an instock order_item and create a new instance of Order if the product exists" do
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
      # check that it was in stocl
      puts "+" * 50
      puts Order.last.order_items.first.quantity
      puts "=" * 50
    end # will add an instock product to an Order

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
      # QUESTION: is not_found the right way to do this?
      must_respond_with :redirect
      must_redirect_to root_path
      OrderItem.count.must_equal start_num_itmes
      Order.count.must_equal start_orders
    end # won't add if product doesn't exist

    it "will only add products that are in stock to an Order via an OrderItem" do
    end # only add in stock products

    it "won't add a product if the quantity is more than the stock" do
      # TODO
    end # won't add product if quantity > stock

    it "will only add a product to an OrderItem if quntity is > 0" do
      # TODO
    end # only adds product if quantity is > 0
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



end #OrderItemsController
