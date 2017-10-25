require "test_helper"

describe Billing do
  let(:p_id) {Product.first.id}
  let(:o_id) {Order.first.id}

  describe "validations" do
    # it "a new billing is created with all the fields" do
    #   is_valid = billing.valid?
    #   is_valid.must_equal true
    # end

    # it "is invalid without a name" do
    #   let(:b_no_name) {Billing.new(address: "Fake address st", email: "dl@ada.edu", cc_number:"fakenumber12345", cc_exp: 2017-10-01, cc_cvv: "444", zip: "11111", order_id: o_id)}
    #
    #   let(:p_id) {Product.first.id}
    #   let(:o_id) {Order.first.id}
    #
    #   is_valid = b_no_name.valid?
    #   is_valid.wont_be.valid true
    #
    #   b_no_name.errors.messages.must_include :name
    # end

    # it "is invalid without an email" do
    #
    # end

    # it "is invalid without a credit card number" do
    #   b = billings(:no_ccnum)
    #   result = b.valid?
    #   result.must_equal true
    # end

    # describe "relationship between" do
    #   it "requires that a billing belongs to an order"  do
    #   end
    # end
  end
end
