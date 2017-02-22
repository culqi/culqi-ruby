require 'uri'
require 'net/http'
require 'openssl'
require 'json'
require 'culqi-ruby'

module Culqi

  def self.connect(url, api_key, data, type, time_out)

    url = URI(Culqi::API_BASE+"#{url}")

    http = Net::HTTP.new(url.host, url.port)
    http.read_timeout = time_out
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = ''
    if type.upcase == 'POST'
      request = Net::HTTP::Post.new(url)
      if !data.nil?
        request.body = data.to_json
      end
    end

    if type.upcase == 'GET'
      if !data.nil?
        url.query = URI.encode_www_form(data)
        request = Net::HTTP::Get.new(url)
      else
        request = Net::HTTP::Get.new(url)
      end
    end

    if type.upcase == 'DELETE'
      request = Net::HTTP::Delete.new(url)
    end

    if type.upcase == 'PATCH'
      request = Net::HTTP::Patch.new(url)
      request.body = data.to_json
    end

    request["Authorization"] = "Bearer #{api_key}"
    request["Content-Type"] = 'application/json'
    request["cache-control"] = 'no-cache'

    return http.request(request)

  end

end
