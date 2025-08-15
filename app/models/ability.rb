# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    return unless user

    if user.has_role?('poster')
      can :create, Task
      can :read, Application, task: { user_id: user.id }
      can :manage, Task, user_id: user.id
    end

    if user.has_role?('worker')
      can :read, Task, status: 'open'
      can :create, Application
      can :manage, Application, user_id: user.id
    end

    return unless user.has_role?('admin')

    can :manage, :all
  end
end
