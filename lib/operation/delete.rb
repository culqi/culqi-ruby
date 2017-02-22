require 'util/connect'

module Delete

  def initialize
    @url = ''
  end

  def delete(id)
    response = Culqi.connect(@url+id+'/', Culqi.secret_key, nil, 'delete', Culqi::READ_TIMEOUT)
    return response.read_body
  end

end
