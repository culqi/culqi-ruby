require 'net/http'
require 'json'
require 'culqi-ruby'

module Culqi
  def self.connect(url, api_key, data, type, time_out, secure_url = false, rsa_id='')
    base_url = secure_url ? Culqi::API_BASE_SECURE : Culqi::API_BASE
    full_url = "#{base_url}#{url}"
    uri = URI(full_url)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = uri.scheme == 'https'

    headers = {
      "Authorization" => "Bearer #{api_key}",
      "Content-Type" => "application/json",
      "cache-control" => "no-cache"
    }
    headers["x-culqi-rsa-id"] = rsa_id if rsa_id && !rsa_id.empty?

    case type.upcase
    when 'GET'
      request = Net::HTTP::Get.new(uri.request_uri, headers)
    when 'POST'
      request = Net::HTTP::Post.new(uri.request_uri, headers)
      request.body = data.to_json if data
    when 'DELETE'
      request = Net::HTTP::Delete.new(uri.request_uri, headers)
    when 'PATCH'
      request = Net::HTTP::Patch.new(uri.request_uri, headers)
      request.body = data.to_json if data
    else
      raise ArgumentError, "Unsupported request type: #{type}"
    end

    http.read_timeout = time_out
    response = http.request(request)
    puts response.body

    return response.body, response.code.to_i
  end
end
