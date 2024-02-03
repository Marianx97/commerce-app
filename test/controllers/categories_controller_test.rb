require "test_helper"

class CategoriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    login
    @category = categories(:sports)
  end

  test 'lists all categories' do
    get categories_url
    assert_response :success
  end

  test 'render new category form' do
    get new_category_url
    assert_response :success
  end

  test 'creates a new category' do
    assert_difference("Category.count") do
      post categories_url, params: { category: { name: @category.name } }
    end

    assert_redirected_to categories_url
  end

  test 'does not create a new category when name is blank' do
    post categories_url, params: { category: { name: '' } }

    assert_response :unprocessable_entity
    assert_equal flash[:alert], 'Invalid fields'
  end

  test 'render edit category form' do
    get edit_category_url(@category)

    assert_response :success
    assert_select 'form'
  end

  test 'updates a category' do
    patch category_url(@category), params: { category: { name: @category.name } }
    assert_redirected_to categories_url
  end

  test 'does not update a category when name is blank' do
    patch category_path(categories(:sports)), params: { category: { name: '' } }

    assert_response :unprocessable_entity
    assert_equal flash[:alert], 'Invalid fields'
  end

  test "deletes a category" do
    assert_difference("Category.count", -1) do
      delete category_url(categories(:clothes))
    end

    assert_redirected_to categories_url
    assert_equal flash[:notice], 'Category successfully deleted!'
  end
end
