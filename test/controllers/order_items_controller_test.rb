require "test_helper"

describe OrderItemsController do
  describe "create" do
    # TODO: get some pointers on how to test this better
    it "will add an order_item to @order" do
      order = current_order
      start_num_itmes = order.order_items.count

      item_params = {
          order_item: {
             quantity: 1,
             product_id: 1
           }
         }

      post order_items_path, params: item_params

      must_respond_with :redirect
      # TODO: change this when we decide where to redirect to!
      must_redirect_to root_path
      order.order_items.count.must_equal start_num_itmes + 1 
    end
  end # create

end #OrderItemsController
