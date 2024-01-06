require 'util/connect'
require 'util/validation/helper'

module Culqi::Update

  def initialize
    @url = ''
  end

  def update(id, params={}, rsa_key='', rsa_id='')
    error = verifyClassValidationGet(@url, id)
    if error
      return error
    end
    if(rsa_key != '')
      params = Encrypt.encrypt_with_aes_rsa(params, rsa_key, true)
    end
    response, statusCode = Culqi.connect("#{@url}#{id}/", Culqi.secret_key, params, 'patch', Culqi::READ_TIMEOUT, rsa_id)
    return response, statusCode
  end

end
