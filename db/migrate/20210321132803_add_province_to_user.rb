class AddProvinceToUser < ActiveRecord::Migration[6.1]
  def change
    add_reference :users, :province, null: false, foreign_key: true
  end
end
