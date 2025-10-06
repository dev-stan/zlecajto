class Answer < ApplicationRecord
  belongs_to :user
  belongs_to :submission

  validates :message, presence: true, length: { maximum: 1000 }
end
