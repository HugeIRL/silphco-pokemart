ActiveAdmin.register Creature do
  permit_params :pokedex_id, :species, :description, :price_cents, :type_id
end
