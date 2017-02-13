require 'util/connect'

module Update

  def initialize
    @url = ''
  end

  def update(id, params={})
    response = Culqi.connect(@url+id+'/', Culqi.api_key, params, 'patch')
    return response.read_body
  end

end