require 'culqi-ruby'
require 'util/connect'

module Culqi

  class Charge

    extend Post
    extend Get

    URL = '/charges/'

    @url = URL

  end

end
