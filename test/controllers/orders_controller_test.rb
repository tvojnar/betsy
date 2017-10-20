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
end # OrdersController
