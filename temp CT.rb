module Circuitree


  class ApiDownload


    def self.attendee_info(event_id)
      puts "YO DAQG"
puts "CTquery method from CT library module5"
puts "Event: " + event_id.to_s
    
     @Url = "https://api.circuitree.com/Exports/ExecuteQuery.json"
     @ApiToken = "C-rfuf3c/DjFYjAAEkPVqRAdxrxFBvFOmNRicxLQDBoZPUgZ6XJokrsEuW1knO0M9xRmacxonJ//nBffDCe4HiIQTomnKu1vBO"

     puts "CT Query is: 422"
     puts "MOre threr"
     @team = Team.first #if ever more than 1 team would need to a Team.all.each do |team|
     paramArray = []
      param = {
          'ParameterID' => 7,
          'ParameterValue' => Date.today.year
            }
      paramArray << param 
     param = {
          'ParameterID' => 90,
          'ParameterValue' => event_id
            }
      paramArray << param 
      puts "2"
      data = {
        'ApiToken' => @ApiToken,
        'ExportQueryID' => 422,
        'QueryParameters' => paramArray
      }
 puts "3"
      uri = URI(@Url)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      req = Net::HTTP::Post.new(uri.path, 'Content-Type' => 'application/json')
      req.body = data.to_json
      res = http.request(req)
      @ct_results_attendee = JSON.parse(res.body)
        #puts @ct_results

puts "4"
    puts "Begin Attendee Download"
    puts "5555555555555555555555"
     @ct_results_attendee.each do |key,value|
      if key == "Results"
        JSON.parse(value).each do |val|
       
         
          puts val['LastName'].to_s
          puts "sdsd"

  
        end
      end
    end
    puts "Completed Attendee Info Download"
    return @ct_results_attendee
  end



  def self.resource_download
  Team.all.each do |team|  
    if team.id != 2
    puts "CTquery method from CT library module"
     @Url = "https://api.circuitree.com/Exports/ExecuteQuery.json"
     @ApiToken = "C-rfuf3c/DjFYjAAEkPVqRAdxrxFBvFOmNRicxLQDBoZPUgZ6XJokrsEuW1knO0M9xRmacxonJ//nBffDCe4HiIQTomnKu1vBO"

     puts "CT Query is: 377"
     @team = Team.find(team.id)
     paramArray = []


    if team.id == 3
      @query = 501
    else
      @query = 377
    end  
      puts "CT Query is: " + @query.to_s
      data = {
        'ApiToken' => @ApiToken,
        'ExportQueryID' => @query,
        'QueryParameters' => paramArray
      }



      uri = URI(@Url)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      req = Net::HTTP::Post.new(uri.path, 'Content-Type' => 'application/json')
      req.body = data.to_json
      res = http.request(req)
      @ct_results = JSON.parse(res.body)
        #puts @ct_results


    puts "Begin Resource Download"
     @ct_results.each do |key,value|
      if key == "Results"
        JSON.parse(value).each do |val|
         begin 
          resource = Resource.find_or_create_by(:id => val['ResourceID'].to_s)
            resource.id = val['ResourceID'].to_s
            resource.name = val['Name'].to_s
            resource.team_id = team.id
            resource.description = val['Description'].to_s
            if resource.active != false
              if val['Active'].to_i == 1
                resource.active ||= true
              #else
               # resource.active = false
              end 
            end
          resource.save
          puts resource.name

         
          #Creating tags for division
          resource_tag = Resources::Tag.find_or_create_by(team_id: 1, name: val['Division'])
          resource_tag.save
          applied_tag = Resources::AppliedTag.find_or_create_by(tag_id: resource_tag.id, resource_id: resource.id)
          applied_tag.save
          #Creating tags for Category
          resource_tag = Resources::Tag.find_or_create_by(team_id: 1, name: val['Category'])
          resource_tag.save
          applied_tag = Resources::AppliedTag.find_or_create_by(tag_id: resource_tag.id, resource_id: resource.id)
          applied_tag.save

        rescue => ex 
          puts "Error Saving Resource: " + ex.message.to_s
        end

        end
      end
    end
    puts "Completed Resource Download"

  end

 end
