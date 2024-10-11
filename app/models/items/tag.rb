class Items::Tag < ApplicationRecord
  # 🚅 add concerns above.

  # 🚅 add attribute accessors above.

  belongs_to :team
  # 🚅 add belongs_to associations above.

  has_many :applied_tags, class_name: "Items::AppliedTag", dependent: :destroy, foreign_key: :tag_id, inverse_of: :tag
  has_many :items, through: :applied_tags
  has_many :departments_applied_tags, class_name: "Departments::AppliedTag", dependent: :destroy, foreign_key: :items_tag_id, inverse_of: :items_tag
  has_many :departments, through: :departments_applied_tags
  # 🚅 add has_many associations above.

  # 🚅 add has_one associations above.

  # 🚅 add scopes above.

  validates :name, presence: true
  # 🚅 add validations above.

  # 🚅 add callbacks above.

  # 🚅 add delegations above.

  # 🚅 add methods above.
end
