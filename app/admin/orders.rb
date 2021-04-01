ActiveAdmin.register Order do
  permit_params :pst_rate, :gst_rate, :hst_rate, :total_taxes, :total_cost, :payment_status,
                :payment_intent, :user_id
end
