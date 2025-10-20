# frozen_string_literal: true

ActiveAdmin.register_page 'Dashboard' do
  menu priority: 1, label: proc { I18n.t('active_admin.dashboard') }

  content title: proc { I18n.t('active_admin.dashboard') } do
    columns do
      column do
        panel 'Users' do
          para "Total users: #{User.count}"
          para "Verified users: #{User.where(verified: true).count}"
          para do
            link_to 'Manage Users', backstage_users_path
          end
        end

        panel 'Recent Users' do
          table_for User.order(created_at: :desc).limit(10) do
            column(:id) { |u| link_to u.id, backstage_user_path(u) }
            column :first_name
            column :last_name
            column :email
            column :created_at
          end
        end
      end

      column do
        panel 'Tasks' do
          para "Total tasks: #{Task.count}"
          para "Open tasks: #{Task.where(status: 'Otwarte').count}"
          para do
            link_to 'Manage Tasks', backstage_tasks_path
          end
        end

        panel 'Recent Tasks' do
          table_for Task.order(created_at: :desc).limit(10) do
            column(:id) { |t| link_to t.id, backstage_task_path(t) }
            column :title
            column :status
            column :user
            column :created_at
          end
        end
      end
    end

    columns do
      column do
        panel 'Recent Submissions' do
          table_for Submission.order(created_at: :desc).limit(10) do
            column(:id) { |s| link_to s.id, backstage_submission_path(s) }
            column :task
            column :user
            column :status
            column :created_at
          end
        end
      end

      column do
        panel 'Recent Task Messages' do
          table_for TaskMessage.order(created_at: :desc).limit(10) do
            column(:id) { |m| link_to m.id, backstage_task_message_path(m) }
            column :task
            column :user
            column(:body) { |m| truncate(m.body, length: 50) }
            column :message_type
            column :created_at
          end
        end
      end
    end
  end
end
