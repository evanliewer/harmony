desc "This task is called by the Heroku scheduler add-on"

task :item_download => :environment do
  circuitree = Circuitree::ApiDownload.item_download
end