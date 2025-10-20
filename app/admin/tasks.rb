# frozen_string_literal: true

ActiveAdmin.register Task do
  menu priority: 2
  permit_params :title, :description, :salary, :status, :user_id, :category,
                :due_date, :location, :payment_method, :timeslot, { photos: [] }

  includes :user

  index do
    selectable_column
    id_column
    column :title
    column :status
    column :user
    column :category
    column :location
    column :due_date
    column :created_at
    actions
  end

  filter :title
  filter :status, as: :select, collection: -> { Task.statuses.keys }
  filter :user
  filter :category, as: :select, collection: -> { Task::CATEGORIES }
  filter :location, as: :select, collection: -> { Task::LOCATIONS }
  filter :payment_method, as: :select, collection: -> { Task::PAYMENT_METHODS }
  filter :timeslot, as: :select, collection: -> { Task::TIMESLOTS }
  filter :due_date
  filter :created_at

  show do
    attributes_table do
      row :id
      row :user
      row :title
      row :description
      row :salary
      row :status
      row :category
      row :timeslot
      row :location
      row :payment_method
      row :due_date
      row :created_at
      row :updated_at
    end

    if resource.photos.attached?
      panel 'Photos' do
        div do
          resource.photos.each do |photo|
            span do
              image_tag url_for(photo), style: 'max-width: 200px; max-height: 200px; margin: 5px;'
            end
          end
        end
      end
    end
  end

  form do |f|
    f.semantic_errors

    f.inputs 'Task Details' do
      f.input :user, as: :select, collection: User.all.map { |u| ["#{u.first_name} #{u.last_name} (#{u.email})", u.id] }
      f.input :title
      f.input :description
      f.input :salary
      f.input :status, as: :select, collection: Task.statuses.keys
      f.input :category, as: :select, collection: Task::CATEGORIES
      f.input :timeslot, as: :select, collection: Task::TIMESLOTS
      f.input :location, as: :select, collection: Task::LOCATIONS
      f.input :payment_method, as: :select, collection: Task::PAYMENT_METHODS
      f.input :due_date, as: :datetime_select
      f.input :photos, as: :file, input_html: { multiple: true }
    end

    f.actions
  end
end
