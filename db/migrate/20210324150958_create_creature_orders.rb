class CreateCreatureOrders < ActiveRecord::Migration[6.1]
  def change
    create_table :creature_orders do |t|
      t.integer :quantity

      t.timestamps
    end
  end
end
