# frozen_string_literal: true

class MessageSerializer < ActiveModel::Serializer
  attributes :id, :content, :user_id, :created_at

  belongs_to :user
end
