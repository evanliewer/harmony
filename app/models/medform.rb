class Medform < ApplicationRecord
  # 🚅 add concerns above.

  # 🚅 add attribute accessors above.

  belongs_to :team
  belongs_to :retreat, optional: true
  belongs_to :diet, optional: true
  # 🚅 add belongs_to associations above.

  # 🚅 add has_many associations above.

  has_one :address, class_name: "Address", as: :addressable
  accepts_nested_attributes_for :address
  # 🚅 add has_one associations above.

  # 🚅 add scopes above.

  validates :name, presence: true
  validates :retreat, scope: true
  validates :terms, presence: true
  validates :phone, presence: true
  validates :email, presence: true
  validates :age, presence: true
  validates :gender, presence: true
  validates :emergency_contact_name, presence: true
  validates :emergency_contact_phone, presence: true
  validates :emergency_contact_relationship, presence: true
  validate :unique_entry_for_retreat
  # 🚅 add validations above.

  # 🚅 add callbacks above.

  # 🚅 add delegations above.

  def valid_retreats
    #team.retreats
    Retreat.all
  end

  def valid_diets
    #Not used as team is not passed to model
    team.diets
  end
 
  def unique_entry_for_retreat
    if Medform.where('LOWER(name) = ? AND phone = ? AND retreat_id = ?', name.downcase, phone, retreat_id).exists?
      errors.add(:name, 'has already been submitted and this is likely a duplicate entry.  If it is not, please resubmit with a different name or phone number')
    end
  end

  def self.diet_summary_for_retreat(retreat_id)
    # Group by diet_id and abbreviation, then count records
    diet_counts = Medform
                    .where(retreat_id: retreat_id)
                    .joins(:diet) # Assuming `Medform` belongs_to :diet
                    .group('diets.id', 'diets.abbreviation')
                    .pluck('diets.abbreviation, COUNT(medforms.id) as count')

    # Format the result into a string
    diet_counts.map { |abbreviation, count| "#{count} #{abbreviation.pluralize}" }.to_sentence
  end
 


  # 🚅 add methods above.
end
