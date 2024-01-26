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

  test 'render new product form' do
    get new_product_path

    assert_response :success
    assert_select 'form'
  end

  test 'creates a new product' do
    post products_path, params: {
      product: {
        title: 'Nintendo 64',
        description: 'Retro videogames console',
        price: 45
      }
    }

    assert_redirected_to products_path
    assert_equal flash[:notice], 'Product created successfully!'
  end

  test 'does not create a new product when title is blank' do
    post products_path, params: {
      product: {
        title: '',
        description: 'Retro videogames console',
        price: 45
      }
    }

    assert_response :unprocessable_entity
    assert_equal flash[:alert], 'Invalid fields'
  end

  test 'does not create a new product when description is blank' do
    post products_path, params: {
      product: {
        title: 'Nintendo 64',
        description: '',
        price: 45
      }
    }

    assert_response :unprocessable_entity
    assert_equal flash[:alert], 'Invalid fields'
  end

  test 'does not create a new product when price is blank' do
    post products_path, params: {
      product: {
        title: 'Nintendo 64',
        description: 'Retro videogames console',
        price: ''
      }
    }

    assert_response :unprocessable_entity
    assert_equal flash[:alert], 'Invalid fields'
  end

  test 'render edit product form' do
    get edit_product_path(products(:phone))

    assert_response :success
    assert_select 'form'
  end
end
