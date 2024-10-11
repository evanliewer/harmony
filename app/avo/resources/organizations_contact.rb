class Avo::Resources::OrganizationsContact < Avo::BaseResource
  self.includes = []
  self.model_class = ::Organizations::Contact
  # self.search = {
  #   query: -> { query.ransack(id_eq: params[:q], m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id
    field :team, as: :belongs_to
    field :first_name, as: :text
    field :last_name, as: :text
    field :job_title, as: :text
    field :primary_phone, as: :text
    field :email, as: :text
  end
end
