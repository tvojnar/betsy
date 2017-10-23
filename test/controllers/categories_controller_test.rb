require "test_helper"

describe CategoriesController do
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
    it "adds a category to the DB and redirects when the category data is valid" do
      category_data = {
        category: {
          name: "Annual"
        }
      }

      Category.new(category_data[:category]).must_be :valid?

      start_category_count = Category.count

      post categories_path, params: category_data

      must_respond_with :redirect
      must_redirect_to categories_path

      Category.count.must_equal start_category_count + 1

    end
  end

end
