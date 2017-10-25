require "test_helper"

describe OrdersController do
  describe "current" do
    it "will succeed if session[:order_id] has been set" do
      # Arrange
      # set session[:order_id]
      id = Product.first.id
      item_params = {
        order_item: {
          quantity: 1,
          product_id: id
        }
      }
      post order_items_path, params: item_params

      # Act
      get order_current_path

      # Assert
      must_respond_with :success
    end # works if session[:order_id] has been set

    it "won't work if no order has been created yet for the session" do
      get order_current_path
      must_respond_with :not_found
    end # won't work if no order has been created yet for the session
  end # current

  describe "index" do
    it "will respond with sucess" do
      get orders_path
      must_respond_with :success
    end # index
  end # index

  describe "current_order" do
    # TODO: need to figure out how to access current_order in my tests before I can test this
  end # current_order

describe "checkout methods" do

    id = Product.first.id

    item_params = {
      order_item: {
        quantity: 1,
        product_id: id
      }
    }

    billing_params = {
      billing: {
        cc_name: "some_string",
        cc_number: "some_string",
        cc_exp: Date.today,
        cc_cvv: "some_string",
      }
    }

    describe "sure" do
      it "responds with success when passed a valid order that is the current order" do
        post order_items_path params: item_params
        post billings_path params: billing_params
        get sure_order_path
        must_respond_with :success
      end

#NOTE: SORT THIS OUT DL
      # it "redirects to cart when passed a bogus order" do
      #   post order_items_path params: item_params
      #   post billings_path params: billing_params
      #   get sure_order_path
      #   get order_current_path
      #   or = get order_current_path(Order.last.id)
      #   delete order_path(Order.last.id)
      #   must_redirect_to order_current_path
      #   #how would i even test this current is in the route??
      # end


    end

    describe "submit" do

      it "responds with success when passed a valid order id" do
        post order_items_path params: item_params
        post billings_path params: billing_params
        get sure_order_path
        post order_submit_path
        must_redirect_to confirm_order_path(Order.last.id)
      end

      it "sets order status to paid and redirects to order_summary_path if order items for the order is not nil" do
        post order_items_path params: item_params
        post billings_path params: billing_params
        must_redirect_to sure_order_path
        get sure_order_path
        post order_submit_path
        must_redirect_to confirm_order_path(Order.last.id)
        Order.last.status.must_equal "paid"
      end

      it "redirects to order_path if order items for the order is nil" do
        post order_items_path params: item_params
        post billings_path params: billing_params
        must_redirect_to sure_order_path
        get sure_order_path
        Order.find_by(id: session[:order_id]).order_items[0].destroy
        post order_submit_path
        must_respond_with :not_found
      end

      it "sets the session[:order_id] to nil if the order exits and is the current order" do
        post order_items_path params: item_params
        post billings_path params: billing_params
        get sure_order_path
        post order_submit_path
        session[:order_id].must_equal nil
      end
    end


    describe "show" do

      it "returns success if the order exists" do
        get order_path(Order.create!)
        must_respond_with :success
      end

      it "returns not found if the order does not exist" do
        get order_path(Order.last.id + 1)
        must_respond_with :not_found
      end

    end

  end # checkout methods

end # OrdersController
