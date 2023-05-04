require 'uri'
require 'net/http'
require 'openssl'
require 'json'
require 'culqi-ruby'
require 'open3'


module Culqi

  def self.connect(url, api_key, data, type, time_out, secure_url = false, rsa_id='')

    if secure_url == true 
      url = URI("#{Culqi::API_BASE_SECURE}#{url}")
    else 
      url = URI("#{Culqi::API_BASE}#{url}")  
    end      

    http = Net::HTTP.new(url.host, url.port)
    http.read_timeout = time_out
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = ''
    if type.upcase == 'POST'
      puts api_key
      url = url.to_s
      auth_header = "Authorization: Bearer #{api_key}"
      content_type_header = "Content-Type: application/json"
      rsa_id_header = "x-culqi-rsa-id: #{rsa_id}"
      cache_control_header = "cache-control: no-cache"
      data = data.to_json

      stdout, stderr, status = Open3.capture3(
        "curl",
        "-X", "POST",
        url,
        "-H", auth_header,
        "-H", content_type_header,
        "-H", rsa_id_header,
        "-H", cache_control_header,
        "-d", data
      )

      if status.success?
        puts stdout
      else
        puts "Error: #{stderr}"
      end
    end

    if type.upcase == 'GET'
      if !data.nil?
        url.query = URI.encode_www_form(data)
        command = "curl '#{url}' -G -d '#{URI.encode_www_form(data)}'"
      else
        command = "curl '#{url}'"
      end

      stdout, stderr, status = Open3.capture3("#{command} -H 'Authorization: Bearer #{api_key}' -H 'Content-Type: application/json' -H 'cache-control: no-cache'")

    end

    if type.upcase == 'DELETE'
      command = "curl -X DELETE '#{url}' -H 'Authorization: Bearer #{api_key}' -H 'Content-Type: application/json' -H 'cache-control: no-cache'"
      stdout, stderr, status = Open3.capture3(command)
    end

    if type.upcase == 'PATCH'
      command = "curl -X PATCH '#{url}' -H 'Authorization: Bearer #{api_key}' -H 'Content-Type: application/json' -H 'x-culqi-rsa-id: #{rsa_id}' -H 'cache-control: no-cache' -d '#{data.to_json}'"
      stdout, stderr, status = Open3.capture3(command)
    end

    return stdout

  end
end
