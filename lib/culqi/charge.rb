module Culqi

  class Charge

    extend List
    extend Post
    extend Get

    URL = '/charges/'

    @url = URL

    def self.capture(id)
      response = Culqi.connect(URL+id+"/capture/", Culqi.secret_key, nil, "post", Culqi::READ_TIMEOUT)
      return response.read_body
    end

  end

end
