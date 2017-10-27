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


  describe "checkout methods" do

      let(:id) {Product.first.id}

    describe "sure" do
      it "responds with success when passed a valid order that is the current order" do
        item_params = {
          order_item: {
            quantity: 1,
            product_id: id
          }
        }

        post order_items_path params: item_params

        billing_params = {
          billing: {
            cc_name: "some_string",
            cc_number: "some_string",
            cc_exp: Date.today,
            cc_cvv: "some_string",
            email: "something",
            address: "somethi",
            zip: "23",
            order_id: Order.find_by(id: session[:order_id])
          }
        }

        post billings_path params: billing_params
        get sure_order_path
        must_respond_with :success
      end # it
    end #sure

    # TODO get this to pass
    # it "redirects to cart when passed a nil order" do
    #   item_params = {
    #     order_item: {
    #       quantity: 1,
    #       product_id: id
    #     }
    #   }
    #
    #   post order_items_path params: item_params
    #
    #   billing_params = {
    #     billing: {
    #       cc_name: "some_string",
    #       cc_number: "some_string",
    #       cc_exp: Date.today,
    #       cc_cvv: "some_string",
    #       email: "something",
    #       address: "somethi",
    #       zip: "23",
    #       order_id: session[:order_id]
    #     }
    #   }
    #
    #   # post order_items_path params: item_params
    #   post billings_path params: billing_params
    #   get order_current_path
    #   Order.find_by(id: session[:order_id]).destroy
    #   get sure_order_path
    #   must_redirect_to order_current_path
    # end

    describe "submit" do
      it "redirects to confirm_order_path a valid order id" do
        item_params = {
          order_item: {
            quantity: 1,
            product_id: id
          }
        }

        post order_items_path params: item_params

        billing_params = {
          billing: {
            cc_name: "some_string",
            cc_number: "some_string",
            cc_exp: Date.today,
            cc_cvv: "some_string",
            email: "something",
            address: "somethi",
            zip: "23",
            order_id: session[:order_id]
          }
        }

        # post order_items_path params: item_params
        post billings_path params: billing_params
        get sure_order_path
        post order_submit_path
        must_redirect_to confirm_order_path(Order.last.id)
      end

      it "sets order status to paid and redirects to confirm_order_path if order items for the order is not nil" do

        item_params = {
          order_item: {
            quantity: 1,
            product_id: id
          }
        }

        post order_items_path params: item_params

        billing_params = {
          billing: {
            cc_name: "some_string",
            cc_number: "some_string",
            cc_exp: Date.today,
            cc_cvv: "some_string",
            email: "something",
            address: "somethi",
            zip: "23",
            order_id: session[:order_id]
          }
        }

        # post order_items_path params: item_params
        post billings_path params: billing_params
        get sure_order_path
        post order_submit_path
        must_redirect_to confirm_order_path(Order.last.id)
        Order.last.status.must_equal "paid"
      end

      it "redirects to order_path if order items for the order is nil" do
        item_params =  {
          order_item: {
            quantity: 1,
            product_id: id
          }
        }

        post order_items_path params: item_params

        billing_params = {
          billing: {
            cc_name: "some_string",
            cc_number: "some_string",
            cc_exp: Date.today,
            cc_cvv: "some_string",
            email: "something",
            address: "somethi",
            zip: "23",
            order_id: session[:order_id]
          }
        }

        # post order_items_path params: item_params
        post billings_path params: billing_params
        get sure_order_path
        Order.find_by(id: session[:order_id]).order_items[0].destroy
        post order_submit_path
        must_respond_with :not_found
      end

      it "sets the session[:order_id] to nil if the order exits and is the current order" do
        item_params = {
          order_item: {
            quantity: 1,
            product_id: id
          }
        }

        post order_items_path params: item_params

        billing_params = {
          billing: {
            cc_name: "some_string",
            cc_number: "some_string",
            cc_exp: Date.today,
            cc_cvv: "some_string",
            email: "something",
            address: "somethi",
            zip: "23",
            order_id: session[:order_id]
          }
        }

        # post order_items_path params: item_params
        post billings_path params: billing_params
        get sure_order_path
        post order_submit_path
        session[:order_id].must_equal nil
      end
    end #submit

    #
    describe "show" do
      it "returns success if the order exists" do
        item_params = {
          order_item: {
            quantity: 1,
            product_id: id
          }
        }

        post order_items_path params: item_params

        billing_params = {
          billing: {
            cc_name: "some_string",
            cc_number: "some_string",
            cc_exp: Date.today,
            cc_cvv: "some_string",
            email: "something",
            address: "somethi",
            zip: "23",
            order_id: session[:order_id]
          }
        }

        merchant = merchants(:tamira)
        login(merchant)
        order = orders(:paid)
        get order_path(order.id)
        must_respond_with :success
      end

      it "returns not found if the order does not exist" do
        item_params = {
          order_item: {
            quantity: 1,
            product_id: id
          }
        }

        post order_items_path params: item_params

        billing_params = {
          billing: {
            cc_name: "some_string",
            cc_number: "some_string",
            cc_exp: Date.today,
            cc_cvv: "some_string",
            email: "something",
            address: "somethi",
            zip: "23",
            order_id: session[:order_id]
          }
        }

        get order_path(Order.last.id + 1)
        must_respond_with :not_found
      end
    end # show


    describe "confirmation" do
      it "responds with success when the order status is paid, the session[:order_id] is reset to nil, and date_submitted is not nil" do
        item_params = {
          order_item: {
            quantity: 1,
            product_id: id
          }
        }

        post order_items_path params: item_params

        billing_params = {
          billing: {
            cc_name: "some_string",
            cc_number: "some_string",
            cc_exp: Date.today,
            cc_cvv: "some_string",
            email: "something",
            address: "somethi",
            zip: "23",
            order_id: session[:order_id]
          }
        }

        post order_items_path params: item_params
        post billings_path params: billing_params
        get sure_order_path
        post order_submit_path
        o = Order.last.id
        get confirm_order_path(Order.find_by(id: o))
        must_respond_with :success
      end

      #TODO: get this to pass
      # it "redirects to cart when session[:order_id] is not nil " do
      #   post order_items_path params: item_params
      #   post billings_path params: billing_params
      #   get sure_order_path
      #   post order_submit_path
      #   o = Order.last.id
      #   session[:order_id]
      #   get confirm_order_path(Order.find_by(id: o))
      #   must_redirect_to order_current_path
      # end
    end #confirmation
  end # checkout methods
#
end # OrdersController
