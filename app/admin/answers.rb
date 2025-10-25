# frozen_string_literal: true

ActiveAdmin.register Answer do
  menu priority: 5
  permit_params :message, :user_id, :submission_id

  includes :user, :submission

  index do
    selectable_column
    id_column
    column :submission
    column :user
    column :message do |a|
      truncate(a.message, length: 120)
    end
    column :created_at
    actions
  end

  show do
    attributes_table do
      row :id
      row :submission
      row :user
      row :message
      row :created_at
      row :updated_at
    end
  end

  form do |f|
    f.semantic_errors
    f.inputs 'Answer' do
      f.input :submission
      f.input :user, as: :select, collection: User.all.map { |u| ["#{u.first_name} #{u.last_name} (#{u.email})", u.id] }
      f.input :message
    end
    f.actions
  end
end
