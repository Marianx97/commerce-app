class ProductsController < ApplicationController
  before_action :set_product, only: [:edit, :update, :show, :destroy]

  def index
    @categories = Category.order(name: :asc)
                          .load_async

    if params[:category_id]
      @products = Product.where(category_id: params[:category_id])
                         .with_attached_photo
                         .order(updated_at: :desc)
                         .load_async
    else
      @products = Product.with_attached_photo
                         .order(updated_at: :desc)
                         .load_async
    end
    if params[:min_price].present?
      @products = @products.where('price >= ?', params[:min_price])
    end

    if params[:max_price].present?
      @products = @products.where('price <= ?', params[:max_price])
    end
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
