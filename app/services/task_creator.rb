# frozen_string_literal: true

class TaskCreator
  def initialize(user:, params:)
    @user = user
    @params = params
  end

  def call
    @task = @user.tasks.build(task_params_without_photos)
    attach_photos if photo_blob_ids.present?
    @task.save
    @task
  end

  private

  attr_reader :user, :params

  def task_params_without_photos
    @params.except(:photo_blob_ids, :due_date_any)
  end

  def photo_blob_ids
    @params[:photo_blob_ids]
  end

  def attach_photos
    @task.photos.attach(photo_blob_ids.map { |signed_id| { signed_id: signed_id } })
  end
end
