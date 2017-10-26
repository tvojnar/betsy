require "test_helper"

describe CategoriesController do
  describe "Index" do
    it "can access the index as guest" do
      get categories_path
      must_respond_with :success
    end

    it "can access the index as logged in merchant" do
      login(merchants(:nkiru))
      get categories_path
      must_respond_with :success
    end
  end

  describe "new" do
    describe "as a guest" do
      it "cannot access form to create new category" do
        get new_category_path
        must_respond_with :redirect
        must_redirect_to root_path
      end
    end
  end

  describe  "as a logged in merchant" do
    before do
      login(merchants(:nkiru))
    end

    it "retrieves a form to create a new category" do
      get new_category_path
      must_respond_with :success
    end
  end

  describe "create" do
    describe "as a guest" do
      it "redirects to root" do
        category_data = {
          category: {
            name: "Annual"
          }
        }

        start_category_count = Category.count

        post categories_path, params: category_data

        must_respond_with :redirect
        must_redirect_to root_path

        Category.count.must_equal start_category_count
      end
    end
  end

  describe "as a logged in merchant" do
    before do
      login(merchants(:nkiru))
    end

    it "adds a category to the DB and redirects when the category data is valid" do
      category_data = {
        category: {
          name: "Annual"
        }
      }

      start_category_count = Category.count

      post categories_path, params: category_data

      must_respond_with :redirect
      must_redirect_to merchant_products_path(merchants(:nkiru))

      Category.count.must_equal start_category_count + 1
    end
  end

    # it "sends bad_request when the category data is invalid" do
    #     invalid_category_data = {
    #       category: {
    #         name: ""
    #       }
    #     }
    #
    #     start_category_count = Category.count
    #     get categories_path
    #     post categories_path params: invalid_category_data
    #     must_respond_with :bad_request
    #     Category.count.must_equal start_category_count
    #   end
    end

#edge case: what happens if the user input is invalid, possibly use proc
