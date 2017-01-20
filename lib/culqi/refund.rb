require 'culqi-ruby'
require 'util/connect'

module Culqi

  class Refund

    URL = '/refunds/'

    def self.create(params={})
      response = Culqi.connect(URL, Culqi.api_key, params)
      return response.read_body
    end

  end

end
