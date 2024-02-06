require 'test_helper'

class Authentication::UsersControllerTest < ActionDispatch::IntegrationTest
  def setup
    stub_request(:get, 'http://ip-api.com/json/127.0.0.1').
      to_return(status: 200, body: { status: 'fail' }.to_json, headers: {})
  end

  test 'should get new' do
    get new_user_url
    assert_response :success
  end

  test 'should create user' do
    assert_difference('User.count') do
      post users_url, params: {
        user: {
          email: 'juan@vendelo.com',
          username: 'juan09',
          password: 'testme'
        }
      }
    end

    assert_redirected_to products_url
  end

  test 'should not create a user when email is invalid' do
    post users_url, params: {
      user: {
        email: '',
        username: 'juan09',
        password: 'testme'
      }
    }

    assert_response :unprocessable_entity
    assert_equal flash[:alert], 'Invalid fields'
  end

  test 'should not create a user when username is invalid' do
    post users_url, params: {
      user: {
        email: 'juan@vendelo.com',
        username: '',
        password: 'testme'
      }
    }

    assert_response :unprocessable_entity
    assert_equal flash[:alert], 'Invalid fields'
  end

  test 'should not create a user when password is invalid' do
    post users_url, params: {
      user: {
        email: 'juan@vendelo.com',
        username: 'juan09',
        password: ''
      }
    }

    assert_response :unprocessable_entity
    assert_equal flash[:alert], 'Invalid fields'
  end
end
