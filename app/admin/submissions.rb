# frozen_string_literal: true

ActiveAdmin.register Submission do
  menu priority: 3
  permit_params :task_id, :user_id, :note, :status

  includes :task, :user

  index do
    selectable_column
    id_column
    column :task
    column :user
    column :status
    column :note
    column :created_at
    actions
  end

  show do
    attributes_table do
      row :id
      row :task
      row :user
      row :status
      row :note
      row :created_at
      row :updated_at
    end
  end

  form do |f|
    f.semantic_errors

    f.inputs 'Submission Details' do
      f.input :task, as: :select, collection: Task.all.map { |t| ["#{t.id} - #{t.title}", t.id] }
      f.input :user, as: :select, collection: User.all.map { |u| ["#{u.first_name} #{u.last_name} (#{u.email})", u.id] }
      f.input :status, as: :select, collection: Submission.statuses.keys
      f.input :note
    end

    f.actions
  end
end
