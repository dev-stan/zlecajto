# frozen_string_literal: true

ActiveAdmin.register TaskMessage do
  menu priority: 7
  permit_params :task_id, :user_id, :parent_id, :body, :message_type

  includes :task, :user, :parent

  index do
    selectable_column
    id_column
    column :task
    column :user
    column :parent
    column :message_type
    column :body do |m|
      truncate(m.body, length: 120)
    end
    column :created_at
    actions
  end

  show do
    attributes_table do
      row :id
      row :task
      row :user
      row :parent
      row :message_type
      row :body
      row :created_at
      row :updated_at
    end
  end

  form do |f|
    f.semantic_errors
    f.inputs 'Task Message' do
      f.input :task, as: :select, collection: Task.all.map { |t| ["#{t.id} - #{t.title}", t.id] }
      f.input :user, as: :select, collection: User.all.map { |u| ["#{u.first_name} #{u.last_name} (#{u.email})", u.id] }
      f.input :parent, as: :select, collection: TaskMessage.all.map { |m|
        ["##{m.id} (#{m.message_type}) - #{m.body.truncate(40)}", m.id]
      }
      f.input :message_type, as: :select, collection: TaskMessage.message_types.keys
      f.input :body
    end
    f.actions
  end
end
