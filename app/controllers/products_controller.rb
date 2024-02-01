class ProductsController < ApplicationController
  before_action :set_product, only: [:edit, :update, :show, :destroy]

  def index
    @categories = Category.order(name: :asc).load_async

    @pagy, @products = pagy_countless(
      FindProducts.new.call(params).load_async,
      items: 12
    )
  end

  def show; end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(product_params)

    if @product.save
      redirect_to products_path, notice: t('.created')
    else
      flash.now[:alert] = t('common.invalid_fields')
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @product.update(product_params)
      redirect_to product_path, notice: t('.updated')
    else
      flash.now[:alert] = t('common.invalid_fields')
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @product.destroy
    redirect_to products_path, notice: t('.destroyed'), status: :see_other
  end

  private

  def product_params
    params.require(:product)
          .permit(:title, :description, :price, :photo, :category_id)
  end

  def set_product
    @product = Product.find(params[:id])
  end
end
