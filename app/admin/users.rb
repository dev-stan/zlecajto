# frozen_string_literal: true

ActiveAdmin.register User do
  menu priority: 4
  permit_params :email, :password, :password_confirmation, :first_name, :last_name,
                :address, :verified, :phone_number, :role, :category, :admin,
                :provider, :uid, { superpowers: [] }, :profile_picture

  includes :tasks, :submissions

  index do
    selectable_column
    id_column
    column :first_name
    column :last_name
    column :email
    column :phone_number
    column :verified
    column :admin
    column :role
    column :category
    column :sign_in_count
    column :created_at
    actions
  end

  filter :first_name
  filter :last_name
  filter :email
  filter :phone_number
  filter :verified
  filter :admin
  filter :role
  filter :category
  filter :created_at

  show do
    attributes_table do
      row :id
      row :first_name
      row :last_name
      row :email
      row :phone_number
      row :address
      row :verified
      row :admin
      row :role
      row :category
      row :provider
      row :uid
      row :superpowers do |u|
        u.superpowers&.join(', ')
      end
      row :created_at
      row :updated_at
      row :profile_picture do |u|
        if u.profile_picture.attached?
          image_tag url_for(u.profile_picture), style: 'max-width: 150px; height: auto;'
        else
          status_tag 'none'
        end
      end
    end
  end

  form do |f|
    f.semantic_errors
    f.inputs 'User' do
      f.input :first_name
      f.input :last_name
      f.input :email
      f.input :password
      f.input :password_confirmation
      f.input :phone_number
      f.input :address
      f.input :verified
      f.input :admin
      f.input :role
      f.input :category
      f.input :provider
      f.input :uid
      f.input :superpowers, as: :string, input_html: { value: f.object.superpowers.join(', ') }
      f.input :profile_picture, as: :file,
                                hint: (image_tag url_for(f.object.profile_picture), style: 'max-width: 100px;' if f.object.profile_picture.attached?)
    end
    f.actions
  end
end
