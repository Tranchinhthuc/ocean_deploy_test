class Product < ApplicationRecord
  serialize :colors

  # belongs_to :category

  enum product_type: {
    balo: 0,
    student_balo: 1,
    purge: 2
  }

  has_many :order_colors, as: :target
  accepts_nested_attributes_for :order_colors, allow_destroy: true, reject_if: proc { |attributes| attributes['quantity'].blank? }

  validate :remain_must_be_less_than_import

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
    Product.product_types.to_a.map do |s|
      [Product.product_type_to_s(s[0].to_sym), s[0]]
    end
  end

  def colors_to_s
    result = []
    order_colors.group_by(&:color).each do |color, order_color|
      result << "#{order_color[0].quantity} #{color}"
    end
    result.join(', ')
  end

  def remain_must_be_less_than_import
    if order_colors.present? && order_colors.map(&:quantity).sum > bought_quantity
      errors.add(:bought_quantity, "Số hàng tồn phải ít hơn số nhập về.")
    end
  end
end
