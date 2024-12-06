class Avo::Resources::NotificationsArchiveAction < Avo::BaseResource
  # self.includes = []
  # self.attachments = []
  self.model_class = ::Notifications::ArchiveAction
  # self.search = {
  #   query: -> { query.ransack(id_eq: params[:q], m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id
    field :team, as: :belongs_to
    field :target_all, as: :boolean
    field :target_ids, as: :text
    field :failed_ids, as: :text
    field :last_completed_id, as: :number
    field :started_at, as: :date_time
    field :completed_at, as: :date_time
    field :target_count, as: :number
    field :performed_count, as: :number
    field :scheduled_for, as: :date_time
    field :sidekiq_jid, as: :text
    field :created_by, as: :belongs_to
    field :approved_by, as: :belongs_to
  end
end
