require "test_helper"

describe Merchant do
  let(:merchant) { Merchant.new(provider: "github", uid: 99999, name: "test_user", email: "test@ada.org") }
  let(:m_no_name) {Merchant.new(provider: "github", uid: 99999, email: "test@ada.org")}
  let(:m_not_uniq_name) { Merchant.new(provider: "github", uid: 1111111, name: "test_user", email: "t@ada.org") }
  let(:m_no_email) {Merchant.new(provider: "github", uid: 99999, name: "no email")}
  let(:m_not_uniq_email) { Merchant.new(provider: "github", uid: 222222, name: "not uniq email", email: "test@ada.org") }
  let(:m_without_uid) {Merchant.new(provider: "github",  name: "test_user", email: "test@ada.org") }

  describe "validations" do
    it "will create a new Merchant when all fields are provided" do
      merchant.must_be :valid?
    end # create Merchant when all fields are given

    it "requires a name" do
      is_valid = m_no_name.valid?
      is_valid.must_equal false
      m_no_name.errors.messages.must_include :name
    end # it requires a name

    it "requires a unique name" do
      merchant.save
      m_not_uniq_name.wont_be :valid?
      m_not_uniq_name.errors.messages.must_include :name

    end # it requires a unique name

    it "requires a email" do
      m_no_email.wont_be :valid?
      m_no_email.errors.messages.must_include :email
    end # it requires a email

    it "requires a unique email" do
      merchant.save
      m_not_uniq_email.wont_be :valid?
      m_not_uniq_email.errors.messages.must_include :email
    end # it requires a unique email

    # TODO: figure out how to test this!
    # it "won't login/create a new merchant without a uid" do
    #   start_count = Merchant.count
    #   m_without_uid.save.must_raise NotNullViolation
    #
    #   Merchant.count.must_equal start_count
    # end # won't log in without uid

  end # validations
describe "custom methods" do
  describe "self.from_auth_hash" do

  end

  describe "total revenue" do
    before do
      login(merchants(:diane))
    end

    it "returns an array that contains instances of order_items" do
      merchant = merchants(:diane)
      order_items = merchant.merchant_order_items
      order_items.each do |oi|
        oi.must_be_instance_of OrderItem
      end

    end

    it "returns all order_items that have product_ids that belong to the merchant" do

    end


  end

  describe "total_revenue_by_status" do

  end
  describe "merchant_order_items" do

  end
end
end
