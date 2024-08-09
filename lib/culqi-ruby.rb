require 'operation/list'
require 'operation/get'
require 'operation/post'
require 'operation/delete'
require 'operation/update'
require 'operation/confirm_type'

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
require 'culqi/transfer'
require 'culqi/yape'
require 'culqi/order'
module Culqi

  API_BASE = 'https://api.culqi.com/v2'
  API_BASE_SECURE = 'https://secure.culqi.com/v2'
  READ_TIMEOUT = 120
  LIST_TIMEOUT = 360
  X_CULQI_ENV_TEST = "test"
  X_CULQI_ENV_LIVE = "live"
  X_API_VERSION = "2"
  X_CULQI_CLIENT = "culqi-ruby"
  X_CULQI_CLIENT_VERSION = "0.1.0"


  class << self
      attr_accessor :public_key, :secret_key, :rsa_id, :rsa_key, :headers
  end

end
