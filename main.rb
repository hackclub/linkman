require 'sinatra'
require 'airrecord'
require 'byebug'
# require 'dotenv/load'

# key, base, table
Site = Airrecord.table(ENV['AIRTABLE_KEY'], ENV['AIRTABLE_BASE'], "sites")

get '/' do
  ref = params['ref']

  # check that ref exists
  if !params.key?('ref')
    return "i swear sheriff! you've got the wrong guy!! (ref)"
  end

  # select the url specified in ref
  ref = ref.downcase

  if ref[-1, 1] == '/'
    ref = ref.delete_suffix('/')
  end

  if !ref.include?('https://')
    ref = ref.gsub('http://', '')
    ref = 'https://' + ref
  end

  rec = Site.all.select {|r| ref == r['website']}.first

  # verify that the above actually corresponds to a record
  if !rec
    return "i swear sheriff! you've got the wrong guy!! (existance)"
  end

  # make sure that the above record links to another record
  if !rec['link_to'].is_a?(Array)
    return "i swear sheriff! you've got the wrong guy!! (linked)"
  end

  # get that record's website
  found_rec = Site.find(rec['link_to'][0])

  redirect found_rec['website'], 302
end

