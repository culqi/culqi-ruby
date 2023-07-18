require 'util/connect'
require 'util/encrypt-data'
module Culqi::Post

  def initialize
    @url = ''
  end

  def create(params={}, rsa_key='', rsa_id='')
    key = ''
    puts params
    if @url.include? 'token'
      if(rsa_key != '')
        params = Encrypt.encrypt_with_aes_rsa(params, rsa_key, true)
      end
      key = Culqi.public_key 
      response, statuscode = Culqi.connect(@url, key, params, 'post', Culqi::READ_TIMEOUT, true, rsa_id)
      return response, statuscode
    else
      key = Culqi.secret_key
      response, statuscode = Culqi.connect(@url, key, params, 'post', Culqi::READ_TIMEOUT, false, '')
      return response, statuscode
    end
    
  end

end
