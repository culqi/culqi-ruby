module Culqi

  class Charge

    extend List
    extend Post
    extend Get

    URL = '/charges/'

    @url = URL

    def self.capture(id)
      response, statuscode = Culqi.connect("#{@url}#{id}/capture/", Culqi.secret_key, nil, "post", Culqi::READ_TIMEOUT)
      return response.read_body, statuscode
    end

  end

end
