class AddCreatureToCreatureOrders < ActiveRecord::Migration[6.1]
  def change
    add_reference :creature_orders, :creature, null: false, foreign_key: true
  end
end
