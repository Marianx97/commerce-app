require 'test_helper'

class ProductsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @product = products(:switch)
    login
  end

  test 'lists all products' do
    get products_path

    assert_response :success
    assert_select '.product', 12
    assert_select '.category', 12
  end

  test 'lists products filtered by category' do
    get products_path(category_id: categories(:technology).id)

    assert_response :success
    assert_select '.product', 7
  end

  test 'lists products filtered by price' do
    get products_path(min_price: 300, max_price: 500)

    assert_response :success
    assert_select '.product', 3
    assert_select 'h2', 'Nintendo Switch'
  end

  test 'lists products filtered by query_text' do
    get products_path(query_text: 'Switch')

    assert_response :success
    assert_select '.product', 1
    assert_select 'h2', 'Nintendo Switch'
  end

  test 'lists products order by most_expensive' do
    get products_path(order_by: 'most_expensive')

    assert_response :success
    assert_select '.product', 12
    assert_select '.products .product:first-child h2', 'Seat Panda clásico'
  end

  test 'lists products order by least_expensive' do
    get products_path(order_by: 'least_expensive')

    assert_response :success
    assert_select '.product', 12
    assert_select '.products .product:first-child h2', 'El hobbit'
  end

  test 'lists products order by newest' do
    get products_path(order_by: 'newest')

    assert_response :success
    assert_select '.product', 12
    assert_select('.product').first['Raqueta de tenis profesional']
  end

  test 'render product details' do
    get product_path(products(:phone))

    assert_response :success
    assert_select '.title', 'Moto One'
    assert_select '.description', 'Motorola con google integrado'
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
          price: @product.price,
          category_id: categories(:sports).id
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
        price: @product.price,
        category_id: categories(:technology)
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
        price: @product.price,
        category_id: categories(:technology)
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
        price: '',
        category_id: categories(:technology)
      }
    }

    assert_response :unprocessable_entity
    assert_equal flash[:alert], 'Invalid fields'
  end

  test 'does not create a new product when category_id is blank' do
    post products_path, params: {
      product: {
        title: @product.title,
        description: @product.description,
        price: @product.price,
        category_id: ''
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
