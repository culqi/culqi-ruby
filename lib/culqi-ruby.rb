require 'culqi/version'
require 'culqi/token'

module Culqi

  API_BASE = 'https://api.culqi.com/v2'
  READ_TIMEOUT = 120

  class << self
      attr_accessor :code_commerce, :api_key
  end

end
