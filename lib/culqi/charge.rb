require 'culqi-ruby'
require 'util/connect'

module Culqi

  class Charge

    URL = '/charges/'

    def self.create(params={})
      response = Culqi.connect(URL, Culqi.api_key, params)
      return response.read_body
    end

  end

end
