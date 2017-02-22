require 'util/connect'

module Update

  def initialize
    @url = ''
  end

  def update(id, params={})
    response = Culqi.connect(@url+id+'/', Culqi.secret_key, params, 'patch', Culqi::READ_TIMEOUT)
    return response.read_body
  end

end