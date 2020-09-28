ActiveAdmin.register User do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :email, :encrypted_password, :reset_password_token, :reset_password_sent_at, :remember_created_at, :first_name, :last_name, :phone, :password, :password_confirmation, :avatar
  #
  # or
  #
  # permit_params do
  #   permitted = [:email, :encrypted_password, :reset_password_token, :reset_password_sent_at, :remember_created_at, :first_name, :last_name, :phone]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  index do
    selectable_column
    id_column
    column :email
    column :first_name
    column :last_name
    column :phone
    column :uid
    column :publishable_key
    actions
  end

  form title: 'New User' do |f|
    f.inputs "User" do
      f.input :first_name,
      required: true,
      autofocus: true,
      input_html: { autocomplete: "First Name" }
      f.input :last_name,
      required: true,
      autofocus: true,
      input_html: { autocomplete: "Last Name" }
      f.input :phone,
      required: true,
      autofocus: true,
      input_html: { autocomplete: "Phone Number" }
      f.input :email,
      required: true,
      autofocus: true,
      input_html: { autocomplete: "email" }
      f.input :password,
      required: true,
      hint: ("#{@minimum_password_length} characters minimum" if @minimum_password_length),
      input_html: { autocomplete: "new-password" } 
      f.input :password_confirmation,
      required: true,
      input_html: { autocomplete: "new-password" } 

      f.input :avatar, as: :file, label: "Avatar (optional)"
    end
    para "Press cancel to return to the list without saving."
    actions
  end
end
