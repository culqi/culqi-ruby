require 'util/connect'

module Culqi::ConfirmType

  def initialize
    @url = ''
  end

  def confirm(params={})
    key = ''
    key = Culqi.secret_key
    response = Culqi.connect(@url+'confirm', key, params, 'post', Culqi::READ_TIMEOUT)
    return response.read_body
  end

end
