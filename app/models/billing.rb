class Billing < ApplicationRecord
  belongs_to :order

  validates :cc_name, presence: true
  validates :cc_number, presence: true,
  length:  {minimum: 4}
  validates :cc_cvv, presence: true
  validates :cc_exp, presence: true
  validates :address, presence: true
  validates :email, presence: true
  validates :zip, presence: true
  validates :order_id, presence: true
end

#for some reason I had to comment these out to get things going on the local host but then
#I uncommented and it started working again ??
