class Avo::Resources::Item < Avo::BaseResource
  self.includes = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: params[:q], m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id
    field :team, as: :belongs_to
    field :name, as: :text
    field :description, as: :textarea
    field :location, as: :belongs_to
    field :active, as: :boolean
    field :overlap_offset, as: :number
    field :image_tag, as: :text
    field :clean, as: :boolean
    field :flip_time, as: :number
    field :beds, as: :number
  end
end
