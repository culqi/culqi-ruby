require 'util/connect'
require 'util/encrypt-data'

module Culqi::Post

  def initialize
    @url = ''
  end

  def createEncrypt(params={})
    key = ''
    puts params
    if @url.include? 'token'
      key = Culqi.public_key
      rsa_key = Culqi.rsa_key
      rsa_id = Culqi.rsa_id

      params_encrypt = Encrypt.encrypt_with_aes_rsa(params, rsa_key, true)
      response = Culqi.connectEncrypt(@url, key, params_encrypt, 'post', Culqi::READ_TIMEOUT, true, rsa_id)
      return response
    else
      key = Culqi.secret_key
      rsa_key = Culqi.rsa_key
      rsa_id = Culqi.rsa_id

      params_encrypt = Encrypt.encrypt_with_aes_rsa(params, rsa_key, true)
      response = Culqi.connectEncrypt(@url, key, params_encrypt, 'post', Culqi::READ_TIMEOUT, rsa_id)
      return response
    end
    
  end

end
