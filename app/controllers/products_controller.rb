class ProductsController < ApplicationController
  before_action :set_product, only: %i[show edit update destroy]
  before_action :search, only: [:index]

  # GET /products or /products.json
  def index
    # @products = Product.all.order(id: :desc).paginate(page: params[:page], per_page: Settings.per_page_max)
    @pop_products = Product.recently_ordered.limit(Settings.limit).paginate(page: params[:page], per_page: Settings.per_page_min)
    # @order_item = current_order.order_items.new
    # @products = Product.all.order(id: :desc).paginate(page: params[:page], per_page: Settings.per_page_max)
  end

  # GET /products/1 or /products/1.json
  def show; end

  def search
    @order_item = current_order.order_items.new
    search_term = params[:search] || ""
    @products = Product.where("title LIKE ?", "%" + search_term + "%").order(id: :desc).paginate(page: params[:page], per_page: Settings.per_page_max)
    if @products.empty?
      flash[:error] = "Product was not found."
      redirect_to products_path
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_product
    @product = Product.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def product_params
    params.require(:product).permit(:category_id, :title, :price, :thumbnail, :description, :image)
  end
end
