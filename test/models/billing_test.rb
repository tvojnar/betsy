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

    it "should be invalid without name" do
      b = Billing.new(
        address: "Fake address st",
        email: "dl@ada.edu",
        cc_number:"fakenumber12345",
        cc_exp: 2017-10-01,
        cc_cvv: "444",
        zip: "11111",
        order: order
      )

      is_valid = b.valid?
      is_valid.must_equal false
    end

    it "should be invalid without address" do
      b = Billing.new(
        cc_name: "Diane",
        email: "dl@ada.edu",
        cc_number:"fakenumber12345",
        cc_exp: 2017-10-01,
        cc_cvv: "444",
        zip: "11111",
        order: order
      )

      is_valid = b.valid?
      is_valid.must_equal false
    end

    it "should be invalid without email" do
      b = Billing.new(
        address: "Fake address st",
        cc_name: "Diane",
        cc_number:"fakenumber12345",
        cc_exp: 2017-10-01,
        cc_cvv: "444",
        zip: "11111",
        order: order
      )

      is_valid = b.valid?
      is_valid.must_equal false
    end

    it "should be invalid without credit card number" do
      b = Billing.new(
        address: "Fake address st",
        email: "dl@ada.edu",
        cc_name:"Diane",
        cc_exp: 2017-10-01,
        cc_cvv: "444",
        zip: "11111",
        order: order
      )

      is_valid = b.valid?
      is_valid.must_equal false
    end

    it "should be invalid without an expiration date" do
      b = Billing.new(
        cc_name: "diane",
        address: "Fake address st",
        email: "dl@ada.edu",
        cc_number:"fakenumber12345",
        cc_cvv: "444",
        zip: "11111",
        order: order
      )

      is_valid = b.valid?
      is_valid.must_equal false
    end

    it "should be invalid without cvv number" do
      b = Billing.new(
        cc_name: "diane",
        address: "Fake address st",
        email: "dl@ada.edu",
        cc_number:"fakenumber12345",
        cc_exp: 2017-10-01,
        zip: "11111",
        order: order
      )

      is_valid = b.valid?
      is_valid.must_equal false
    end

    it "should be invalid without zipcode" do
      b = Billing.new(
        cc_name: "diane",
        address: "Fake address st",
        email: "dl@ada.edu",
        cc_number:"fakenumber12345",
        cc_exp: 2017-10-01,
        cc_cvv: "444",
        order: order
      )

      is_valid = b.valid?
      is_valid.must_equal false
    end

    it "should be invalid without order id" do
      b = Billing.new(
        cc_name: "diane",
        address: "Fake address st",
        email: "dl@ada.edu",
        cc_number:"fakenumber12345",
        cc_exp: 2017-10-01,
        cc_cvv: "444",
        zip: "11111",
      )

      is_valid = b.valid?
      is_valid.must_equal false
    end
    describe "relationship between" do
      it "has an order"  do
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

        b.order.must_be_kind_of Order
      end
    end
  end
end
