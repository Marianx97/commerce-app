class CategoriesController < ApplicationController
  before_action :set_category, only: %i[ edit update destroy ]

  def index
    @categories = Category.all.order(name: :asc)
  end

  def new
    @category = Category.new
  end

  def edit; end

  def create
    @category = Category.new(category_params)

    if @category.save
      redirect_to categories_url, notice: t('.created')
    else
      flash.now[:alert] = t('common.invalid_fields')
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @category.update(category_params)
      redirect_to categories_url, notice: t('.updated')
    else
      flash.now[:alert] = t('common.invalid_fields')
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @category.destroy
    redirect_to categories_url, notice: t('.destroyed'), status: :see_other
  end

  private

  def set_category
    @category = Category.find(params[:id])
  end


  def category_params
    params.require(:category).permit(:name)
  end
end
