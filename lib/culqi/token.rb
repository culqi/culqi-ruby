require 'culqi-ruby'
require 'util/connect'

module Culqi

  class Token

    URL = '/tokens/'

    def self.create(params={})
      response = Culqi.connect(URL, Culqi.code_commerce, params)
      return response.read_body
    end

  end

end
