module Culqi

  class Order

    extend List
    extend Post
    extend Get

    URL = '/orders/'

    @url = URL

    def self.capture(id)
      response = Culqi.connect("#{@url}#{id}/capture/", Culqi.secret_key, nil, "post", Culqi::READ_TIMEOUT)
      return response.read_body
    end

  end

end
