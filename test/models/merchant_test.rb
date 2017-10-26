require "test_helper"

describe Merchant do
  let(:merchant) { Merchant.new(provider: "github", uid: 99999, name: "test_user", email: "test@ada.org") }
  let(:m_no_name) {Merchant.new(provider: "github", uid: 99999, email: "test@ada.org")}
  let(:m_not_uniq_name) { Merchant.new(provider: "github", uid: 1111111, name: "test_user", email: "t@ada.org") }
  let(:m_no_email) {Merchant.new(provider: "github", uid: 99999, name: "no email")}
  let(:m_not_uniq_email) { Merchant.new(provider: "github", uid: 222222, name: "not uniq email", email: "test@ada.org") }
  let(:m_without_uid) {Merchant.new(provider: "github",  name: "test_user", email: "test@ada.org") }


  describe "relationships" do
    it "has many products" do
      m = merchants(:diane)
      m.must_respond_to :products
    end
  end

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

    let :o_item { order_items(:one)}
    let :merchant {merchants(:diane)}

    describe "self.from_auth_hash" do

    end

    describe "merchant_order_items" do

      it "returns an array that contains instances of order_items" do
        o_id = o_item.id
        order_items = merchant.merchant_order_items(merchant)
        order_items.each do |oi|
          oi.must_be_instance_of OrderItem
        end
      end

      it "returns all order_items that have product_ids that belong to the merchant" do
        order_items = merchant.merchant_order_items(merchant)
        order_items.each do |oi|
          Product.find_by(id: oi.product_id).merchant_id.must_equal merchant.id
        end
      end

    end

    describe "total revenue" do
      it "returns total revenue regardless of order status for a given merchant" do
        items = []
        all_oi = OrderItem.all
        all_oi.each do |oi|
          if oi.product.merchant_id == merchant.id
            items << oi
          end
        end

        total = 0
        items.each do |oi|
          total += oi.quantity * oi.product.price
        end

        merchant.total_revenue(merchant).must_equal total
      end
      it "returns 0 when there are no orders for the given merchant" do
        OrderItem.destroy_all
        merchant.total_revenue(merchant).must_equal 0
      end

      it "returns the total of each status revenue" do
        total_by_status = merchant.pending_revenue(merchant) + merchant.paid_revenue(merchant) + merchant.shipped_revenue(merchant) + merchant.completed_revenue(merchant)
        merchant.total_revenue(merchant).must_equal total_by_status
      end
    end

    describe "pending revenue" do
      it "returns the correct pending revenue for a merchant with many order statuses" do
        orders = Order.where(status: "pending")
        total = 0
        orders.each do |o|
          o.order_items.each do |oi|
            if oi.product.merchant_id == merchant.id
              total += oi.product.price * oi.quantity
            end
          end
        end

        merchant.pending_revenue(merchant).must_equal total
      end

      it "returns the 0 for a merchant with no pending revenue" do
        OrderItem.destroy_all
        merchant.pending_revenue(merchant).must_equal 0
      end

    end

    describe "paid revenue" do
      it "returns the correct paid revenue for a merchant with many order statuses" do
        merchant.paid_revenue(merchant).must_equal 187.0
      end

      it "returns the 0 for a merchant with no paid revenue" do
        OrderItem.destroy_all
        merchant.paid_revenue(merchant).must_equal 0
      end

    end

    describe "shipped revenue" do
      it "returns the correct shipped revenue for a merchant with many order statuses" do
        merchant.shipped_revenue(merchant).must_equal 28.0
      end

      it "returns the 0 for a merchant with no shipped revenue" do
        OrderItem.destroy_all
        merchant.shipped_revenue(merchant).must_equal 0
      end
    end

    describe "completed revenue" do
      it "returns the correct completed revenue for a merchant with many order statuses" do
        merchant.completed_revenue(merchant).must_equal 848.0
      end

      it "returns the 0 for a merchant with no paid revenue" do
        OrderItem.destroy_all
        merchant.completed_revenue(merchant).must_equal 0
      end
    end

    describe "pending number" do
      it "returns the correct number of order items that belong to a certain merchant and a pending order" do
        merchant.pending_number(merchant).must_equal 2
      end

      it "returns 0 if a merchant has no order items that belong to a pending order" do
        OrderItem.destroy_all
        merchant.pending_number(merchant).must_equal 0
      end
    end


    describe "paid number" do
      it "returns the correct number of order items that belong to a certain merchant and a paid order" do
        merchant.paid_number(merchant).must_equal 2
      end

      it "returns 0 if a merchant has no order items that belong to a paid order" do
        OrderItem.destroy_all
        merchant.paid_number(merchant).must_equal 0
      end
    end

    describe "shipped number" do
      it "returns the correct number of order items that belong to a certain merchant and a shipped order" do
        merchant.shipped_number(merchant).must_equal 2
      end

      it "returns 0 if a merchant has no order items that belong to a shipped order" do
        OrderItem.destroy_all
        merchant.shipped_number(merchant).must_equal 0
      end
    end

    describe "completed number" do
      it "returns the correct number of order items that belong to a certain merchant and a completed order" do
        merchant.completed_number(merchant).must_equal 2
      end

      it "returns 0 if a merchant has no order items that belong to a completed order" do
        OrderItem.destroy_all
        merchant.completed_number(merchant).must_equal 0
      end
    end


  end
end
