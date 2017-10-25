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
      billing_data = {
        billing: {
          email: "dl@ada.edu",
          address: "Fake address for tamira",
          cc_name: "Diane",
          cc_num: "fakenumber12345",
          cc_exp: 2017-10-01,
          cc_cvv: "444",
          zip: "11111",
          order_id: orders(:pending).id
        }
      }
      start_billing_count = Billing.count

      post billings_path, params: billing_data

      must_respond_with :redirect
      must_redirect_to order_submit_path

      Billing.count.must_equal start_billing_count + 1

    end
  end
end
