class AddTypeToCreatures < ActiveRecord::Migration[6.1]
  def change
    add_reference :creatures, :type, null: false, foreign_key: true
  end
end
