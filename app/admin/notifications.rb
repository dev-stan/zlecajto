# frozen_string_literal: true

ActiveAdmin.register Notification do
  menu priority: 6
  permit_params :user_id, :subject, :read_at, :notifiable_type, :notifiable_id

  includes :user

  index do
    selectable_column
    id_column
    column :user
    column :subject
    column :notifiable_type
    column :notifiable_id
    column :read_at
    column :created_at
    actions
  end

  show do
    attributes_table do
      row :id
      row :user
      row :subject
      row :notifiable_type
      row :notifiable_id
      row :read_at
      row :created_at
      row :updated_at
    end
  end

  form do |f|
    f.semantic_errors
    f.inputs 'Notification' do
      f.input :user, as: :select, collection: User.all.map { |u| ["#{u.first_name} #{u.last_name} (#{u.email})", u.id] }
      f.input :subject
      f.input :notifiable_type, as: :select, collection: %w[Task Submission]
      f.input :notifiable_id
      f.input :read_at, as: :datetime_select, include_blank: true
    end
    f.actions
  end
end
