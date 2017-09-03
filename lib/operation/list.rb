require 'util/connect'

module Culqi::List

  def initialize
    @url = ''
  end

  def list(params={})
    response = Culqi.connect(@url, Culqi.secret_key, params, 'get', Culqi::LIST_TIMEOUT)
    return response.read_body
  end

end
