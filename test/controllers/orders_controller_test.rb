require "test_helper"

describe OrdersController do
  describe "show" do
  it "will succeed if there passed an existing order" do
    order = orders(:pending)
    get order_path(order)
    must_respond_with :success
  end # works with existing order

  it "will work if no order has been created yet for the session" do
  # QUESTION: why can't I use current_order in my tests??????
  # need to do the post that is calling current_order in my test
   get order_path(current_order)
   must_respond_with :success
  end # works if an orger hasn't been created yet for the session
end # show

describe "index" do
  it "will respond with sucess" do
    get orders_path
    must_respond_with :success
  end # index
end # index

describe "current_order" do
  # TODO: need to figure out how to access current_order in my tests before I can test this
end # current_order





describe "submit" do
  it "responds with success when passed a valid order id" do
    o = Order.create
    puts o.id
    get order_path(o.id)
    get order_submit_path(o.id)
    must_respond_with :success
  end

  it "sets order status to paid and redirects to order_summary_path if order is not nil" do
    #get submit_order_path
  end

  it "redirects to order_path if order is nil" do

  end

end


describe "summary" do
  it "returns success if the order exists and is the current order" do

  end

  it "sets the session[:order_id] to nil if the order exits and is the current order" do
  end


  it "returns not found if the order does not exist or is not the current order" do

  end

end

# describe "edit" do
#   it "returns success when passed a valid order id" do
#     get edit_orders_path(Order.first.id)
#     must_respond_with :success
#   end

  #
  # it "returns not found if passed bogus order number" do
  #   order_id = Order.last.id
  #   order_id2 = order_id + 1
  #   get edit_order_path(order_id2)
  #   must_respond_with :not_found
  # end

# end

describe "update" do
  # it "returns success when passed valid order_id" do
  #   post order_items_path params(item_params)
  # end

  # it "returns bad request when passed bogus data/not all fields are filled" do
  #   order = Order.new
  #   patch order_path(current_order)
  #   must_respond_with :bad_request
  # end
  #
  # it "returns not found if passed bogus order number" do
  #   patch order_path(Order.last.id + 1)
  #   must_respond_with :not_found
  # end

  # it "updates information correctly" do
  #   order = current_order
  #   order_data = {
  #     order: {
  #       cc_name: "diane",
  #       cc_number: 12345667,
  #       cc_exp: Date.today,
  #       zip: 55122,
  #       email: "d@ada.com",
  #       address: "my address",
  #       cc_cvv: 234
  #     }
  #   }
  #
  #   order = Order.new(order_data[:order])
  #   order.must_be :valid?
  #
  #   order_count = Order.count
  #   patch order_path(order.id), params: order_data
  #   # must_respond_with :redirect
  #   # must_redirect_to merchant_products_path(product.merchant.id)
  #   Order.count.must_equal order_count + 1
  # end
  #
  # it "changes status from pending to paid" do
  #   order = current_order
  #   patch order_path(current_order.id)
  #   order.status.must_equal "paid"
  #
  # end

end #describe update


end # OrdersController
