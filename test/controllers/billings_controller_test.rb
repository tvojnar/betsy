require "test_helper"

describe BillingsController do
  describe "new" do
    it "returns a billing form" do
      get new_billing_path
      must_respond_with :success
    end
  end
end
