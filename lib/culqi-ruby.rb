require 'uri'
require 'net/http'

url = URI("https://api.culqi.com/v2/tokens/")

http = Net::HTTP.new(url.host, url.port)
http.use_ssl = true
http.verify_mode = OpenSSL::SSL::VERIFY_NONE

request = Net::HTTP::Post.new(url)
request["authorization"] = 'Bearer pk_test_vzMuTHoueOMlgUPj'
request["content-type"] = 'application/json'
request["cache-control"] = 'no-cache'
request["postman-token"] = '06119db2-b2ee-3569-569d-d75bb6c8ef50'
request.body = "{\n\t\"card_number\": \"4111111111111111\",\n\t\"currency_code\": \"PEN\",\n\t\"cvv\": \"123\",\n\t\"expiration_month\": 9,\n\t\"expiration_year\": 2020,\n\t\"last_name\": \"ww\",\n\t\"email\": \"www@ww.com\",\n\t\"first_name\": \"ww\"\n}"

response = http.request(request)
puts response.read_body
