class OrderColor < ApplicationRecord
  belongs_to :target, polymorphic: true, optional: true

  validates :quantity, numericality: { only_integer: true, greater_than: -1 }

  COLORS = ["Đen", "Đỏ", "Xanh", "Hồng"]
end
