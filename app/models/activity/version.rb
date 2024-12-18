class Activity::Version < ActiveRecord::Base
  include PaperTrail::VersionConcern

  self.table_name = :activity_versions
  self.sequence_name = :activity_versions_id_seq

  belongs_to :team, class_name: "Team", optional: true
  belongs_to :action_text_rich_text, class_name: "ActionText::RichText", optional: true
  belongs_to :location, class_name: "Location", optional: true
  # 🚅 add belongs_to associations above.

  before_create do
    method = (item_type.underscore.tr("/", "_") + "=").to_sym

    # ActionText can add extra versions when there hasn't actually been a change, so we do this:
    if item.is_a? ActionText::RichText
      throw :abort if object_changes["body"]&.first == object_changes["body"]&.second
    end

    # e.g. `self.scaffolding_absolutely_abstract_creative_concept = item`
    begin
      send(method, item)
    rescue NoMethodError
      raise "Activity::Version does not respond to #{method}.  You should add #{item.class} as an association to the Activity::Version model."
    end

    # 🚅 Super Scaffolding will add new associations below
    self.team ||= location&.team

    if item.is_a? ActionText::RichText
      # The class of the Record that the rich text belongs to
      parent_association = item.record.class.to_s.underscore.tr("/", "_") + "="
      # Eg scaffolding_completely_concrete_tangible_thing = item.record
      send(parent_association, item.record) if respond_to? parent_association
    end

    # Action Text creates an additional update after creating an object
    # To avoid creating an additional Activity::Version, we check if there's any actual changes first
    # TODO - make sure changes to ActionText fields are creating versions correctly
    throw :abort if object_changes.nil?
  end

  # the column name scaffolding_absolutely_abstract_creative_concepts_collaborator is too long for postgres
  # so that our automatic assignment works, we alias these methods back to the full names
  def scaffolding_absolutely_abstract_creative_concepts_collaborator=(value)
    self.creative_concepts_collaborator = value
  end

  def scaffolding_absolutely_abstract_creative_concepts_collaborator
    creative_concepts_collaborator
  end
end
