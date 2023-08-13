require 'excon'
require 'json'
require 'culqi-ruby'

module Culqi
  def self.connect(url, api_key, data, type, time_out, secure_url = false, rsa_id='')
    base_url = secure_url ? Culqi::API_BASE_SECURE : Culqi::API_BASE
    full_url = "#{base_url}#{url}"

    headers = {
      "Authorization" => "Bearer #{api_key}",
      "Content-Type" => "application/json",
      "x-culqi-rsa-id" => rsa_id
    }

    puts "Body"
    puts data.to_json

    response = Excon.new(full_url,
                         headers: headers,
                         read_timeout: time_out,
                         idempotent: true,
                         retry_limit: 6)

    case type.upcase
    when 'GET'
      result = response.request(method: :get, query: data)
    when 'POST'
      result = response.request(method: :post, body: data.to_json)
    when 'DELETE'
      result = response.request(method: :delete)
    when 'PATCH'
      result = response.request(method: :patch, body: data.to_json)
    else
      raise ArgumentError, "Unsupported request type: #{type}"
    end

    puts result.body

    return result.body, result.status
  end
end
