class NotifyMailer < ApplicationMailer
  default from: 'evanl@foresthome.org'

  def retreat_change_email(user, notification)
    @user = User.find(user)
    @notification = notification
    mail(from: 'Camp Dashboard <support@campdashboard.org>', to: @user.email, subject: @notification.name)
  end

end
