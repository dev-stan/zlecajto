class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :user_roles
  has_many :roles, through: :user_roles
  has_many :tasks
  has_many :submissions
  has_many :reviews, through: :tasks

  def has_role?(role_name)
    roles.exists?(name: role_name)
  end
end
