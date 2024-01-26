class ProductsController < ApplicationController
  before_action :set_product, only: [:edit, :update, :show, :destroy]

  def index
    @products = Product.all.with_attached_photo
  end

  def show; end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(product_params)

    if @product.save
      redirect_to products_path, notice: 'Product created successfully!'
    else
      flash.now[:alert] = 'Invalid fields'
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @product.update(product_params)
      redirect_to product_path, notice: 'Product updated successfully!'
    else
      flash.now[:alert] = 'Invalid fields'
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @product.destroy
    redirect_to products_path, notice: 'Product successfully deleted', status: :see_other
  end

  private

  def product_params
    params.require(:product).permit(:title, :description, :price, :photo)
  end

  def set_product
    @product = Product.find(params[:id])
  end
end
