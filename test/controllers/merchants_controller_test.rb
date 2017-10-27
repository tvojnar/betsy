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

    it "creates a new merchant if the merchant is not an existing user" do
      start_count = Merchant.count
      merchant = Merchant.new(provider: "github", uid: 99999, name: "test_user", email: "test@ada.org")
      login(merchant)
      must_redirect_to root_path
      Merchant.count.must_equal start_count + 1
      session[:merchant_id].must_equal Merchant.last.id
    end

    it "tells a user they are already logged in if that is true" do
      new_merchant = merchants(:tamira)

      login(new_merchant)
      must_respond_with :redirect
      must_redirect_to root_path

      login(new_merchant)
      must_respond_with :error
    end

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
      session[:order_id].must_equal nil
    end # it can log a user out
  end # logout

  describe "show" do
    describe "logged in" do
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
        must_respond_with :redirect
        must_redirect_to root_path
      end

      it "returns unauthorized when a merchant tries to see another merchants show page" do
        good_merchant = merchants(:diane)
        bad_merchant = merchants(:tamira)
        get merchant_path(bad_merchant.id)
        must_respond_with :redirect
        must_redirect_to root_path
      end
    end # logged in
    describe "guest user" do
      it "wont take a guest user to the page" do
        bad_merchant = merchants(:tamira)
        get merchant_path(bad_merchant.id)
        must_respond_with :redirect
        must_redirect_to root_path
      end # won't take a guest user to the page
    end # guest user
  end # show

  describe "edit" do
    describe "logged in merchant" do
      before do
        merchant = merchants(:diane)
        login(merchant)
      end
      it "returns a success status when passed the id of the logged in user" do
        merchant = merchants(:diane)
        merchant_id = merchants(:diane).id
        get edit_merchant_path(merchant_id)
        must_respond_with :success
      end

      it "returns not_found when given a bogus product id" do
        merchant = merchants(:diane)
        merchant_id = merchants(:diane).id + 1
        get edit_merchant_path(merchant_id)
        must_respond_with :redirect
        must_redirect_to root_path
      end

      it "redirects to the root path if given a merchant id other than the logged in merchant" do
        bad_merchant = merchants(:tamira)
        get edit_merchant_path(bad_merchant.id)
        must_respond_with :redirect
        must_redirect_to root_path
      end # redirects if given an incorrect merchant it
    end # logged in user
    describe "not logged in" do
      it "won't take a user who is not logged in to this page" do
        merchant = merchants(:tamira )
        get edit_merchant_path(merchant.id)
        must_respond_with :redirect
        must_redirect_to root_path
      end # won't take a gues to the page
    end # not logged in
  end # edit

  describe "update" do
    describe "logged in merchant" do
      it "returns success if the merchant ID is valid and the change is valid" do
        merchant = merchants(:nkiru)
        login(merchant)
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

      it "redirects if the merchant ID is not valid" do
        merchant = merchants(:nkiru)
        start_name = merchant.name
        login(merchant)
        bad_id = Merchant.last.id + 1
        merchant_data = {
          merchant: {
            name: "Changed Name",
            email: "changed@email.com"
          }
        }

        patch merchant_path(bad_id), params: merchant_data

        must_respond_with :redirect
        must_redirect_to root_path
        merchant.name.must_equal start_name
      end

      it "returns bad_request if the change is invalid" do
        # TODO: why is this passing?
        merchant = merchants(:nkiru)
        start_name = merchant.name
        login(merchant)
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
        puts "*" * 50
        # QUESTION: why is it changing the name to nil??
        # NOTE: not going to worry about this too much since this isn't required

        # Check that the change went through
        merchant.reload
        merchant.name.must_equal start_name
      end
    end # logged in merchant
    describe "guest user" do
      it "wont change a users data if the user is not logged in" do
      merchant = merchants(:nkiru)
      start_name = merchant.name
      merchant_data = {
        merchant: {
          name: "Changed Name",
          email: "changed@email.com"
        }
      }

      patch merchant_path(merchant.id), params: merchant_data

      must_respond_with :redirect
      must_redirect_to root_path
      merchant.name.must_equal start_name
    end # won't change if not logged in
    end # guest user
  end # update

end # merchant
