class AddProvinceToCity < ActiveRecord::Migration[6.1]
  def change
    add_reference :cities, :province, null: false, foreign_key: true
  end
end
