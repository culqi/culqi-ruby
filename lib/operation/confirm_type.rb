require 'util/connect'
require 'util/validation/helper'

module Culqi::ConfirmType

  def initialize
    @url = ''
  end

  def confirm(params={}, rsa_key='', rsa_id='')
    error = HelperValidation.validate_string_start(params[:order_id], "ord")
    if error
      return error
    end
    key = ''
    if(rsa_key != '')
      params = Encrypt.encrypt_with_aes_rsa(params, rsa_key, true)
    end
    key = Culqi.public_key
    response = Culqi.connect(@url+'confirm', key, params, 'post', Culqi::READ_TIMEOUT, false, rsa_id)
    return response
  end

end
