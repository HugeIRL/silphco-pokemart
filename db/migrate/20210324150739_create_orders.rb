class CreateOrders < ActiveRecord::Migration[6.1]
  def change
    create_table :orders do |t|
      t.float :pst_rate
      t.float :gst_rate
      t.float :hst_rate
      t.float :total_cost
      t.timestamps
    end
  end
end