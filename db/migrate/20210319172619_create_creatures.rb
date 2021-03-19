class CreateCreatures < ActiveRecord::Migration[6.1]
  def change
    create_table :creatures do |t|
      t.integer :pokedex_id
      t.string :species
      t.string :description
      t.integer :price_cents

      t.timestamps
    end
  end
end
