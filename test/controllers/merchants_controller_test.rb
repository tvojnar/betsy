require "test_helper"

describe MerchantsController do

  describe "login" do
    it "logs in an existing merchant" do
      start_count = Merchant.count
      merchant = merchants(:diane)

      login(merchant)
      must_redirect_to root_path
      session[:merchant_id].must_equal  merchant.id

      # Should *not* have created a new user
      Merchant.count.must_equal start_count
    end # logs in an existing user

    it "creates a new merchant" do
      start_count = Merchant.count
      merchant = Merchant.new(provider: "github", uid: 99999, name: "test_user", email: "test@ada.org")
      login(merchant)
      must_redirect_to root_path
      Merchant.count.must_equal start_count + 1
      session[:merchant_id].must_equal Merchant.last.id
    end
    #must test that user can log in to be merchant
  end # login

  describe "logout" do
    it "can log a user out" do
      # log the user in
      merchant = merchants(:diane)

      login(merchant)
      must_redirect_to root_path
      session[:merchant_id].must_equal  merchant.id

      # log the user out!
      get logout_path

      # Assert that logout worked
      must_redirect_to root_path
      session[:merchant_id].must_equal nil
    end # it can log a user out
  end # logout

  describe "show" do
      before do
        login(merchants(:diane))
      end

    it "returns a success status when passed a valid id" do
      merchant = merchants(:diane)
      get merchant_path(merchant.id)
      must_respond_with :success
    end

    it "returns not_found when given a bogus product id" do
      merchant = merchants(:diane)
      merchant_id = merchants(:diane).id + 1
      get merchant_path(merchant_id)
      must_respond_with :not_found
    end

   end

  describe "edit" do
    it "returns a success status when passed a valid id" do
      merchant = merchants(:diane)
      merchant_id = merchants(:diane).id
      get edit_merchant_path(merchant_id)
      must_respond_with :success
    end

    it "returns not_found when given a bogus product id" do
      merchant = merchants(:diane)
      merchant_id = merchants(:diane).id + 1
      get edit_merchant_path(merchant_id)
      must_respond_with :not_found
    end
  end

  describe "update" do
    it "returns success if the merchant ID is valid and the change is valid" do
      merchant = merchants(:nkiru)
      merchant_data = {
        merchant: {
          name: "Changed Name",
          email: "changed@email.com"
        }
      }
      merchant.update_attributes(merchant_data[:merchant])
      merchant.must_be :valid?

      patch merchant_path(merchant), params: merchant_data

      must_respond_with :redirect
      must_redirect_to  merchant_path(merchant)

      # Check that the change went through
      merchant.reload
      merchant.name.must_equal merchant_data[:merchant][:name]
    end

    it "returns not_found if the merchant ID is not valid" do
      merchant = merchants(:nkiru).id + 1
      merchant_data = {
        merchant: {
          name: "Changed Name",
          email: "changed@email.com"
        }
      }

      patch merchant_path(merchant), params: merchant_data

      must_respond_with :not_found
    end

#THIS TEST IS NOT CURRENTLY PASSING BUT WILL ONCE I MERGE WITH MASTER (MODEL VALIDATIONS)
    it "returns bad_request if the change is invalid" do
      merchant = merchants(:nkiru)
      merchant_data = {
        merchant: {
          name: nil,
          email: ""
        }
      }
      merchant.update_attributes(merchant_data[:merchant])
      merchant.wont_be :valid?

      patch merchant_path(merchant), params: merchant_data



      must_respond_with :bad_request

      # Check that the change went through
      merchant.reload
      merchant.name.wont_equal merchant_data[:merchant][:name]
    end



end

end
