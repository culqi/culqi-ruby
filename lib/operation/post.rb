require 'util/connect'

module Post

  def initialize
    @url = ''
  end

  def create(params={})
    key = ''
    if @url.include? 'token'
      key = Culqi.public_key
    else
      key = Culqi.secret_key
    end
    response = Culqi.connect(@url, key, params, 'post', Culqi::READ_TIMEOUT)
    return response.read_body
  end

end
