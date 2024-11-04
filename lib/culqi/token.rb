require 'util/validation/token'
require 'util/validation/error'


module Culqi

  class Token

    extend List
    extend Post
    extend Get

    URL = '/tokens/'

    @url = URL

    def self.createYape(params={}, rsa_key='', rsa_id='')
      begin
        key = ''
        puts params
        if @url.include? 'token'
          TokenValidation.create_token_yape_validation(params)
          if(rsa_key != '')
            params = Encrypt.encrypt_with_aes_rsa(params, rsa_key, true)
          end
          key = Culqi.public_key 
          response, statuscode = Culqi.connect(@url + "yape", key, params, 'post', Culqi::READ_TIMEOUT, true, rsa_id)
          return response, statuscode
        end
      rescue CustomException => e
        return e.message
      end
    end

  end

end
