class RepaysController < ApplicationController
  before_action :set_repay, only: [:show, :edit, :update, :destroy]

  def index
    @repays = Repay.includes(:order_colors).all

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
    @repay = Repay.new
    2.times {@repay.order_colors.build}
  end

  # GET /orders/1/edit
  def edit
  end

  # POST /orders
  # POST /orders.json
  def create
    @repay = Repay.new(repay_params)
    respond_to do |format|
      if @repay.save
        @repay.update_product_info
        format.html { redirect_to repays_path, notice: 'Import order was successfully created.' }
        format.json { render :show, status: :created, location: @repay }
      else
        format.html { render :new }
        format.json { render json: @repay.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /orders/1
  # PATCH/PUT /orders/1.json
  def update
    respond_to do |format|
      if @repay.update(repay_params)
        format.html { redirect_to repays_path, notice: 'Import order was successfully updated.' }
        format.json { render :show, status: :ok, location: @repay }
      else
        format.html { render :edit }
        format.json { render json: @repay.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /orders/1
  # DELETE /orders/1.json
  def destroy
    @repay.destroy
    respond_to do |format|
      format.html { redirect_to repays_path, notice: 'Import order was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_repay
      @repay = Repay.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def repay_params
      params.require(:repay).permit(
          :id,
          :customer_phone,
          :product_code,
          :sent_date,
          :repay_date,
          :quantity,
          :product_status,
          :note,
          order_colors_attributes: [:id, :quantity, :color, :target_id, :target_type, :_destroy]
        )
    end
end