end




  def self.program_events
     puts "Begin CT Program Download"
         start_date = Date.today
         end_date = Date.today + 100.days

         puts "CTquery method from CT library module"
         @Url = "https://api.circuitree.com/Exports/ExecuteQuery.json"
       
         paramArray = []

         param = {
          'ParameterID' => 8,
          'ParameterValue' => start_date
            }
         paramArray << param   

         param = {
          'ParameterID' => 9,
          'ParameterValue' => end_date
            } 
         paramArray << param     
         current_team = Team.first
         data = {
            'ApiToken' => current_team.ct_api,
            'ExportQueryID' =>  486,
            'QueryParameters' => paramArray
          }

          uri = URI(@Url)
          http = Net::HTTP.new(uri.host, uri.port)
          http.use_ssl = true
          req = Net::HTTP::Post.new(uri.path, 'Content-Type' => 'application/json')
          req.body = data.to_json
          res = http.request(req)
          @ct_results = JSON.parse(res.body)

          puts "Starting Program Download"
          begin
             @ct_results.each do |key,value|
              if key == "Results"
                JSON.parse(value).each do |val|
                  puts "----------Program---------- " + val['EventName'] + " ------------Program-----------"
                  begin
                   puts "start itinerary search and save"
                   retreat = Retreat.find_or_initialize_by(:team_id => current_team.id, :import_identifier => val['EventID'].to_i)
                   #unless retreat.import_lock == true
                  
                   unless 1 == 2 
                      puts "RETREAT: " + retreat.name.to_s
                      retreat.name = val['EventName'].to_s
                      puts "RETREAT: " + retreat.name
                      retreat.arrival = DateTime.parse(val['ArrivalDateTime'])
                      retreat.departure = DateTime.parse(val['DepartureDateTime'])
                      puts "Circuitree Arrival: " + val['ArrivalDateTime'].to_datetime.to_s
                      puts "Retreat Arrival: " + retreat.arrival.to_s
                      puts "Circuitree Departure: " + val['DepartureDateTime'].to_datetime.to_s
                      puts "Retreat Departure: " + retreat.departure.to_s
                   
                     retreat.guest_count = val['GuestCount'].to_i
                     retreat.import_lock = true
                     retreat.import_identifier = val['EventID']
                     retreat.status = "Approved"
                     retreat.save 
                     

                     puts "Arrival: " + retreat.arrival.strftime("%A %B #{retreat.arrival.day.ordinalize} %-l%P")
                     puts "Departure: " + retreat.departure.strftime("%A %B #{retreat.departure.day.ordinalize}  %-l%P")
                     puts "Guest Count: " + retreat.guest_count.to_s
                     puts "Event ID:" + retreat.import_identifier.to_s
                

                     

                     ##Save Location
                      location = Location.find_or_create_by(:team_id => current_team.id, :name => val['Location'].to_s) do |l|
                        l.initials = val['Location'].to_s[0, 2].upcase
                        l.save
                      end
                    
                      retreat_location = Retreats::LocationTag.find_or_create_by(retreat_id: retreat.id, location_id: location.id)
                      retreat_location.save!
                      puts "Location: " + retreat_location.location.name

                    ##Save Demographic

                

                    if val['EventType'].present?
                        demographic = Demographic.find_or_create_by!(:team_id => current_team.id, :name => val['EventType'].to_s) do |d|
                          d.save 
                        end 

                        puts "Demographic: " + demographic.name

                        retreat_demographic = Retreats::DemographicTag.find_or_create_by(retreat_id: retreat.id, demographic_id: demographic.id)
                        retreat_demographic.save


                      


                    end
                    end
                    #Download Retreat Reservations
                    #res = Reservations_download(retreat.import_identifier)
                   puts "Successful Program Download" 
                   
                  rescue => ex
                    puts "Not a successful Program Download"
                    puts ex.message
                  end   
                end   ##JSON.parse 
              end  ##if Key
            end ## ct_results  
          rescue => ex
            puts ex.message
          end 
        puts "Completed Program Download"
      

        puts "Success"


  end  





    def self.circuitree_download(team = nil, itinerary = nil)
      require 'digest/md5'

      puts "Begin CT Download"
         start_date = Date.today
         end_date = Date.today + 365.days
         current_team = Team.find(team)

         puts "CTquery method from CT library module"
         @Url = "https://api.circuitree.com/Exports/ExecuteQuery.json"
       
         paramArray = []



         param = {
          'ParameterID' => 8,
          'ParameterValue' => start_date
            }
         paramArray << param   

         param = {
          'ParameterID' => 9,
          'ParameterValue' => end_date
            } 
         paramArray << param  


         if itinerary.present?
          puts "ItineraryID was present: " + itinerary.to_s
            param = {
          'ParameterID' => 26,
          'ParameterValue' => itinerary
            } 
         paramArray << param 

         end   
         
         data = {
            'ApiToken' => current_team.ct_api,
            'ExportQueryID' =>  current_team.ct_query,
            'QueryParameters' => paramArray
          }

          uri = URI(@Url)
          http = Net::HTTP.new(uri.host, uri.port)
          http.use_ssl = true
          req = Net::HTTP::Post.new(uri.path, 'Content-Type' => 'application/json')
          req.body = data.to_json
          res = http.request(req)
          @ct_results = JSON.parse(res.body)

          puts "Starting Itinerary Download"
          begin
             @ct_results.each do |key,value|
              if key == "Results"
                JSON.parse(value).each do |val|
                  puts "-------------------- " + val['GroupName'] + " ---------------------------"
                  begin
                   puts "start itinerary search and save"
                   retreat = Retreat.find_or_initialize_by(:team_id => current_team.id, :id => val['ItineraryID'].to_i)
                   #unless retreat.import_lock == true
                   unless 1 == 2 
                     retreat.name = val['GroupName'].to_s
                     
                     if Rails.env.production?
                     # puts "Production"
                     # retreat.arrival = val['ArrivalDateTime'].to_datetime
                     # retreat.departure = val['DepartureDateTime'].to_datetime
                      retreat.arrival = DateTime.parse(val['ArrivalDateTime'])
                      retreat.departure = DateTime.parse(val['DepartureDateTime'])
                     # puts "Circuitree Arrival: " + val['ArrivalDateTime'].to_datetime.to_s
                     # puts "Retreat Arrival: " + retreat.arrival.to_s
                     # puts "Circuitree Departure: " + val['DepartureDateTime'].to_datetime.to_s
                     # puts "Retreat Departure: " + retreat.departure.to_s
                     else 
                      puts "Development"
                      arrivalDateTime = val['ArrivalDateTime'].to_datetime
                      departureDateTime = val['DepartureDateTime'].to_datetime
                      arrival = Time.now.in_time_zone("Pacific Time (US & Canada)")
                      departure = Time.now.in_time_zone("Pacific Time (US & Canada)")
                      retreat.arrival = arrival.change(:year => arrivalDateTime.year, :month => arrivalDateTime.month, :day => arrivalDateTime.day, :hour => arrivalDateTime.hour, :min => arrivalDateTime.min)
                      retreat.departure = departure.change(:year => departureDateTime.year, :month => departureDateTime.month, :day => departureDateTime.day, :hour => departureDateTime.hour, :min => departureDateTime.min)
                      #puts "Circuitree Arrival: " + val['ArrivalDateTime'].to_datetime.to_s
                      #puts "Retreat Arrival: " + retreat.arrival.to_s
                      #puts "Circuitree Departure: " + val['DepartureDateTime'].to_datetime.to_s
                      #puts "Retreat Departure: " + retreat.arrival.to_s
                     end 
                     
                     retreat.guest_count = val['ProgramCount'].to_i
                     retreat.import_identifier = val['ItineraryID']
                     retreat.id = val['ItineraryID'].to_i
                     retreat.import_lock = true
                     retreat.status = val['ItineraryStatus']
                      ##ADD Save Contact
                      ##Add Save event planner
                      ##ADD housing
                      ##Add Meeting Spaces

                     ##Save Organization 
                     organization = Organization.find_or_create_by(:team_id => current_team.id, :name => val['GroupName'].to_s)       
                      organization.name = val['GroupName'].to_s
                     organization.save
                    
                     retreat.organization_id = organization.id 

                     retreat.save(validate: false) 
                    # retreat.versions.last.update_attributes!(:whodunnit => 1) ##Havent tested

                     puts "Arrival: " + retreat.arrival.strftime("%A %B #{retreat.arrival.day.ordinalize} %-l%P")
                     puts "Departure: " + retreat.departure.strftime("%A %B #{retreat.departure.day.ordinalize}  %-l%P")
                     puts "Guest Count: " + retreat.guest_count.to_s
                     puts "CT Intinerary: " + retreat.import_identifier.to_s
                     puts "ItineraryStatus: " + retreat.status.to_s
                

                     ##Save Contact
                     contact = Organizations::Contact.find_or_create_by(:organization_id => organization.id, :first_name => val['PrimaryContact'].to_s.split.first, :last_name => val['PrimaryContact'].to_s.split[1..-1].join(' '))
                     contact.save
                     
                     puts "Organization: " + organization.name
                     puts "Organization Contact: " + contact.first_name.to_s + " " + contact.last_name.to_s

                     retreat_contact = Retreats::AssignedContact.find_or_create_by(retreat_id: retreat.id, contact_id: contact.id)
                     retreat_contact.save

                     ##Save Host
                     puts "Checking User for Host"
                     if val['FHHost'].present?
                       puts "Creating: " + val['FHHost']
                       first = val['FHHost'].to_s.split.first
                       last = val['FHHost'].to_s.split[1..-1].join(' ')
                       user = User.find_or_create_by!(first_name: first, last_name: last) do |u|
                          puts "First Name: " + u.first_name.to_s
                          u.email = first + "." + last + "@foresthome.org"
                          u.password = "fsdfsdjkfdf874r8fh747hffk8l7l"
                          u.time_zone = "Pacific Time (US & Canada)"
                          u.save!
                        end  
   
                      puts "Checking Membership for Host"
                        membership = Membership.find_or_create_by(team_id: current_team.id, user_id: user.id, user_first_name: first, user_last_name: last) do |m|
                          puts "Creating Membership"
                          m.user_email = first + "." + last + "@foresthome.org"
                          m.user_first_name = first
                          m.user_last_name = last 
                          m.save!
                        end
            
                        retreat_host = Retreats::HostTag.find_or_create_by!(retreat_id: retreat.id, host_id: membership.id)
                        retreat_host.save 
                     end

                      ##Save Event Planner
                     puts "Checking User for Planner"
                     if val['FHEventCoordinator'].present?
                       puts "Creating: " + val['FHEventCoordinator']
                       first = val['FHEventCoordinator'].to_s.split.first
                       last = val['FHEventCoordinator'].to_s.split[1..-1].join(' ')
                       user = User.find_or_create_by!(first_name: first, last_name: last) do |u|
                          puts "First Name: " + u.first_name.to_s
                          u.email = first + "." + last + "@foresthome.org"
                          u.password = "fsdfsdjkfdf874r8fh747hffk8l7l"
                          u.time_zone = "Pacific Time (US & Canada)"
                          u.save!
                        end  
   
                      puts "Checking Membership for Planner"
                        membership = Membership.find_or_create_by(team_id: current_team.id, user_id: user.id, user_first_name: first, user_last_name: last) do |m|
                          puts "Creating Membership"
                          m.user_email = first + "." + last + "@foresthome.org"
                          m.user_first_name = first
                          m.user_last_name = last 
                          m.save!
                        end
            
                        retreat_planner = Retreats::PlannerTag.find_or_create_by!(retreat_id: retreat.id, planner_id: membership.id)
                        retreat_planner.save 
                     end


                   

                     

                     ##Save Location
                      location = Location.find_or_create_by(:team_id => current_team.id, :name => val['Location'].to_s) do |l|
                        l.initials = val['Location'].to_s[0, 2].upcase
                        l.save
                      end

                      retreat_location = Retreats::LocationTag.find_or_create_by(retreat_id: retreat.id, location_id: location.id)
                      retreat_location.save!
                      puts "Location: " + retreat_location.location.name

                    ##Save Demographic

                    if val['Internal'] == "TRUE"
                      puts "INTERNAL"
                      internal = Demographic.find_or_create_by!(:team_id => current_team.id, :name => "Internal") do |d|
                          d.save 
                      end    
                      retreat_demographic = Retreats::DemographicTag.find_or_create_by(retreat_id: retreat.id, demographic_id: internal.id)
                      retreat_demographic.save
                    end

                    if val['GroupType'].present?
                        demographic = Demographic.find_or_create_by!(:team_id => current_team.id, :name => val['GroupType'].to_s) do |d|
                          d.save 
                        end 

                        puts "Demographic: " + demographic.name

                        retreat_demographic = Retreats::DemographicTag.find_or_create_by(retreat_id: retreat.id, demographic_id: demographic.id)
                        retreat_demographic.save


                        exclusive = Demographic.find_or_create_by!(:team_id => current_team.id, :name => val['UseBasis'].to_s) do |e|
                          e.save 
                        end 

                        puts "Exclusive: " + exclusive.name

                        retreat_demographic = Retreats::DemographicTag.find_or_create_by(retreat_id: retreat.id, demographic_id: exclusive.id)
                        retreat_demographic.save


                    end
                    end
                    #Download Retreat Reservations
                    res = Reservations_download(retreat.import_identifier)
                   puts "Successful Itinerary Download" 
                   
                  rescue => ex
                    puts "Not a successful Itinerary Download"
                    puts ex.message
                  end   
                end   ##JSON.parse 
              end  ##if Key
            end ## ct_results  
          rescue => ex
            puts ex.message
          end 
        puts "Completed Itinerary Download"
      

        puts "Success"
    end  


    def self.Reservations_download(itinerary)
        current_team = Team.first
      begin
      
        puts "CTquery method from CT library module"
        @Url = "https://api.circuitree.com/Exports/ExecuteQuery.json"
        @ApiToken = "C-rfuf3c/DjFYjAAEkPVqRAdxrxFBvFOmNRicxLQDBoZPUgZ6XJokrsEuW1knO0M9xRmacxonJ//nBffDCe4HiIQTomnKu1vBO"

       #puts "CT Query is: 484"

     @team = Team.first 
   
     paramArray = []
     

     
       param = {
      'ParameterID' => 26,
      'ParameterValue' => itinerary
        }
        paramArray << param
       

      data = {
        'ApiToken' => @ApiToken,
        'ExportQueryID' => 484,
        'QueryParameters' => paramArray
      }

      uri = URI(@Url)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      req = Net::HTTP::Post.new(uri.path, 'Content-Type' => 'application/json')
      req.body = data.to_json
      res = http.request(req)
      @ct_results2 = JSON.parse(res.body)

    
      rescue => ex
        puts ex.message
        puts "--------------- ERROR --------- ERROR ----------------  ERROR ---------------"
        
    end
     
      begin
       @ct_results2.each do |key,value|
        if key == "Results"
          JSON.parse(value).each do |val|
        #  begin
        #    entity = Entity.where(name: val['ItineraryEntity']).first
        #    location = Location.where(name: val['Locations']).first
        #  rescue => ex
        #    puts ex.message
        #  end   

            reservation_count = Reservation.where(id: val['ReservationItemID'].to_i).count
            if reservation_count == 0
              begin
                puts "************************************************"
                puts "Reservation Info"
                #puts val
                puts "Name: " + val['Name'].to_s
                puts "ReservationID: " + val['ReservationItemID'].to_s
                puts "ResourceID: " + val['ResourceID'].to_s
                puts "ItineraryID: " + val['ItineraryID'].to_s
                puts "Name: " + val['Name'].to_s
                puts "ReservationStatus: " + val['ReservationStatusName'].to_s
                puts "************************************************"

                reservation = Reservation.find_or_create_by(:team_id => 1, :retreat_id => val['ItineraryID'].to_s, :resource_id => val['ResourceID'].to_s)
                 PaperTrail.request.whodunnit = 'Circuitree'
                 arrivalDateTime = val['StartDateTime'].to_datetime
                 departureDateTime = val['EndDateTime'].to_datetime
                 start_time = Time.now
                 end_time = Time.now 
                 reservation.start_time = start_time.change(:year => arrivalDateTime.year, :month => arrivalDateTime.month, :day => arrivalDateTime.day, :hour => arrivalDateTime.hour, :min => arrivalDateTime.min)
                 reservation.end_time = end_time.change(:year => departureDateTime.year, :month => departureDateTime.month, :day => departureDateTime.day, :hour => departureDateTime.hour, :min => departureDateTime.min)
                 reservation.name = val['Name'].to_s

                 unless reservation.notes.present?
                   ##reservation.notes = val['comments'].to_s
                 end  


                 reservation.status = val['ReservationStatusName']
                 reservation.resource_id = val['ResourceID'].to_s
                 reservation.retreat_id = val['ItineraryID'].to_s
                 reservation.quantity = val['Quantity'].to_s
   
                if reservation.save(validate: false) 
                  puts reservation.name + ": save successful"
                else
                  puts "There were errors: "
                  puts reservation.errors
                end
              rescue => ex
                puts "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
                puts "FAILED TO SAVE RESERVATION"
                puts "Name: " + val['Name'].to_s
                puts "ReservationID: " + val['ReservationItemID'].to_s
                puts "ResourceID: " + val['ResourceID'].to_s
                puts "ItineraryID: " + val['ItineraryID'].to_s
                puts "Name: " + val['Name'].to_s
                puts "ReservationStatus: " + val['ReservationStatusName'].to_s
                puts "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
                puts ex.message
              end

            else
              #Not going to do anything if already exists

            end 
          end
        end
      end
       puts "Successful Reservation Download"
    rescue => ex
      
       puts ex.message
       puts "Error in Reservation Download"
    end
  end








   end 

  
 end