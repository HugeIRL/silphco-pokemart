ActiveAdmin.register User do
  permit_params :first_name, :last_name, :address, :postal_code, :email, :encrypted_password,
                :province_id, :city_id
end
