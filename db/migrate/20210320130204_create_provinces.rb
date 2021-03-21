class CreateProvinces < ActiveRecord::Migration[6.1]
  def change
    create_table :provinces do |t|
      t.string :name
      t.float :pst_rate
      t.float :gst_rate
      t.float :hst_rate

      t.timestamps
    end
  end
end
