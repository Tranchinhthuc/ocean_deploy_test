class ImportOrdersController < ApplicationController
  before_action :set_import_order, only: [:show, :edit, :update, :destroy]

  def index
    @import_orders = ImportOrder.includes(:order_colors).all

    # @q = Investor.ransack(params[:q])
    # @investors = @q.result.includes(:information)
    #                .order(created_at: :desc).page(params[:page])
    # @allow_batch_update_status =
    # params[:q].present? &&
    # params[:q][:status_eq].present? &&
    # @investors.first.try('waiting_confirm?')
  end

  # GET /orders/1
  # GET /orders/1.json
  def show
  end

  # GET /orders/new
  def new
    @import_order = ImportOrder.new
    4.times {@import_order.order_colors.build}
  end

  # GET /orders/1/edit
  def edit
  end

  # POST /orders
  # POST /orders.json
  def create
    @import_order = ImportOrder.new(import_order_params)
    respond_to do |format|
      if @import_order.save
        @import_order.update_product_info
        format.html { redirect_to import_orders_path, notice: 'Import order was successfully created.' }
        format.json { render :show, status: :created, location: @import_order }
      else
        format.html { render :new }
        format.json { render json: @import_order.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /orders/1
  # PATCH/PUT /orders/1.json
  def update
    respond_to do |format|
      if @import_order.update(import_order_params)
        format.html { redirect_to import_orders_path, notice: 'Import order was successfully updated.' }
        format.json { render :show, status: :ok, location: @import_order }
      else
        format.html { render :edit }
        format.json { render json: @import_order.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /orders/1
  # DELETE /orders/1.json
  def destroy
    @import_order.destroy
    respond_to do |format|
      format.html { redirect_to import_orders_path, notice: 'Import order was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_import_order
      @import_order = ImportOrder.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def import_order_params
      params.require(:import_order).permit(
          :id,
          :product_code,
          :product_type,
          :quantity,
          :import_date,
          order_colors_attributes: [:id, :quantity, :color, :target_id, :target_type, :_destroy]
        )
    end
end

