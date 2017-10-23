require "test_helper"

describe CategoriesController do
  describe "Guest users" do
    it "can access the index" do
      get categories_path
      must_respond_with :success
    end

    # it "cannot access form to create new category" do
    #   get new_category_path
    #   must_respond_with :redirect
    #   must_redirect_to root_path
    #   flash[:message].must_equal "You must be logged in to do that!"
    # end
  end

  describe "new" do
    it "retrieves a form to create a new category" do
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

    # it "sends bad_request when the category data is bogus" do
    #   invalid_category_data = {
    #     category: {
    #     }
    #   }
    #
    #   Category.new(invalid_category_data[:category]).wont_be :valid?
    #
    #   start_category_count = Category.count
    #
    #   post categories_path, params: invalid_category_data
    #
    #   must_respond_with :bad_request
    #   Category.count.must_equal start_category_count
    # end

    # Test is failing
  end

  # describe "Logged in users" do
  #   before do
  #     login(merchants(:nkiru))
  #   end
  # end

end
