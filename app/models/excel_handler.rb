class ExcelHandler
  require 'rubyXL'

  def self.import_excel(file)
    Product.destroy_all
    ImportOrder.destroy_all
    Repay.destroy_all
    Order.destroy_all
    workbook = open_spreadsheet(file)
    balo_sheet = 1
    purge_sheet = 2
    import_sheet = 3
    repay_sheet = 4
    balo_monthly_sheet = 5
    purge_monthly_sheet = 6

    (5..workbook.sheet(balo_sheet).last_row).each do |i|
      product = Product.new
      product.code = workbook.sheet(balo_sheet).row(i)[1]
      product.cost = workbook.sheet(balo_sheet).row(i)[3]
      product.bought_quantity = workbook.sheet(balo_sheet).row(i)[4]
      product.product_type = 'balo'

      if workbook.sheet(balo_sheet).row(i)[0].present? && workbook.sheet(balo_sheet).row(i)[1].present? && product.save && workbook.sheet(balo_sheet).row(i)[7].present?
        workbook.sheet(balo_sheet).row(i)[7].to_s.split(",").each do |order_color|
          color = order_color.gsub(/\d+/, "").strip
          quantity = order_color[/\d+/]

          product.order_colors.create(color: color, quantity: quantity)
        end
      end

      student_product = Product.new
      student_product.code = workbook.sheet(balo_sheet).row(i)[9]
      student_product.cost = workbook.sheet(balo_sheet).row(i)[11]
      student_product.bought_quantity = workbook.sheet(balo_sheet).row(i)[12]
      student_product.product_type = 'student_balo'

      if workbook.sheet(balo_sheet).row(i)[9].present? && workbook.sheet(balo_sheet).row(i)[9].downcase.start_with?('h') && workbook.sheet(balo_sheet).row(i)[11].present? && student_product.save && workbook.sheet(balo_sheet).row(i)[15].present?
        workbook.sheet(balo_sheet).row(i)[15].to_s.split(",").each do |order_color|
          color = order_color.gsub(/\d+/, "").strip
          quantity = order_color[/\d+/]

          student_product.order_colors.create(color: color, quantity: quantity)
        end
      end

    end

    (5..workbook.sheet(purge_sheet).last_row).each do |i|
      product = Product.new
      product.code = workbook.sheet(purge_sheet).row(i)[1]
      product.cost = workbook.sheet(purge_sheet).row(i)[3]
      product.bought_quantity = workbook.sheet(purge_sheet).row(i)[4]
      product.product_type = 'purge'

      if workbook.sheet(purge_sheet).row(i)[1].present? && workbook.sheet(purge_sheet).row(i)[3].present? && product.save && workbook.sheet(purge_sheet).row(i)[7].present?
        workbook.sheet(purge_sheet).row(i)[7].to_s.split(",").each do |order_color|
          color = order_color.gsub(/\d+/, "").strip
          quantity = order_color[/\d+/]

          product.order_colors.create(color: color, quantity: quantity)
        end
      end
    end

# ImportSheet
    (5..workbook.sheet(import_sheet).last_row).each do |i|
      balo_import_order = ImportOrder.new
      balo_import_order.product_code = workbook.sheet(import_sheet).row(i)[1]
      balo_import_order.import_date = workbook.sheet(import_sheet).row(i)[0]
      balo_import_order.product_type = 'balo'

      if workbook.sheet(import_sheet).row(i)[0].present? && workbook.sheet(import_sheet).row(i)[1].present? && balo_import_order.save && workbook.sheet(import_sheet).row(i)[3].present?
        workbook.sheet(import_sheet).row(i)[3].to_s.split(",").each do |order_color|
          color = order_color.gsub(/\d+/, "").strip
          quantity = order_color[/\d+/]

          balo_import_order.order_colors.create(color: color, quantity: quantity)
        end
      end

      purge_import_order = ImportOrder.new
      purge_import_order.product_code = workbook.sheet(import_sheet).row(i)[7]
      purge_import_order.import_date = workbook.sheet(import_sheet).row(i)[6]
      purge_import_order.product_type = 'purge'

      if workbook.sheet(import_sheet).row(i)[6].present? && workbook.sheet(import_sheet).row(i)[7].present? && purge_import_order.save && workbook.sheet(import_sheet).row(i)[9].present?
        workbook.sheet(import_sheet).row(i)[9].to_s.split(",").each do |order_color|
          color = order_color.gsub(/\d+/, "").strip
          quantity = order_color[/\d+/]

          purge_import_order.order_colors.create(color: color, quantity: quantity)
        end
      end
    end


# Repay
    (7..workbook.sheet(repay_sheet).last_row).each do |i|
      repay = Repay.new
      repay.customer_phone = workbook.sheet(repay_sheet).row(i)[0]
      repay.product_code = workbook.sheet(repay_sheet).row(i)[1]
      repay.sent_date = workbook.sheet(repay_sheet).row(i)[2]
      repay.repay_date = workbook.sheet(repay_sheet).row(i)[3]
      repay.product_status = workbook.sheet(repay_sheet).row(i)[5]
      repay.note = workbook.sheet(repay_sheet).row(i)[6]

      if workbook.sheet(repay_sheet).row(i)[1].present? && workbook.sheet(repay_sheet).row(i)[1].present? && repay.save && workbook.sheet(repay_sheet).row(i)[4].present?
        workbook.sheet(repay_sheet).row(i)[4].to_s.split(",").each do |order_color|
          color = order_color.gsub(/\d+/, "").strip
          quantity = order_color[/\d+/]

          repay.order_colors.create(color: color, quantity: quantity)
        end
      end
    end

