require "test_helper"

describe BillingsController do
  describe "new" do
    it "returns a billing form" do
      get new_billing_path
      must_respond_with :success
    end
  end

  describe "create" do
    it "creates a billing with a valid order id" do

      id = Product.first.id

      item_params = {
        order_item: {
          quantity: 1,
          product_id: id
        }
      }

      post order_items_path params: item_params
      get order_current_path

      billing_data = {
        billing: {
          email: "dl@ada.edu",
          address: "Fake address for tamira",
          cc_name: "Diane",
          cc_number: "fakenumber12345",
          cc_exp: Date.today,
          cc_cvv: "444",
          zip: "11111",
          order_id: Order.find_by(id: session[:order_id])
        }
      }

      start_billing_count = Billing.count

      post billings_path params: billing_data

      start_billing_count = Billing.count
      post billings_path params: billing_data
      must_respond_with :redirect
      must_redirect_to sure_order_path

      Billing.count.must_equal start_billing_count + 1
    end
  end #create

    it "sends bad_request when the billing data is invalid" do
      invalid_billing_data = {
        billing: {
          email: "dl@ada.edu",
          address: "Fake address for tamira",
          cc_name: "Diane",
          cc_number: "fakenumber12345",
          cc_exp: 2017-10-01,
          cc_cvv: "444",
          zip: "11111"
        }
      }

      start_billing_count = Billing.count

      post billings_path, params: invalid_billing_data

      must_respond_with :bad_request
      Billing.count.must_equal start_billing_count
    end

    describe "find billing" do
      it "find a billing that exits" do

      end

    end

  end

  # describe "edit" do
  #   it "returns success when passed a valid order id" do
  #     get edit_billing_path(Billing.first)
  #     must_respond_with :success
  #   end
  #
  #   it "returns not found if passed bogus order number" do
  #     bad_id = Billing.last.id + 1
  #     get edit_billing_path(bad_id)
  #     must_respond_with :not_found
  #   end
  # end
# end
