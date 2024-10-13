module Circuitree

 class ApiDownload

  def self.item_download
    Team.all.each do |team|  
        puts "CTquery method from CT library module"
        url = "https://api.circuitree.com/Exports/ExecuteQuery.json"
        puts "CT Query is: #{team.item_query}"
        paramArray = []
        data = {
          'ApiToken' => team.circuitree_api,
          'ExportQueryID' => team.item_query,
          'QueryParameters' => paramArray
        }

        uri = URI(url)
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true
        req = Net::HTTP::Post.new(uri.path, 'Content-Type' => 'application/json')
        req.body = data.to_json
        res = http.request(req)
        ct_results = JSON.parse(res.body)

      puts "Begin Item Download"
      puts "Items in Camp Dashboard go after CT definition of active"
       ct_results.each do |key,value|
        if key == "Results"
          JSON.parse(value).each do |val|
           begin 
            item = Item.find_or_create_by(:id => val['ResourceID'].to_s)
              item.id = val['ResourceID'].to_s
              item.name = val['Name'].to_s
              item.team_id = team.id
              item.description = val['Description'].to_s
                if val['Active'].to_i == 1
                  item.active ||= true
                end 
            item.save
            puts item.name

            #Creating tags for division
            item_tag = Items::Tag.find_or_create_by(team_id: team.id, name: val['Division'])
            item_tag.save
            applied_tag = Items::AppliedTag.find_or_create_by(tag_id: item_tag.id, item_id: item.id)
            applied_tag.save
            #Creating tags for Category
            item_tag = Items::Tag.find_or_create_by(team_id: team.id, name: val['Category'])
            item_tag.save
            applied_tag = Items::AppliedTag.find_or_create_by(tag_id: item_tag.id, item_id: item.id)
            applied_tag.save

          rescue => ex 
            puts "Error Saving Items: " + ex.message.to_s
          end

          end
        end
      end
      puts "Completed Item Download"
    end
  end






   end 

  
 end