class Avo::Actions::DeliverAnnouncement < Avo::BaseAction
  self.name = "Deliver Announcement"
  # self.visible = -> do
  #   true
  # end

  # def fields
  #   # Add Action fields here
  # end

  def handle(query:, fields:, current_user:, resource:, **args)
    query.each do |record|
      record.deliver
    end

    succeed "Announcements delivered using selected delivery methods"
  end
end
