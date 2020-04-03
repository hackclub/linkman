require 'airrecord'
require 'dotenv/load'


Site = Airrecord.table(ENV['AIRTABLE_KEY'], ENV['AIRTABLE_BASE'], "sites")


Site.all.each do |r|
  website = r['website'].downcase.sub 'https://', ''
  r['website'] = website

  r.save
end