class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :edit, :update, :destroy]
  def balo
    @products = Product.balo
  end

  def purge
    @products = Product.purge
  end

  def daily
    @products = Product.where(sent_date: Date.today)
    @internal = @products.select do |product|
      product.ship_code.downcase.in?(["nt", "cty"])
    end.group_by(&:product_code).map{|k,v|[k, v.length]}
    @express = (@products - @internal).group_by(&:product_code).map{|k,v|[k, v.length]}
  end

  def index
    @products = Product.all

    # @q = Investor.ransack(params[:q])
    # @investors = @q.result.includes(:information)
    #                .product(created_at: :desc).page(params[:page])
    # @allow_batch_update_status =
    # params[:q].present? &&
    # params[:q][:status_eq].present? &&
    # @investors.first.try('waiting_confirm?')
  end

  # GET /products/1
  # GET /products/1.json
  def show
  end

  # GET /products/new
  def new
    @product = Product.new
    4.times {@product.order_colors.build}
  end

  # GET /products/1/edit
  def edit
  end

  # POST /products
  # POST /products.json
  def create
    @product = Product.new(product_params)
    product_type = params[:product][:product_type]
    if product_type
      url = product_type.to_s == 'balo' ? balo_products_path : purge_products_path
    else
      url = products_path
    end

    if @product.save
      flash[:notice] = "Created"
      if params[:commit] == "Add and Continue"
        redirect_back(fallback_location: root_path, product_type: params[:product][:product_type])
      else
        redirect_to url
      end
    else
      render :new
    end
  end

  # PATCH/PUT /products/1
  # PATCH/PUT /products/1.json
  def update
    respond_to do |format|
      product_type = params[:product][:product_type]
      if product_type
        url = product_type.to_s == 'balo' ? balo_products_path : purge_products_path
      else
        url = products_path
      end
      if @product.update(product_params)
        format.html { redirect_to url, notice: 'Product was successfully updated.' }
        format.json { render :show, status: :ok, location: @product }
      else
        format.html { render :edit }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /products/1
  # DELETE /products/1.json
  def destroy
    @product.destroy
    respond_to do |format|
      format.html { redirect_to products_url, notice: 'Product was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Product.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def product_params
      params.require(:product).permit(
          :code,
          :colors,
          :cost,
          :bought_quantity,
          :remain_quantity,
          :product_type,
          order_colors_attributes: [:id, :quantity, :color, :target_id, :target_type, :_destroy]
        )
    end
end
