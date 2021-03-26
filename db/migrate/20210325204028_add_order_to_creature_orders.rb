class AddOrderToCreatureOrders < ActiveRecord::Migration[6.1]
  def change
    add_reference :creature_orders, :order, null: false, foreign_key: true
  end
end
