require 'util/connect'

module Culqi::Update

  def initialize
    @url = ''
  end

  def update(id, params={}, rsa_key='', rsa_id='')
    if(rsa_key != '')
      rsa_key = rsa_key
      rsa_id = rsa_id
      params = Encrypt.encrypt_with_aes_rsa(params, rsa_key, true)
    end
    response = Culqi.connect("#{@url}#{id}/", Culqi.secret_key, params, 'patch', Culqi::READ_TIMEOUT, rsa_id)
    return response.read_body
  end

end