# BaloMonthlySheet
# customer_name: string, product_code: string, ship_code: string,
# customer_phone: string, product_cost: string, ship_cost: string,
# sent_date: date, note: text, product_type: integer, quantity: integer,

    (5..workbook.sheet(balo_monthly_sheet).last_row).each do |i|
      order = Order.new
      order.customer_name = workbook.sheet(balo_monthly_sheet).row(i)[1]
      order.product_code = workbook.sheet(balo_monthly_sheet).row(i)[2]
      order.ship_code = workbook.sheet(balo_monthly_sheet).row(i)[3]
      order.customer_phone = workbook.sheet(balo_monthly_sheet).row(i)[4]
      order.product_cost = workbook.sheet(balo_monthly_sheet).row(i)[5]
      order.ship_cost = workbook.sheet(balo_monthly_sheet).row(i)[6]
      order.sent_date = workbook.sheet(balo_monthly_sheet).row(i)[7]
      order.customer_email = workbook.sheet(balo_monthly_sheet).row(i)[9]
      order.customer_birthday = workbook.sheet(balo_monthly_sheet).row(i)[10]
      order.customer_address = workbook.sheet(balo_monthly_sheet).row(i)[11]
      order.product_type = 'balo'

      if workbook.sheet(balo_monthly_sheet).row(i)[0].present? && workbook.sheet(balo_monthly_sheet).row(i)[1].present? && order.save && workbook.sheet(balo_monthly_sheet).row(i)[8].present?
        workbook.sheet(balo_monthly_sheet).row(i)[8].to_s.split(",").each do |order_color|
          color = order_color.gsub(/\d+/, "").strip
          quantity = order_color[/\d+/]

          order.order_colors.create(color: color, quantity: quantity)
        end
      end
    end

    (6..workbook.sheet(purge_monthly_sheet).last_row).each do |i|
      order = Order.new
      order.customer_name = workbook.sheet(purge_monthly_sheet).row(i)[1]
      order.product_code = workbook.sheet(purge_monthly_sheet).row(i)[2]
      order.ship_code = workbook.sheet(purge_monthly_sheet).row(i)[3]
      order.customer_phone = workbook.sheet(purge_monthly_sheet).row(i)[4]
      order.product_cost = workbook.sheet(purge_monthly_sheet).row(i)[5]
      order.ship_cost = workbook.sheet(purge_monthly_sheet).row(i)[6]
      order.sent_date = workbook.sheet(purge_monthly_sheet).row(i)[7]
      order.customer_email = workbook.sheet(purge_monthly_sheet).row(i)[9]
      order.customer_birthday = workbook.sheet(purge_monthly_sheet).row(i)[10]
      order.customer_address = workbook.sheet(purge_monthly_sheet).row(i)[11]
      order.product_type = 'purge'

      if workbook.sheet(purge_monthly_sheet).row(i)[0].present? && workbook.sheet(purge_monthly_sheet).row(i)[1].present? && order.save && workbook.sheet(purge_monthly_sheet).row(i)[8].present?
        workbook.sheet(purge_monthly_sheet).row(i)[8].to_s.split(",").each do |order_color|
          color = order_color.gsub(/\d+/, "").strip
          quantity = order_color[/\d+/]

          order.order_colors.create(color: color, quantity: quantity)
        end
      end
    end
  end

  def self.open_spreadsheet(file)
      case File.extname(file.original_filename)
          when ".csv" then Roo::CSV.new(file.path)
          when ".xls" then Roo::Excel.new(file.path)
          when ".xlsx" then Roo::Excelx.new(file.path)
          else raise "Unknown file type: #{file.original_filename}"
      end
  end

  def self.export_daily_report(report_date)
#     user = User.find_by(id: manager_evaluation.plan.staff_id)
#     period = manager_evaluation.plan.group_plan
#     manager_evaluation_details = manager_evaluation.evaluation_details
#     self_evaluation_details = self_evaluation.evaluation_details
#     pattern = manager_evaluation.plan.pattern
#     kpis = pattern.key_performance_indicators
#     group = Group.find_by(id: period.try(:group_id))

    workbook = RubyXL::Workbook.new

    sheets = []

    daily_sheet = workbook[0]
    daily_sheet.sheet_name = "Hàng ngày"

    balo_sheet = workbook.add_worksheet("Balo")
    purge_sheet = workbook.add_worksheet("Túi xách")
    import_sheet = workbook.add_worksheet("Hàng nhập")
    repay_sheet = workbook.add_worksheet("Hàng trả")
    balo_monthly_sheet = workbook.add_worksheet("Tháng #{report_date.month} Balo")
    purge_monthly_sheet = workbook.add_worksheet("Tháng #{report_date.month} túi xách")

