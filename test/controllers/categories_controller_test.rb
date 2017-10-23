require "test_helper"

describe CategoriesController do
  # it "should get index" do
  #   get categories_index_url
  #   value(response).must_be :success?
  # end
  describe "index" do
    it "returns a success for all categories" do
      get categories_path
      must_respond_with :success
    end
  end

  describe "new" do
    it "works to get category" do
      get new_category_path
      must_respond_with :success
    end
  end

  describe "create" do

  end

end
