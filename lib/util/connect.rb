require 'uri'
require 'net/http'
require 'openssl'
require 'json'
require 'culqi-ruby'
require 'open3'

module Culqi

  def self.connect(url, api_key, data, type, time_out, secure_url = false)    

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
    #request["x-culqi-rsa-id"] = 'ac3af62d-f16a-4244-be2a-bbf529f339db'
    request["cache-control"] = 'no-cache'

    if request.body && !request.body.empty?
      begin
        json_body = JSON.parse(request.body)
        puts "Cuerpo del request (JSON):"
        puts JSON.pretty_generate(json_body)
      rescue JSON::ParserError
        puts "Cuerpo del request (sin procesar):"
        puts request.body
      end
    else
      puts "Cuerpo del request: vacío"
    end
    puts "Método HTTP: #{request.method}"
    puts "URI: #{request.uri}"
    puts "Headers:"
    request.each_header do |header, value|
      puts "  #{header}: #{value}"
    end
    return http.request(request)

  end

  def self.connectEncrypt(url, api_key, data, type, time_out, secure_url = false, rsa_id)

    if secure_url == true
      url = URI("#{Culqi::API_BASE_SECURE}#{url}")
    else
      url = URI("#{Culqi::API_BASE}#{url}")
    end
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

    return stdout
  end
end
