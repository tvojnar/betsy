require "test_helper"

describe OrderItemsController do
  describe "create" do
    # TODO: get some pointers on how to test this better and make the test pass... QUESTION: why can't this test access the current_order method??!!
    it "will add an order_item to if the product exists @order" do
      order = current_order
      puts "@" * 50
      puts new_order.order_items
      puts "@" * 50
      start_num_itmes = new_order.order_items .count
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
      new_order.order_items.count.must_equal start_num_itmes + 1
    end

    it "won't add a order_item to the order if the product doesn't exist" do
      order = current_order
      start_num_itmes = new_order.order_items .count
      id = Product.last.id + 1
      item_params = {
          order_item: {
             quantity: 1,
             product_id: id
           }
         }

      post order_items_path, params: item_params
      # QUESTION: is not_found the right way to do this?
      must_respond_with :not_found
      new_order.order_items.count.must_equal start_num_itmes
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
