require "test_helper"

describe Billing do
  let(:product) {Product.first}
  let(:order) {Order.first}

  describe "validations" do
    it "a new billing is created with all the fields" do
      b = Billing.new(
        cc_name: "diane",
        address: "Fake address st",
        email: "dl@ada.edu",
        cc_number:"fakenumber12345",
        cc_exp: 2017-10-01,
        cc_cvv: "444",
        zip: "11111",
        order: order
      )

      is_valid = b.valid?
      is_valid.must_equal true
    end
  end
end
