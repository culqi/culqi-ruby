require 'util/connect'

module Culqi::Post

  def initialize
    @url = ''
  end

  def create(params={}, isEncrypt, rsa_key, rsa_id)
    key = ''
    puts params
    if @url.include? 'token'
      if(isEncrypt)
        rsa_key = rsa_key
        rsa_id = rsa_id
        params = Encrypt.encrypt_with_aes_rsa(params, rsa_key, true)
      end
      key = Culqi.public_key 
      response = Culqi.connect(@url, key, params, 'post', Culqi::READ_TIMEOUT, true, rsa_id)
      return response
    else
      key = Culqi.secret_key
      response = Culqi.connect(@url, key, params, 'post', Culqi::READ_TIMEOUT, false, '')
      return response
    end
    
  end

end
