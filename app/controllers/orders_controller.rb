class OrdersController < ApplicationController
  before_action :set_order, only: [:show, :edit, :update, :destroy]
  def balo
    @orders = Order.includes(:order_colors).balo
  end

  def purge
    @orders = Order.includes(:order_colors).purge
  end

  def daily
    @orders = Order.where(sent_date: Date.today)
    @internal = @orders.select do |order|
      order.ship_code.downcase.in?(["nt", "cty"])
    end.group_by(&:product_code).map{|k,v|[k, v.length]}

    @express = @orders.select do |order|
      !order.ship_code.downcase.in?(["nt", "cty"])
    end.group_by(&:product_code).map{|k,v|[k, v.length]}
  end

  def download
    if params[:report_date]
      report_date = Date.parse(params[:report_date])
    else
      report_date = Date.today
    end

    respond_to do |format|
      format.xlsx do
        send_data ExcelHandler.export_daily_report(report_date),
          filename: "#{Date.today.strftime('%d/%m/%Y')}.xlsx"
      end
    end
  end

  def import_post
    ExcelHandler.import_excel(params[:file])
    redirect_to balo_products_path, notice: "Data imported."
  end

  def import_get
  end

  def index
    @orders = Order.all

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
    @order = Order.new
    4.times {@order.order_colors.build}
  end

  # GET /orders/1/edit
  def edit
  end

  # POST /orders
  # POST /orders.json
  def create
    @order = Order.new(order_params)
    product_type = params[:order][:product_type]
    if product_type
      url = product_type.to_s == 'balo' ? balo_orders_path : purge_orders_path
    else
      url = orders_path
    end

    if @order.save
      product = Product.find_by(code: @order.product_code)
      if product
        # product.update(remain_quantity: product.remain_quantity - order_colors.map(&:quantity).try(:sum))
        product_order_colors = product.order_colors
        import_order_colors = @order.order_colors
        @order.order_colors.each do |order_color|
          pc = product_order_colors.find{|c| c.color.downcase == order_color.color.downcase}
          pc.update(quantity: pc.quantity - order_color.quantity) if pc
        end
      end


      flash[:notice] = "Created"
      if params[:commit] == "Add and Continue"
        redirect_back(fallback_location: root_path, product_type: params[:order][:product_type])
      else
        redirect_to url
      end
    else
      render :new
    end
  end

  # PATCH/PUT /orders/1
  # PATCH/PUT /orders/1.json
  def update
    respond_to do |format|
      product_type = params[:order][:product_type]
      if product_type
        url = product_type.to_s == 'balo' ? balo_orders_path : purge_orders_path
      else
        url = orders_path
      end
      if @order.update(order_params)
        format.html { redirect_to url, notice: 'Order was successfully updated.' }
        format.json { render :show, status: :ok, location: @order }
      else
        format.html { render :edit }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /orders/1
  # DELETE /orders/1.json
  def destroy
    @order.destroy
    respond_to do |format|
      format.html { redirect_to orders_url, notice: 'Order was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_order
      @order = Order.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def order_params
      params.require(:order).permit(
          :customer_name,
          :product_code,
          :ship_code,
          :product_cost,
          :customer_phone,
          :ship_cost,
          :sent_date,
          :product_type,
          :note,
          order_colors_attributes: [:id, :quantity, :color, :target_id, :target_type, :_destroy]
        )
    end
end
