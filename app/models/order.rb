class Order < ApplicationRecord
  has_many :order_colors, as: :target

  enum product_type: {
    balo: 0,
    student_balo: 1,
    purge: 2
  }

  accepts_nested_attributes_for :order_colors, allow_destroy: true, reject_if: proc { |attributes| attributes['quantity'].blank? }

  def self.product_type_to_s(product_type)
    case product_type
    when :balo
      "Balo"
    when :student_balo
      "Balo học sinh"
    when :purge
      "Túi xách"
    end
  end

  def self.product_type_attribute_for_select
    Order.product_types.to_a.map do |s|
      [Order.product_type_to_s(s[0].to_sym), s[0]]
    end
  end

  def colors_to_s
    result = []
    order_colors.group_by(&:color).each do |color, order_color|
      result << "#{order_color[0].quantity} #{color}"
    end
    result.join(', ')
  end

  def update_product_info
    product = Product.find_by(code: product_code)
    if product
      # product.update(remain_quantity: product.remain_quantity - order_colors.map(&:quantity).try(:sum))
      product_order_colors = product.order_colors
      import_order_colors = order_colors
      order_colors.each do |order_color|
        pc = product_order_colors.find{|c| c.color.downcase == order_color.color.downcase}
        pc.update(quantity: pc.quantity - order_color.quantity) if pc
      end
    end
  end
end
