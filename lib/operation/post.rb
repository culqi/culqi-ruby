require 'util/connect'

module Post

  def initialize
    @url = ""
  end

  def create(params={})
    key = ""
    if @url.include? "token"
      key = Culqi.code_commerce
    else
      key = Culqi.api_key
    end
    response = Culqi.connect(@url, key, params, "post")
    return response.read_body
  end

end
