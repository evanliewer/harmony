class Avo::Resources::Announcement < Avo::BaseResource
  self.includes = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: params[:q], m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id
    field :title, as: :text
    field :published_at, as: :date_time
    field :delivered_at, as: :date_time, readonly: true
    field :kind, as: :select, options: Announcement::TYPES.map { [_1.capitalize, _1] }.to_h
    field :delivery_methods, as: :tags, suggestions: BulletTrain::PowerPack.announcement_delivery_methods, enforce_suggestions: true
    field :role_ids, as: :tags, suggestions: -> { Role.all.pluck(:key) }, enforce_suggestions: true, name: "Roles"

    if billing_enabled?
      field :price_ids, as: :tags, suggestions: -> { Billing::Price.all.pluck(:id) }, enforce_suggestions: true, name: "Prices"
    end

    field :body, as: :trix, attachment_key: :trix_attachments
  end

  def actions
    action Avo::Actions::DeliverAnnouncement
  end
end
