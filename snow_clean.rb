require 'savon'
require 'yaml'
require 'spreadsheet'
require_relative 'snow_library'

#Perform yaml imports of credentials and soap response headings
credentials = YamlImport('credentials.yml')
parsed = YamlImport('headings.yml')

#define constants
SNOW_INSTANCE = credentials['snow_instance']
USER = credentials['user']
PASS = credentials['pass']
TODAY = Time.now
FILE_PATH = ''

#define variables
request_item = 'sc_req_item'
search_value = 'active=true^GOTO123TEXTQUERY321=PTW'
search_date = TODAY

#############################
# Create spreadsheet object #
#############################
book = Spreadsheet::Workbook.new
sheet1 = book.create_worksheet :name => 'PTW For Today'
sheet1.row(0).concat parsed

######################
# Get data from SNow #
######################
client = Savon::Client.new(
  wsdl: "#{SNOW_INSTANCE}/#{request_item}.do?WSDL",
  basic_auth: [USER, PASS]
)

response = client.call(
  :get_records, message: {
    "__encoded_query" => search_value
  }
)

response = response.body[:get_records_response]

x = 0

response[:get_records_result].each do |record|
  #puts record[:description]
  row = sheet1.row(x)
  descHash = hashDescription(record, parsed)
  #row.push record[:number]
  #puts "RITM => #{record[:number]}"
  for i in 0..parsed.count
    if descHash[parsed[i]] != nil
      row.push descHash[parsed[i]].strip unless descHash[parsed[i]] == nil
    else
      row.push 'Not Available'
    end
    #puts "#{parsed[i]} => #{descHash[parsed[i]].strip}" unless descHash[parsed[i]] == nil
  end
  x += 1
end

book.write FILE_PATH