# DailySheet
    (0..22).each do |col|
      daily_sheet.change_column_font_size(col, 12)
      daily_sheet.change_column_font_name(col, 'Times New Roman')
      daily_sheet.change_column_width(col, 15)
    end

    daily_sheet.add_cell(2, 4, "Hàng bán trong ngày #{report_date.strftime('%d/%m/%Y')}".upcase)
    daily_sheet.merge_cells(2, 4, 2, 11)
    daily_sheet.change_row_height(2, 24)
    daily_sheet.sheet_data[2][4].change_fill('f4a466')
    daily_sheet.sheet_data[2][4].change_horizontal_alignment('center')
    daily_sheet.sheet_data[2][4].change_vertical_alignment('center')

    daily_sheet.sheet_data[2][4].change_font_bold(true)
    daily_sheet.sheet_data[2][4].change_font_size(16)


    daily_sheet.add_cell(5, 4, "Giao hàng nhanh")
    daily_sheet.sheet_data[5][4].change_font_bold(true)
    daily_sheet.add_cell(7, 3, "STT")
    daily_sheet.sheet_data[7][3].change_fill('f48630')
    daily_sheet.add_cell(7, 4, "Mã SP")
    daily_sheet.sheet_data[7][4].change_fill('f48630')
    daily_sheet.add_cell(7, 5, "Số lượng")
    daily_sheet.sheet_data[7][5].change_fill('f48630')

    daily_sheet.add_cell(5, 8, "Nội thành")
    daily_sheet.sheet_data[5][8].change_font_bold(true)
    daily_sheet.add_cell(7, 7, "STT")
    daily_sheet.sheet_data[7][7].change_fill('f48630')
    daily_sheet.add_cell(7, 8, "Mã SP")
    daily_sheet.sheet_data[7][8].change_fill('f48630')
    daily_sheet.add_cell(7, 9, "Số lượng")
    daily_sheet.sheet_data[7][9].change_fill('f48630')

    daily_sheet.add_cell(5, 12, "Những mẫu đang nợ khách trong ngày")
    daily_sheet.sheet_data[5][12].change_font_bold(true)
    daily_sheet.add_cell(7, 12, "STT")
    daily_sheet.sheet_data[7][12].change_fill('f48630')
    daily_sheet.add_cell(7, 13, "Mã SP")
    daily_sheet.sheet_data[7][13].change_fill('f48630')
    daily_sheet.add_cell(7, 14, "Số lượng")
    daily_sheet.sheet_data[7][14].change_fill('f48630')
    daily_sheet.add_cell(7, 15, "Ghi chú")
    daily_sheet.sheet_data[7][15].change_fill('f48630')

    daily_sheet.add_cell(5, 18, "Những mẫu đề xuất bán chạy mà hết hàng")
    daily_sheet.sheet_data[5][18].change_font_bold(true)
    daily_sheet.add_cell(7, 18, "STT")
    daily_sheet.sheet_data[7][18].change_fill('f48630')
    daily_sheet.add_cell(7, 19, "Mã SP")
    daily_sheet.sheet_data[7][19].change_fill('f48630')
    daily_sheet.add_cell(7, 20, "Số lượng")
    daily_sheet.sheet_data[7][20].change_fill('f48630')
    daily_sheet.add_cell(7, 21, "Ghi chú")
    daily_sheet.sheet_data[7][21].change_fill('f48630')

    orders = Order.where(sent_date: report_date)
    internal = orders.select do |order|
      order.ship_code.downcase.in?(["nt", "cty"])
    end.group_by(&:product_code).map{|k,v|[k, v.length]}

    express = orders.select do |order|
      !order.ship_code.downcase.in?(["nt", "cty"])
    end.group_by(&:product_code).map{|k,v|[k, v.length]}

    express.each.with_index do |order, index|
      daily_sheet.add_cell(8 + index, 3, index + 1)
      daily_sheet.sheet_data[8 + index][3].change_horizontal_alignment('center')
      daily_sheet.add_cell(8 + index, 4, order[0])
      daily_sheet.add_cell(8 + index, 5, order[1])
    end

    internal.each.with_index do |order, index|
      daily_sheet.add_cell(8 + index, 7, index + 1)
      daily_sheet.sheet_data[8 + index][7].change_horizontal_alignment('center')
      daily_sheet.add_cell(8 + index, 8, order[0])
      daily_sheet.add_cell(8 + index, 9, order[1])
    end

  # BaloSheet
    (0..20).each do |col|
      balo_sheet.change_column_font_size(col, 12)
      balo_sheet.change_column_font_name(col, 'Times New Roman')
      balo_sheet.change_column_width(col, 15)
    end

    balo_sheet.change_column_width(0, 0)

    balo_sheet.add_cell(1, 4, "Thống kê hàng #{report_date.strftime('%d/%m/%Y')}".upcase)
    balo_sheet.merge_cells(1, 4, 1, 10)
    balo_sheet.change_row_height(1, 24)
    balo_sheet.sheet_data[1][4].change_fill('f4a466')
    balo_sheet.sheet_data[1][4].change_horizontal_alignment('center')
    balo_sheet.sheet_data[1][4].change_vertical_alignment('center')

    balo_sheet.sheet_data[1][4].change_font_bold(true)
    balo_sheet.sheet_data[1][4].change_font_size(16)

    balo_sheet.add_cell(3, 4, "STT")
    balo_sheet.sheet_data[3][4].change_fill('f48630')
    balo_sheet.sheet_data[3][4].change_horizontal_alignment('center')
    balo_sheet.sheet_data[3][4].change_vertical_alignment('center')
    balo_sheet.sheet_data[3][4].change_font_bold(true)
    balo_sheet.sheet_data[3][4].change_font_color('ffffff')
    balo_sheet.add_cell(3, 5, "Mã SP")
    balo_sheet.sheet_data[3][5].change_fill('f48630')
    balo_sheet.sheet_data[3][5].change_horizontal_alignment('center')
    balo_sheet.sheet_data[3][5].change_vertical_alignment('center')
    balo_sheet.sheet_data[3][5].change_font_bold(true)
    balo_sheet.sheet_data[3][5].change_font_color('ffffff')
    balo_sheet.add_cell(3, 6, "Ảnh")
    balo_sheet.sheet_data[3][6].change_fill('f48630')
    balo_sheet.sheet_data[3][6].change_horizontal_alignment('center')
    balo_sheet.sheet_data[3][6].change_vertical_alignment('center')
    balo_sheet.sheet_data[3][6].change_font_bold(true)
    balo_sheet.sheet_data[3][6].change_font_color('ffffff')
    balo_sheet.add_cell(3, 7, "Giá")
    balo_sheet.sheet_data[3][7].change_fill('f48630')
    balo_sheet.sheet_data[3][7].change_horizontal_alignment('center')
    balo_sheet.sheet_data[3][7].change_vertical_alignment('center')
    balo_sheet.sheet_data[3][7].change_font_bold(true)
    balo_sheet.sheet_data[3][7].change_font_color('ffffff')
    balo_sheet.add_cell(3, 8, "Số lượng")
    balo_sheet.sheet_data[3][8].change_fill('f48630')
    balo_sheet.sheet_data[3][8].change_horizontal_alignment('center')
    balo_sheet.sheet_data[3][8].change_vertical_alignment('center')
    balo_sheet.sheet_data[3][8].change_font_bold(true)
    balo_sheet.sheet_data[3][8].change_font_color('ffffff')
    balo_sheet.add_cell(3, 9, "Bán")
    balo_sheet.sheet_data[3][9].change_fill('f48630')
    balo_sheet.sheet_data[3][9].change_horizontal_alignment('center')
    balo_sheet.sheet_data[3][9].change_vertical_alignment('center')
    balo_sheet.sheet_data[3][9].change_font_bold(true)
    balo_sheet.sheet_data[3][9].change_font_color('ffffff')
    balo_sheet.add_cell(3, 10, "Tồn")
    balo_sheet.sheet_data[3][10].change_fill('f48630')
    balo_sheet.sheet_data[3][10].change_horizontal_alignment('center')
    balo_sheet.sheet_data[3][10].change_vertical_alignment('center')
    balo_sheet.sheet_data[3][10].change_font_bold(true)
    balo_sheet.sheet_data[3][10].change_font_color('ffffff')
    balo_sheet.add_cell(3, 11, "Ghi chú")
    balo_sheet.sheet_data[3][11].change_fill('f48630')
    balo_sheet.sheet_data[3][11].change_horizontal_alignment('center')
    balo_sheet.sheet_data[3][11].change_vertical_alignment('center')
    balo_sheet.sheet_data[3][11].change_font_bold(true)
    balo_sheet.sheet_data[3][11].change_font_color('ffffff')
    balo_sheet.change_column_width(11, 30)


    balo_sheet.add_cell(3, 13, "STT")
    balo_sheet.sheet_data[3][13].change_fill('f48630')
    balo_sheet.sheet_data[3][13].change_horizontal_alignment('center')
    balo_sheet.sheet_data[3][13].change_vertical_alignment('center')
    balo_sheet.sheet_data[3][13].change_font_bold(true)
    balo_sheet.sheet_data[3][13].change_font_color('ffffff')
    balo_sheet.add_cell(3, 14, "Mã SP")
    balo_sheet.sheet_data[3][14].change_fill('f48630')
    balo_sheet.sheet_data[3][14].change_horizontal_alignment('center')
    balo_sheet.sheet_data[3][14].change_vertical_alignment('center')
    balo_sheet.sheet_data[3][14].change_font_bold(true)
    balo_sheet.sheet_data[3][14].change_font_color('ffffff')
    balo_sheet.add_cell(3, 15, "Ảnh")
    balo_sheet.sheet_data[3][15].change_fill('f48630')
    balo_sheet.sheet_data[3][15].change_horizontal_alignment('center')
    balo_sheet.sheet_data[3][15].change_vertical_alignment('center')
    balo_sheet.sheet_data[3][15].change_font_bold(true)
    balo_sheet.sheet_data[3][15].change_font_color('ffffff')
    balo_sheet.add_cell(3, 16, "Giá")
    balo_sheet.sheet_data[3][16].change_fill('f48630')
    balo_sheet.sheet_data[3][16].change_horizontal_alignment('center')
    balo_sheet.sheet_data[3][16].change_vertical_alignment('center')
    balo_sheet.sheet_data[3][16].change_font_bold(true)
    balo_sheet.sheet_data[3][16].change_font_color('ffffff')
    balo_sheet.add_cell(3, 17, "Số lượng")
    balo_sheet.sheet_data[3][17].change_fill('f48630')
    balo_sheet.sheet_data[3][17].change_horizontal_alignment('center')
    balo_sheet.sheet_data[3][17].change_vertical_alignment('center')
    balo_sheet.sheet_data[3][17].change_font_bold(true)
    balo_sheet.sheet_data[3][17].change_font_color('ffffff')
    balo_sheet.add_cell(3, 18, "Bán")
    balo_sheet.sheet_data[3][18].change_fill('f48630')
    balo_sheet.sheet_data[3][18].change_horizontal_alignment('center')
    balo_sheet.sheet_data[3][18].change_vertical_alignment('center')
    balo_sheet.sheet_data[3][18].change_font_bold(true)
    balo_sheet.sheet_data[3][18].change_font_color('ffffff')
    balo_sheet.add_cell(3, 19, "Tồn")
    balo_sheet.sheet_data[3][19].change_fill('f48630')
    balo_sheet.sheet_data[3][19].change_horizontal_alignment('center')
    balo_sheet.sheet_data[3][19].change_vertical_alignment('center')
    balo_sheet.sheet_data[3][19].change_font_bold(true)
    balo_sheet.sheet_data[3][19].change_font_color('ffffff')
    balo_sheet.add_cell(3, 20, "Ghi chú")
    balo_sheet.sheet_data[3][20].change_fill('f48630')
    balo_sheet.sheet_data[3][20].change_horizontal_alignment('center')
    balo_sheet.sheet_data[3][20].change_vertical_alignment('center')
    balo_sheet.sheet_data[3][20].change_font_bold(true)
    balo_sheet.sheet_data[3][20].change_font_color('ffffff')
    balo_sheet.change_column_width(20, 30)

    products = Product.balo
    products.each.with_index do |product, index|
      balo_sheet.add_cell(4 + index, 4, index + 1)
      balo_sheet.add_cell(4 + index, 5, product.code)
      balo_sheet.add_cell(4 + index, 6, "")
      balo_sheet.add_cell(4 + index, 7, product.cost)
      balo_sheet.add_cell(4 + index, 8, product.bought_quantity)
      balo_sheet.add_cell(4 + index, 9, product.bought_quantity.to_i - product.order_colors.map(&:quantity).try(:sum))
      balo_sheet.add_cell(4 + index, 10, product.order_colors.map(&:quantity).try(:sum))
      balo_sheet.add_cell(4 + index, 11, product.colors_to_s)
    end

    student_products = Product.student_balo
    student_products.each.with_index do |product, index|
      balo_sheet.add_cell(4 + index, 13, index + 1)
      balo_sheet.add_cell(4 + index, 14, product.code)
      balo_sheet.add_cell(4 + index, 15, "")
      balo_sheet.add_cell(4 + index, 16, product.cost)
      balo_sheet.add_cell(4 + index, 17, product.bought_quantity)
      balo_sheet.add_cell(4 + index, 18, product.bought_quantity.to_i - product.order_colors.map(&:quantity).try(:sum))
      balo_sheet.add_cell(4 + index, 19, product.order_colors.map(&:quantity).try(:sum))
      balo_sheet.add_cell(4 + index, 20, product.colors_to_s)
    end

    (products.count + 8).times do |row|
      balo_sheet.change_row_height(row, 24)
      21.times do |col|
        balo_sheet.sheet_data[row][col].try(:change_border, :top, 'thin')
        balo_sheet.sheet_data[row][col].try(:change_border, :bottom, 'thin')
        balo_sheet.sheet_data[row][col].try(:change_border, :left, 'thin')
        balo_sheet.sheet_data[row][col].try(:change_border, :right, 'thin')
      end
    end

  # PurgeSheet
    (0..12).each do |col|
      purge_sheet.change_column_font_size(col, 12)
      purge_sheet.change_column_font_name(col, 'Times New Roman')
      purge_sheet.change_column_width(col, 15)
    end

    purge_sheet.add_cell(1, 4, "Thống kê hàng #{report_date.strftime('%d/%m/%Y')}".upcase)
    purge_sheet.merge_cells(1, 4, 1, 10)
    purge_sheet.change_row_height(1, 24)
    purge_sheet.sheet_data[1][4].change_fill('f4a466')
    purge_sheet.sheet_data[1][4].change_horizontal_alignment('center')
    purge_sheet.sheet_data[1][4].change_vertical_alignment('center')

    purge_sheet.sheet_data[1][4].change_font_bold(true)
    purge_sheet.sheet_data[1][4].change_font_size(16)

    purge_sheet.add_cell(3, 4, "STT")
    purge_sheet.sheet_data[3][4].change_fill('f48630')
    purge_sheet.sheet_data[3][4].change_horizontal_alignment('center')
    purge_sheet.sheet_data[3][4].change_vertical_alignment('center')
    purge_sheet.sheet_data[3][4].change_font_bold(true)
    purge_sheet.sheet_data[3][4].change_font_color('ffffff')
    purge_sheet.add_cell(3, 5, "Mã SP")
    purge_sheet.sheet_data[3][5].change_fill('f48630')
    purge_sheet.sheet_data[3][5].change_horizontal_alignment('center')
    purge_sheet.sheet_data[3][5].change_vertical_alignment('center')
    purge_sheet.sheet_data[3][5].change_font_bold(true)
    purge_sheet.sheet_data[3][5].change_font_color('ffffff')
    purge_sheet.add_cell(3, 6, "Ảnh")
    purge_sheet.sheet_data[3][6].change_fill('f48630')
    purge_sheet.sheet_data[3][6].change_horizontal_alignment('center')
    purge_sheet.sheet_data[3][6].change_vertical_alignment('center')
    purge_sheet.sheet_data[3][6].change_font_bold(true)
    purge_sheet.sheet_data[3][6].change_font_color('ffffff')
    purge_sheet.add_cell(3, 7, "Giá")
    purge_sheet.sheet_data[3][7].change_fill('f48630')
    purge_sheet.sheet_data[3][7].change_horizontal_alignment('center')
    purge_sheet.sheet_data[3][7].change_vertical_alignment('center')
    purge_sheet.sheet_data[3][7].change_font_bold(true)
    purge_sheet.sheet_data[3][7].change_font_color('ffffff')
    purge_sheet.add_cell(3, 8, "Số lượng")
    purge_sheet.sheet_data[3][8].change_fill('f48630')
    purge_sheet.sheet_data[3][8].change_horizontal_alignment('center')
    purge_sheet.sheet_data[3][8].change_vertical_alignment('center')
    purge_sheet.sheet_data[3][8].change_font_bold(true)
    purge_sheet.sheet_data[3][8].change_font_color('ffffff')
    purge_sheet.add_cell(3, 9, "Bán")
    purge_sheet.sheet_data[3][9].change_fill('f48630')
    purge_sheet.sheet_data[3][9].change_horizontal_alignment('center')
    purge_sheet.sheet_data[3][9].change_vertical_alignment('center')
    purge_sheet.sheet_data[3][9].change_font_bold(true)
    purge_sheet.sheet_data[3][9].change_font_color('ffffff')
    purge_sheet.add_cell(3, 10, "Tồn")
    purge_sheet.sheet_data[3][10].change_fill('f48630')
    purge_sheet.sheet_data[3][10].change_horizontal_alignment('center')
    purge_sheet.sheet_data[3][10].change_vertical_alignment('center')
    purge_sheet.sheet_data[3][10].change_font_bold(true)
    purge_sheet.sheet_data[3][10].change_font_color('ffffff')
    purge_sheet.add_cell(3, 11, "Ghi chú")
    purge_sheet.sheet_data[3][11].change_fill('f48630')
    purge_sheet.sheet_data[3][11].change_horizontal_alignment('center')
    purge_sheet.sheet_data[3][11].change_vertical_alignment('center')
    purge_sheet.sheet_data[3][11].change_font_bold(true)
    purge_sheet.sheet_data[3][11].change_font_color('ffffff')
    purge_sheet.change_column_width(11, 30)

    products = Product.purge
    products.each.with_index do |product, index|
      purge_sheet.add_cell(4 + index, 4, index + 1)
      purge_sheet.add_cell(4 + index, 5, product.code)
      purge_sheet.add_cell(4 + index, 6, "")
      purge_sheet.add_cell(4 + index, 7, product.cost)
      purge_sheet.add_cell(4 + index, 8, product.bought_quantity)
      purge_sheet.add_cell(4 + index, 9, product.bought_quantity.to_i - product.order_colors.map(&:quantity).try(:sum))
      purge_sheet.add_cell(4 + index, 10, product.order_colors.map(&:quantity).try(:sum))
      purge_sheet.add_cell(4 + index, 11, product.colors_to_s)
    end

    (products.count + 8).times do |row|
      purge_sheet.change_row_height(row, 24)
      12.times do |col|
        purge_sheet.sheet_data[row][col].try(:change_border, :top, 'thin')
        purge_sheet.sheet_data[row][col].try(:change_border, :bottom, 'thin')
        purge_sheet.sheet_data[row][col].try(:change_border, :left, 'thin')
        purge_sheet.sheet_data[row][col].try(:change_border, :right, 'thin')
      end
    end

    # ImportSheet
    (0..12).each do |col|
      import_sheet.change_column_font_size(col, 12)
      import_sheet.change_column_font_name(col, 'Times New Roman')
      import_sheet.change_column_width(col, 15)
    end

    import_sheet.add_cell(1, 1, "BẢNG THỐNG KÊ NHẬP HÀNG THÁNG #{report_date.month}".upcase)
    import_sheet.merge_cells(1, 1, 2, 9)
    import_sheet.change_row_height(1, 35)
    import_sheet.sheet_data[1][1].change_fill('f4a466')
    import_sheet.sheet_data[1][1].change_horizontal_alignment('center')
    import_sheet.sheet_data[1][1].change_vertical_alignment('center')

    import_sheet.sheet_data[1][1].change_font_bold(true)
    import_sheet.sheet_data[1][1].change_font_size(16)

    import_sheet.add_cell(3, 1, "Ngày")
    import_sheet.sheet_data[3][1].change_fill('dcbdf2')
    import_sheet.sheet_data[3][1].change_horizontal_alignment('center')
    import_sheet.sheet_data[3][1].change_vertical_alignment('center')
    import_sheet.sheet_data[3][1].change_font_bold(true)
    import_sheet.add_cell(3, 2, "Mã Balo")
    import_sheet.sheet_data[3][2].change_fill('dcbdf2')
    import_sheet.sheet_data[3][2].change_horizontal_alignment('center')
    import_sheet.sheet_data[3][2].change_vertical_alignment('center')
    import_sheet.sheet_data[3][2].change_font_bold(true)
    import_sheet.add_cell(3, 3, "SL")
    import_sheet.sheet_data[3][3].change_fill('dcbdf2')
    import_sheet.sheet_data[3][3].change_horizontal_alignment('center')
    import_sheet.sheet_data[3][3].change_vertical_alignment('center')
    import_sheet.sheet_data[3][3].change_font_bold(true)
    import_sheet.add_cell(3, 4, "Màu")
    import_sheet.sheet_data[3][4].change_fill('dcbdf2')
    import_sheet.sheet_data[3][4].change_horizontal_alignment('center')
    import_sheet.sheet_data[3][4].change_vertical_alignment('center')
    import_sheet.sheet_data[3][4].change_font_bold(true)
    import_sheet.add_cell(3, 6, "Ngày")
    import_sheet.sheet_data[3][6].change_fill('dcbdf2')
    import_sheet.sheet_data[3][6].change_horizontal_alignment('center')
    import_sheet.sheet_data[3][6].change_vertical_alignment('center')
    import_sheet.sheet_data[3][6].change_font_bold(true)
    import_sheet.add_cell(3, 7, "Mã túi xách")
    import_sheet.sheet_data[3][7].change_fill('dcbdf2')
    import_sheet.sheet_data[3][7].change_horizontal_alignment('center')
    import_sheet.sheet_data[3][7].change_vertical_alignment('center')
    import_sheet.sheet_data[3][7].change_font_bold(true)
    import_sheet.change_column_width(7, 20)
    import_sheet.add_cell(3, 8, "SL")
    import_sheet.sheet_data[3][8].change_fill('dcbdf2')
    import_sheet.sheet_data[3][8].change_horizontal_alignment('center')
    import_sheet.sheet_data[3][8].change_vertical_alignment('center')
    import_sheet.sheet_data[3][8].change_font_bold(true)
    import_sheet.add_cell(3, 9, "Màu")
    import_sheet.sheet_data[3][9].change_fill('dcbdf2')
    import_sheet.sheet_data[3][9].change_horizontal_alignment('center')
    import_sheet.sheet_data[3][9].change_vertical_alignment('center')
    import_sheet.sheet_data[3][9].change_font_bold(true)
    import_sheet.change_column_width(4, 20)
    import_sheet.change_column_width(9, 20)

    import_orders = ImportOrder.all.select{|o| o.import_date.try(:month) == report_date.month }
    balos = import_orders.select{|o| o.product_type == 'balo' }
    purges = import_orders.select{|o| o.product_type == 'purge' }

    balos.each.with_index do |import_order, index|
      import_sheet.add_cell(4 + index, 1, import_order.import_date.try(:strftime, '%d/%m'))
      import_sheet.add_cell(4 + index, 2, import_order.product_code)
      import_sheet.add_cell(4 + index, 3, import_order.order_colors.map(&:quantity).try(:sum))
      import_sheet.add_cell(4 + index, 4, import_order.colors_to_s)
    end

    purges.each.with_index do |import_order, index|
      import_sheet.add_cell(4 + index, 6, import_order.import_date.try(:strftime, '%d/%m'))
      import_sheet.add_cell(4 + index, 7, import_order.product_code)
      import_sheet.add_cell(4 + index, 8, import_order.order_colors.map(&:quantity).try(:sum))
      import_sheet.add_cell(4 + index, 9, import_order.colors_to_s)
    end

    rows = purges.count > balos.count ? purges.count : balos.count
    (rows + 8).times do |row|
      import_sheet.change_row_height(row, 24)
      12.times do |col|
        import_sheet.sheet_data[row][col].try(:change_border, :top, 'thin')
        import_sheet.sheet_data[row][col].try(:change_border, :bottom, 'thin')
        import_sheet.sheet_data[row][col].try(:change_border, :left, 'thin')
        import_sheet.sheet_data[row][col].try(:change_border, :right, 'thin')
      end
    end

    # RepaySheet
    (0..12).each do |col|
      repay_sheet.change_column_font_size(col, 12)
      repay_sheet.change_column_font_name(col, 'Times New Roman')
      repay_sheet.change_column_width(col, 15)
    end

    repay_sheet.add_cell(2, 3, "Thông tin hàng trả".upcase)
    repay_sheet.merge_cells(2, 3, 2, 9)
    repay_sheet.change_row_height(2, 24)
    repay_sheet.sheet_data[2][3].change_fill('f4a466')


    repay_sheet.sheet_data[2][3].change_font_bold(true)
    repay_sheet.sheet_data[2][3].change_font_size(16)

    repay_sheet.add_cell(5, 3, "Tên Khách Hàng")
    repay_sheet.sheet_data[5][3].change_fill('f48630')
    repay_sheet.add_cell(5, 4, "Mã SP")
    repay_sheet.sheet_data[5][4].change_fill('f48630')
    repay_sheet.add_cell(5, 5, "Ngày mua")
    repay_sheet.sheet_data[5][5].change_fill('f48630')
    repay_sheet.add_cell(5, 6, "Ngày trả")
    repay_sheet.sheet_data[5][6].change_fill('f48630')
    repay_sheet.add_cell(5, 7, "Số lượng")
    repay_sheet.sheet_data[5][7].change_fill('f48630')
    repay_sheet.add_cell(5, 8, "Tình trạng sản phẩm")
    repay_sheet.sheet_data[5][8].change_fill('f48630')
    repay_sheet.add_cell(5, 9, "Ghi chú")
    repay_sheet.sheet_data[5][9].change_fill('f48630')

    repay_sheet.change_column_width(3, 25)
    repay_sheet.change_column_width(8, 25)

    repays = Repay.all.select{|o| o.repay_date.try(:month) == report_date.month }

    repays.each.with_index do |repay, index|
      repay_sheet.add_cell(6 + index, 3, repay.customer_phone)
      repay_sheet.add_cell(6 + index, 4, repay.product_code)
      repay_sheet.add_cell(6 + index, 5, repay.sent_date.try(:strftime, '%d/%m'))
      repay_sheet.add_cell(6 + index, 6, repay.repay_date.try(:strftime, '%d/%m'))
      repay_sheet.add_cell(6 + index, 7, repay.order_colors.map(&:quantity).try(:sum))
      repay_sheet.add_cell(6 + index, 8, repay.product_status)
      repay_sheet.add_cell(6 + index, 9, repay.colors_to_s)
    end

    (repays.count + 8).times do |row|
      repay_sheet.change_row_height(row, 24)
      12.times do |col|
        repay_sheet.sheet_data[row][col].try(:change_border, :top, 'thin')
        repay_sheet.sheet_data[row][col].try(:change_border, :bottom, 'thin')
        repay_sheet.sheet_data[row][col].try(:change_border, :left, 'thin')
        repay_sheet.sheet_data[row][col].try(:change_border, :right, 'thin')
      end
    end

    # BaloMonthlySheet
    (0..16).each do |col|
      balo_monthly_sheet.change_column_font_size(col, 12)
      balo_monthly_sheet.change_column_font_name(col, 'Times New Roman')
      balo_monthly_sheet.change_column_width(col, 15)
    end

    balo_monthly_sheet.add_cell(3, 1, "Thông tin khách hàng".upcase)
    balo_monthly_sheet.merge_cells(3, 1, 3, 12)
    balo_monthly_sheet.change_row_height(3, 24)
    balo_monthly_sheet.sheet_data[3][1].change_fill('f4a466')
    balo_monthly_sheet.sheet_data[3][1].change_horizontal_alignment('center')
    balo_monthly_sheet.sheet_data[3][1].change_vertical_alignment('center')

    balo_monthly_sheet.sheet_data[3][1].change_font_bold(true)
    balo_monthly_sheet.sheet_data[3][1].change_font_size(16)

    balo_monthly_sheet.add_cell(4, 1, "STT")
    balo_monthly_sheet.sheet_data[4][1].change_fill('f48630')
    balo_monthly_sheet.sheet_data[4][1].change_horizontal_alignment('center')
    balo_monthly_sheet.sheet_data[4][1].change_vertical_alignment('center')
    balo_monthly_sheet.sheet_data[4][1].change_font_bold(true)
    balo_monthly_sheet.add_cell(4, 2, "Khách Hàng")
    balo_monthly_sheet.sheet_data[4][2].change_fill('f48630')
    balo_monthly_sheet.sheet_data[4][2].change_horizontal_alignment('center')
    balo_monthly_sheet.sheet_data[4][2].change_vertical_alignment('center')
    balo_monthly_sheet.sheet_data[4][2].change_font_bold(true)
    balo_monthly_sheet.add_cell(4, 3, "Mã SP")
    balo_monthly_sheet.sheet_data[4][3].change_fill('f48630')
    balo_monthly_sheet.sheet_data[4][3].change_horizontal_alignment('center')
    balo_monthly_sheet.sheet_data[4][3].change_vertical_alignment('center')
    balo_monthly_sheet.sheet_data[4][3].change_font_bold(true)
    balo_monthly_sheet.add_cell(4, 4, "Mã code")
    balo_monthly_sheet.sheet_data[4][4].change_fill('f48630')
    balo_monthly_sheet.sheet_data[4][4].change_horizontal_alignment('center')
    balo_monthly_sheet.sheet_data[4][4].change_vertical_alignment('center')
    balo_monthly_sheet.sheet_data[4][4].change_font_bold(true)
    balo_monthly_sheet.add_cell(4, 5, "Số ĐT")
    balo_monthly_sheet.sheet_data[4][5].change_fill('f48630')
    balo_monthly_sheet.sheet_data[4][5].change_horizontal_alignment('center')
    balo_monthly_sheet.sheet_data[4][5].change_vertical_alignment('center')
    balo_monthly_sheet.sheet_data[4][5].change_font_bold(true)
    balo_monthly_sheet.add_cell(4, 6, "Tiền hàng")
    balo_monthly_sheet.sheet_data[4][6].change_fill('f48630')
    balo_monthly_sheet.sheet_data[4][6].change_horizontal_alignment('center')
    balo_monthly_sheet.sheet_data[4][6].change_vertical_alignment('center')
    balo_monthly_sheet.sheet_data[4][6].change_font_bold(true)
    balo_monthly_sheet.add_cell(4, 7, "Ship")
    balo_monthly_sheet.sheet_data[4][7].change_fill('f48630')
    balo_monthly_sheet.sheet_data[4][7].change_horizontal_alignment('center')
    balo_monthly_sheet.sheet_data[4][7].change_vertical_alignment('center')
    balo_monthly_sheet.sheet_data[4][7].change_font_bold(true)
    balo_monthly_sheet.add_cell(4, 8, "Ngày gửi")
    balo_monthly_sheet.sheet_data[4][8].change_fill('f48630')
    balo_monthly_sheet.sheet_data[4][8].change_horizontal_alignment('center')
    balo_monthly_sheet.sheet_data[4][8].change_vertical_alignment('center')
    balo_monthly_sheet.sheet_data[4][8].change_font_bold(true)
    balo_monthly_sheet.add_cell(4, 9, "Ghi chú")
    balo_monthly_sheet.sheet_data[4][9].change_fill('f48630')
    balo_monthly_sheet.sheet_data[4][9].change_horizontal_alignment('center')
    balo_monthly_sheet.sheet_data[4][9].change_vertical_alignment('center')
    balo_monthly_sheet.sheet_data[4][9].change_font_bold(true)
    # Add more
    balo_monthly_sheet.add_cell(4, 10, "Gmail")
    balo_monthly_sheet.sheet_data[4][10].change_fill('f48630')
    balo_monthly_sheet.sheet_data[4][10].change_horizontal_alignment('center')
    balo_monthly_sheet.sheet_data[4][10].change_vertical_alignment('center')
    balo_monthly_sheet.sheet_data[4][10].change_font_bold(true)
    balo_monthly_sheet.add_cell(4, 11, "Ngày sinh")
    balo_monthly_sheet.sheet_data[4][11].change_fill('f48630')
    balo_monthly_sheet.sheet_data[4][11].change_horizontal_alignment('center')
    balo_monthly_sheet.sheet_data[4][11].change_vertical_alignment('center')
    balo_monthly_sheet.sheet_data[4][11].change_font_bold(true)
    balo_monthly_sheet.add_cell(4, 12, "Địa điểm nhận")
    balo_monthly_sheet.sheet_data[4][12].change_fill('f48630')
    balo_monthly_sheet.sheet_data[4][12].change_horizontal_alignment('center')
    balo_monthly_sheet.sheet_data[4][12].change_vertical_alignment('center')
    balo_monthly_sheet.sheet_data[4][12].change_font_bold(true)

    balo_monthly_sheet.change_column_width(2, 25)
    balo_monthly_sheet.change_column_width(5, 20)
    balo_monthly_sheet.change_column_width(9, 25)

    balo_orders = Order.balo.select{|o| o.sent_date.try(:month) == report_date.month }

    balo_orders.each.with_index do |order, index|
      balo_monthly_sheet.add_cell(5 + index, 1, index + 1)
      balo_monthly_sheet.add_cell(5 + index, 2, order.customer_name)
      balo_monthly_sheet.add_cell(5 + index, 3, order.product_code)
      balo_monthly_sheet.add_cell(5 + index, 4, order.ship_code)
      balo_monthly_sheet.add_cell(5 + index, 5, order.customer_phone)
      balo_monthly_sheet.add_cell(5 + index, 6, order.product_cost)
      balo_monthly_sheet.add_cell(5 + index, 7, order.ship_cost)
      balo_monthly_sheet.add_cell(5 + index, 8, order.sent_date.try(:strftime, '%d/%m'))
      balo_monthly_sheet.add_cell(5 + index, 9, order.colors_to_s)
      balo_monthly_sheet.add_cell(5 + index, 10, order.customer_email)
      balo_monthly_sheet.add_cell(5 + index, 11, order.customer_birthday.try(:strftime, '%d/%m'))
      balo_monthly_sheet.add_cell(5 + index, 12, order.customer_address)
    end

    (balo_orders.count + 8).times do |row|
      balo_monthly_sheet.change_row_height(row, 24)
      16.times do |col|
        balo_monthly_sheet.sheet_data[row][col].try(:change_border, :top, 'thin')
        balo_monthly_sheet.sheet_data[row][col].try(:change_border, :bottom, 'thin')
        balo_monthly_sheet.sheet_data[row][col].try(:change_border, :left, 'thin')
        balo_monthly_sheet.sheet_data[row][col].try(:change_border, :right, 'thin')
      end
    end

    # PurgeMonthlySheet
    (0..16).each do |col|
      purge_monthly_sheet.change_column_font_size(col, 12)
      purge_monthly_sheet.change_column_font_name(col, 'Times New Roman')
      purge_monthly_sheet.change_column_width(col, 15)
    end

    purge_monthly_sheet.add_cell(3, 1, "Thông tin khách hàng".upcase)
    purge_monthly_sheet.merge_cells(3, 1, 3, 12)
    purge_monthly_sheet.change_row_height(3, 24)
    purge_monthly_sheet.sheet_data[3][1].change_fill('f4a466')
    purge_monthly_sheet.sheet_data[3][1].change_horizontal_alignment('center')
    purge_monthly_sheet.sheet_data[3][1].change_vertical_alignment('center')

    purge_monthly_sheet.sheet_data[3][1].change_font_bold(true)
    purge_monthly_sheet.sheet_data[3][1].change_font_size(16)

    purge_monthly_sheet.add_cell(4, 1, "STT")
    purge_monthly_sheet.sheet_data[4][1].change_fill('f48630')
    purge_monthly_sheet.sheet_data[4][1].change_horizontal_alignment('center')
    purge_monthly_sheet.sheet_data[4][1].change_vertical_alignment('center')
    purge_monthly_sheet.sheet_data[4][1].change_font_bold(true)
    purge_monthly_sheet.add_cell(4, 2, "Khách Hàng")
    purge_monthly_sheet.sheet_data[4][2].change_fill('f48630')
    purge_monthly_sheet.sheet_data[4][2].change_horizontal_alignment('center')
    purge_monthly_sheet.sheet_data[4][2].change_vertical_alignment('center')
    purge_monthly_sheet.sheet_data[4][2].change_font_bold(true)
    purge_monthly_sheet.add_cell(4, 3, "Mã SP")
    purge_monthly_sheet.sheet_data[4][3].change_fill('f48630')
    purge_monthly_sheet.sheet_data[4][3].change_horizontal_alignment('center')
    purge_monthly_sheet.sheet_data[4][3].change_vertical_alignment('center')
    purge_monthly_sheet.sheet_data[4][3].change_font_bold(true)
    purge_monthly_sheet.add_cell(4, 4, "Mã code")
    purge_monthly_sheet.sheet_data[4][4].change_fill('f48630')
    purge_monthly_sheet.sheet_data[4][4].change_horizontal_alignment('center')
    purge_monthly_sheet.sheet_data[4][4].change_vertical_alignment('center')
    purge_monthly_sheet.sheet_data[4][4].change_font_bold(true)
    purge_monthly_sheet.add_cell(4, 5, "Số ĐT")
    purge_monthly_sheet.sheet_data[4][5].change_fill('f48630')
    purge_monthly_sheet.sheet_data[4][5].change_horizontal_alignment('center')
    purge_monthly_sheet.sheet_data[4][5].change_vertical_alignment('center')
    purge_monthly_sheet.sheet_data[4][5].change_font_bold(true)
    purge_monthly_sheet.add_cell(4, 6, "Tiền hàng")
    purge_monthly_sheet.sheet_data[4][6].change_fill('f48630')
    purge_monthly_sheet.sheet_data[4][6].change_horizontal_alignment('center')
    purge_monthly_sheet.sheet_data[4][6].change_vertical_alignment('center')
    purge_monthly_sheet.sheet_data[4][6].change_font_bold(true)
    purge_monthly_sheet.add_cell(4, 7, "Ship")
    purge_monthly_sheet.sheet_data[4][7].change_fill('f48630')
    purge_monthly_sheet.sheet_data[4][7].change_horizontal_alignment('center')
    purge_monthly_sheet.sheet_data[4][7].change_vertical_alignment('center')
    purge_monthly_sheet.sheet_data[4][7].change_font_bold(true)
    purge_monthly_sheet.add_cell(4, 8, "Ngày gửi")
    purge_monthly_sheet.sheet_data[4][8].change_fill('f48630')
    purge_monthly_sheet.sheet_data[4][8].change_horizontal_alignment('center')
    purge_monthly_sheet.sheet_data[4][8].change_vertical_alignment('center')
    purge_monthly_sheet.sheet_data[4][8].change_font_bold(true)
    purge_monthly_sheet.add_cell(4, 9, "Ghi chú")
    purge_monthly_sheet.sheet_data[4][9].change_fill('f48630')
    purge_monthly_sheet.sheet_data[4][9].change_horizontal_alignment('center')
    purge_monthly_sheet.sheet_data[4][9].change_vertical_alignment('center')
    purge_monthly_sheet.sheet_data[4][9].change_font_bold(true)
    # Add more
    purge_monthly_sheet.add_cell(4, 10, "Gmail")
    purge_monthly_sheet.sheet_data[4][10].change_fill('f48630')
    purge_monthly_sheet.sheet_data[4][10].change_horizontal_alignment('center')
    purge_monthly_sheet.sheet_data[4][10].change_vertical_alignment('center')
    purge_monthly_sheet.sheet_data[4][10].change_font_bold(true)
    purge_monthly_sheet.add_cell(4, 11, "Ngày sinh")
    purge_monthly_sheet.sheet_data[4][11].change_fill('f48630')
    purge_monthly_sheet.sheet_data[4][11].change_horizontal_alignment('center')
    purge_monthly_sheet.sheet_data[4][11].change_vertical_alignment('center')
    purge_monthly_sheet.sheet_data[4][11].change_font_bold(true)
    purge_monthly_sheet.add_cell(4, 12, "Địa điểm nhận")
    purge_monthly_sheet.sheet_data[4][12].change_fill('f48630')
    purge_monthly_sheet.sheet_data[4][12].change_horizontal_alignment('center')
    purge_monthly_sheet.sheet_data[4][12].change_vertical_alignment('center')
    purge_monthly_sheet.sheet_data[4][12].change_font_bold(true)

    purge_monthly_sheet.change_column_width(2, 25)
    purge_monthly_sheet.change_column_width(5, 20)
    purge_monthly_sheet.change_column_width(9, 25)

    purge_orders = Order.purge.select{|o| o.sent_date.try(:month) == report_date.month }

    purge_orders.each.with_index do |order, index|
      purge_monthly_sheet.add_cell(5 + index, 1, index + 1)
      purge_monthly_sheet.add_cell(5 + index, 2, order.customer_name)
      purge_monthly_sheet.add_cell(5 + index, 3, order.product_code)
      purge_monthly_sheet.add_cell(5 + index, 4, order.ship_code)
      purge_monthly_sheet.add_cell(5 + index, 5, order.customer_phone)
      purge_monthly_sheet.add_cell(5 + index, 6, order.product_cost)
      purge_monthly_sheet.add_cell(5 + index, 7, order.ship_cost)
      purge_monthly_sheet.add_cell(5 + index, 8, order.sent_date.try(:strftime, '%d/%m'))
      purge_monthly_sheet.add_cell(5 + index, 9, order.colors_to_s)
      purge_monthly_sheet.add_cell(5 + index, 10, order.customer_email)
      purge_monthly_sheet.add_cell(5 + index, 11, order.customer_birthday.try(:strftime, '%d/%m'))
      purge_monthly_sheet.add_cell(5 + index, 12, order.customer_address)
    end

    (purge_orders.count + 8).times do |row|
      purge_monthly_sheet.change_row_height(row, 24)
      16.times do |col|
        purge_monthly_sheet.sheet_data[row][col].try(:change_border, :top, 'thin')
        purge_monthly_sheet.sheet_data[row][col].try(:change_border, :bottom, 'thin')
        purge_monthly_sheet.sheet_data[row][col].try(:change_border, :left, 'thin')
        purge_monthly_sheet.sheet_data[row][col].try(:change_border, :right, 'thin')
      end
    end

    workbook.stream.string
  end
end
