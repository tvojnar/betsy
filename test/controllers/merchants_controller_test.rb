require "test_helper"

describe MerchantsController do
  it "logs in an existing merchant" do
    start_count = Merchant.count
    merchant = merchants(:diane)

    login(merchant)
    must_redirect_to root_path
    session[:merchant_id].must_equal  merchant.id

    # Should *not* have created a new user
    Merchant.count.must_equal start_count
  end

  it "creates a new merchant" do
    start_count = Merchant.count
    merchant = Merchant.new(provider: "github", uid: 99999, name: "test_user", email: "test@ada.org")
    login(merchant)
    must_redirect_to root_path
    Merchant.count.must_equal start_count + 1
    session[:merchant_id].must_equal Merchant.last.id
  end
  #must test that user can log in to be merchant

  it "won't log a user in without a uid" do
    merchant = Merchant.new(provider: "github", name: "test_user", email: "test@ada.org")
  end # won't log in without uid

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
end
