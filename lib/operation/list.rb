require 'util/connect'

module List

  def initialize
    @url = ""
  end

  def list(params={})
    response = Culqi.connect(@url, Culqi.api_key, params, "get")
    return response.read_body
  end

end
