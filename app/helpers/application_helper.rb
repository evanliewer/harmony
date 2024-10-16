module ApplicationHelper
  include Helpers::Base

  def current_theme
    :light
  end

   def location_icon_url(location)
        background_color = Colorizer.colorize_similarly(location.name.to_s, 0.5, 0.6).delete("#")
        "https://ui-avatars.com/api/?" + {
          color: "ffffff",
          #background: location.hexcolor,
          background: background_color,
          bold: true,
          name: location.initials,
          size: 200,
        }.to_param

  end 

  def user_icon_url(user)
        background_color = Colorizer.colorize_similarly(user.full_name.to_s, 0.5, 0.6).delete("#")
        "https://ui-avatars.com/api/?" + {
          color: "ffffff",
          #background: location.hexcolor,
          background: background_color,
          bold: true,
          name: user.first_name[0] + user.last_name[0],
          size: 200,
        }.to_param
  end 
  
end
