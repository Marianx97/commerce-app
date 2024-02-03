require 'test_helper'

class Authentication::SessionsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:paco)
  end

  test 'should get new' do
    get new_session_url
    assert_response :success
  end

  test 'should sign in an user by email' do
    post sessions_url, params: { login: @user.email, password: 'testme' }

    assert_redirected_to products_url
  end

  test 'should sign in an user by username' do
    post sessions_url, params: { login: @user.username, password: 'testme' }

    assert_redirected_to products_url
  end

  test 'should not sign in if password is invalid' do
    post sessions_url, params: { login: @user.username, password: 'wrong-pass' }

    assert_redirected_to new_session_path
    assert_equal flash[:alert], 'Invalid credentials!'
  end

  test 'should not sign in if login param is invalid' do
    post sessions_url, params: { login: 'wrong-user', password: 'testme' }

    assert_redirected_to new_session_path
    assert_equal flash[:alert], 'Invalid credentials!'
  end

  test 'should log out the user' do
    login

    delete session_url(@user.id)
    assert_redirected_to products_url
    assert_equal flash[:notice], 'Logged out!'
  end
end
