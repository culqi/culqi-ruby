require 'util/connect'

module Get

  def initialize
    @url = ''
  end

  def get(id)
    response = Culqi.connect(@url+id+'/', Culqi.secret_key, nil, 'get', Culqi::READ_TIMEOUT)
    return response.read_body
  end

end
