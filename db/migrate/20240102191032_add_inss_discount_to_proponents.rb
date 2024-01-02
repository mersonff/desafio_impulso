class AddInssDiscountToProponents < ActiveRecord::Migration[7.1]
  def change
    add_column(:proponents, :inss_discount, :decimal, precision: 14, scale: 2, default: 0.0)
  end
end
