require 'operation/list'
require 'operation/get'
require 'operation/post'
require 'operation/delete'

require 'culqi/version'
require 'culqi/iins'
require 'culqi/card'
require 'culqi/event'
require 'culqi/customer'
require 'culqi/token'
require 'culqi/charge'
require 'culqi/plan'
require 'culqi/subscription'
require 'culqi/refund'
require 'culqi/balance'

module Culqi

  API_BASE = 'https://api.culqi.com/v2'
  READ_TIMEOUT = 120

  class << self
      attr_accessor :code_commerce, :api_key
  end

end
