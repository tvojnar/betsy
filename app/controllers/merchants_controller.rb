class MerchantsController < ApplicationController

  # def show
  #   @merchant = Merchant.find_by(id: params[:id])
  # end

  def login
    auth_hash = request.env['omniauth.auth']

    if auth_hash['uid']
      merchant = Merchant.find_by(provider: params[:provider], uid: auth_hash['uid'])

      if merchant.nil?
        #user has not logged in before
        #create a new record in the DB
        merchant = Merchant.from_auth_hash(params[:provider], auth_hash)
        save_and_flash(merchant)
      else
        flash[:status] = :success
        flash[:message] = "Succesfully logged in as returning merchant #{merchant.name}"
      end # if/else

      session[:merchant_id] = merchant.id

    else
      flash[:status] = :failure
      flash[:message] = "Could not create user from data provided by Github"
    end # if/else
    redirect_to root_path
  end


  def logout
    session[:merchant_id] = nil
    flash[:status] = :success
    flash[:message] = "You have successfully logged out"
    redirect_to root_path
  end
end
