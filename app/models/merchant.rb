class Merchant < ApplicationRecord
  has_many :products

  def self.from_auth_hash(provider, auth_hash)
    merchant = new
    merchant.provider = provider
    merchant.uid = auth_hash['uid']
    # NOTE: we should only set merchant.name to one thing, and since we don't have a username for merchant, we will just set 'name' to the 'nickname' passed in my rails
    # merchant.name = auth_hash['info']['name']
    merchant.email = auth_hash['info']['email']
    merchant.name = auth_hash['info']['nickname']

    return merchant
  end
end