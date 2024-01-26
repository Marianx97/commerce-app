require 'test_helper'

class ProductsControllerTest < ActionDispatch::IntegrationTest
  test 'render all products' do
    get products_path

    assert_response :success
    assert_select '.product', 2
  end

  test 'render product details' do
    get product_path(products(:phone))

    assert_response :success
    assert_select '.title', 'Moto One'
    assert_select '.description', 'Motorola with google integrated'
    assert_select '.price', 'Price: U$D 210'
  end
end
