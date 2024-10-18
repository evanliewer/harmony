class Department < ApplicationRecord
  include Sortable
  # 🚅 add concerns above.

  # 🚅 add attribute accessors above.

  belongs_to :team
  # 🚅 add belongs_to associations above.

  has_many :applied_tags, class_name: "Departments::AppliedTag", dependent: :destroy
  has_many :tags, through: :applied_tags, class_name: "Items::Tag"
  # 🚅 add has_many associations above.

  # 🚅 add has_one associations above.

  # 🚅 add scopes above.

  validates :name, presence: true
  # 🚅 add validations above.

  # 🚅 add callbacks above.

  # 🚅 add delegations above.

  def collection
    team.departments
  end

  def valid_tags
    team.items_tags.order(:name)
  end

  # 🚅 add methods above.
end
