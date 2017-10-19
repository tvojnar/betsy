require "test_helper"

describe Merchant do
  let(:merchant) { Merchant.new(provider: "github", uid: 99999, name: "test_user", email: "test@ada.org") }
  let(:m_no_name) {Merchant.new(provider: "github", uid: 99999, email: "test@ada.org")}
  let(:m_not_uniq_name) { Merchant.new(provider: "github", uid: 1111111, name: "test_user", email: "t@ada.org") }
  let(:m_no_email) {Merchant.new(provider: "github", uid: 99999, email: "test@ada.org")}

describe "validations" do
  it "will create a new Merchant when all fields are provided" do
  merchant.must_be :valid?
  end # create Merchant when all fields are given

  it "will requires a name" do
    is_valid = m_no_name.valid?
    is_valid.must_equal false
  end # it requires a name

  it "will requires a unique name" do
    merchant.save
    m_not_uniq_name.wont_be :valid? 

  end # it requires a unique name

  it "will requires a email" do
  end # it requires a email

  it "will requires a unique email" do
  end # it requires a unique email

end # validations

end
