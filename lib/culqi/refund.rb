require 'culqi-ruby'
require 'util/connect'

module Culqi

  class Refund

    extend Post
    extend Get

    URL = '/refunds/'

    @url = URL

  end

end
