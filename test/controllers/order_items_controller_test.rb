require "test_helper"

describe OrderItemsController do
  describe "create" do
    # TODO: get some pointers on how to test this better and make the test pass... QUESTION: why can't this test access the current_order method??!!
    # just look at the numer of instances in hte order_items table before and after the post
    # TODO: can i look at Order.last to see if it has the right product in it?
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
      # QUESTION: is not_found the right way to do this?
      # must_respond_with :not_found
      OrderItem.count.must_equal start_num_itmes
      Order.count.must_equal start_orders
    end # won't add if product doesn't exist
  end # create

  describe "destroy" do
    it "returns success and deletes the order_item when given a valid order_item ID" do
      o = orders(:pending)
      oi = o.order_items.first

      delete order_item_path(oi)

      must_respond_with :redirect


      # def destroy
      #   @item = @order.order_items.find(params[:id])
      #   @item.destroy
      #   @order.save
      #   redirect_to order_path(@order)
      # end
    end # works when given valid order_item
  end # destroy

end #OrderItemsController
