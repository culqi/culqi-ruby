module Culqi

  class Charge

    extend List
    extend Post
    extend Get

    URL = '/charges/'

    @url = URL

    def capture(id)
      response = Culqi.connect(URL+id+"/capture/", Culqi.api_key, nil, "post")
      return response.read_body
    end

  end

end
