require 'util/connect'

module Culqi::ConfirmType

  def initialize
    @url = ''
  end

  def confirm(params={}, rsa_key='', rsa_id='')
    key = ''
    if(rsa_key != '')
      rsa_key = rsa_key
      rsa_id = rsa_id
      params = Encrypt.encrypt_with_aes_rsa(params, rsa_key, true)
    end
    key = Culqi.public_key
    response = Culqi.connect(@url+'confirm', key, params, 'post', Culqi::READ_TIMEOUT, false, rsa_id)
    return response.read_body
  end

end
