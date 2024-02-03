class FavoritesController < ApplicationController
  def index; end

  def create
    product.favorite!
    respond_to do |format|
      format.html { redirect_to product_path(product) }
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace(
          'favorite',
          partial: 'products/favorite',
          locals: { product: product }
        )
      end
    end
  end

  def destroy
    product.unfavorite!
    respond_to do |format|
      format.html { redirect_to product_path(product), status: :see_other }
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace(
          'favorite',
          partial: 'products/favorite',
          locals: { product: product }
        )
      end
    end
  end

  private

  def product
    @product ||= Product.find(params[:product_id])
  end
end
