class BillingsController < ApplicationController
  def new
    @billing = Billing.new
  end

  def create
    billing = Billing.new(billing_params)
    if billing
      save_and_flash(billing)
      order = current_order
      order.billing = billing


      redirect_to order_submit_path
      return
    else
      render :new, status: :bad_request
      return
    end
  end

  def edit
    find_billing
  end

  def update
    find_billing
    @billing.update_attributes(billing_params)
    if save_and_flash(@billing)
      redirect_to order_submit_path
      return
    else
      render :edit, status: :bad_request
      return
    end
  end

private
def billing_params
  return params.require(:billing).permit(:cc_name, :email, :address, :zip, :cc_cvv, :cc_number, :cc_exp, :order_id)
end

def find_billing
  @billing = Billing.find_by(id: params[:id])
  unless @billing
    head :not_found
  end
end

end
