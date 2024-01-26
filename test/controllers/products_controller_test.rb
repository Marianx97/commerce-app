require 'test_helper'

class ProductsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @product = products(:switch)
  end

  test 'lists all products' do
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
    assert_difference('Product.count') do
      post products_path, params: {
        product: {
          title: @product.title,
          description: @product.description,
          price: @product.price
        }
      }
    end

    assert_redirected_to products_path
    assert_equal flash[:notice], 'Product successfully created!'
  end

  test 'does not create a new product when title is blank' do
    post products_path, params: {
      product: {
        title: '',
        description: @product.description,
        price: @product.price
      }
    }

    assert_response :unprocessable_entity
    assert_equal flash[:alert], 'Invalid fields'
  end

  test 'does not create a new product when description is blank' do
    post products_path, params: {
      product: {
        title: @product.title,
        description: '',
        price: @product.price
      }
    }

    assert_response :unprocessable_entity
    assert_equal flash[:alert], 'Invalid fields'
  end

  test 'does not create a new product when price is blank' do
    post products_path, params: {
      product: {
        title: @product.title,
        description: @product.description,
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

  test 'updates a product' do
    patch product_path(products(:phone)), params: { product: { price: 190 } }

    assert_redirected_to product_path(products(:phone))
    assert_equal flash[:notice], 'Product successfully updated!'
  end

  test 'does not update a product when title is blank' do
    patch product_path(products(:phone)), params: { product: { title: '' } }

    assert_response :unprocessable_entity
    assert_equal flash[:alert], 'Invalid fields'
  end

  test 'does not update a product when description is blank' do
    patch product_path(products(:phone)), params: { product: { description: '', } }

    assert_response :unprocessable_entity
    assert_equal flash[:alert], 'Invalid fields'
  end

  test 'does not update a product when price is blank' do
    patch product_path(products(:phone)), params: { product: { price: '' } }

    assert_response :unprocessable_entity
    assert_equal flash[:alert], 'Invalid fields'
  end

  test 'deletes a product' do
    assert_difference('Product.count', -1) do
      delete product_path(products(:phone))
    end

    assert_redirected_to products_path
    assert_equal flash[:notice], 'Product successfully deleted!'
  end
end
