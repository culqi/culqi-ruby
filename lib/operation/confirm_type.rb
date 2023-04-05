require 'util/connect'

module Culqi::ConfirmType

  def initialize
    @url = ''
  end

  def confirm(params={})
    key = ''
    if @url.include? 'token'
      key = Culqi.public_key 
      response = Culqi.connect(@url, key, params, 'post', Culqi::READ_TIMEOUT, true)
      return response.read_body
    else
      key = Culqi.secret_key
      response = Culqi.connect(@url+'confirm', key, params, 'post', Culqi::READ_TIMEOUT)
      return response.read_body
    end
    
  end

end
