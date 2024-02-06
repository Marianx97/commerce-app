class Authentication::UsersController < ApplicationController
  skip_before_action :protect_pages

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    @user.country = FetchCountryService.new(request.remote_ip).perform

    if @user.save
      UserMailer.with(user: @user).welcome.deliver_later
      session[:user_id] = @user.id
      redirect_to products_path, notice: t('.created')
    else
      flash.now[:alert] = t('common.invalid_fields')
      render :new, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :username, :password)
  end
end
