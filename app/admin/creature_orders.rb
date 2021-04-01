ActiveAdmin.register CreatureOrder do
  permit_params :quantity, :purchase_price, :order_id, :creature_id
end
