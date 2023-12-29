require 'util/connect'
require 'util/validation/token'
require 'util/validation/charge'
require 'util/validation/customer'
require 'util/validation/refund'
require 'util/validation/plan'
require 'util/validation/card'
require 'util/validation/subscription'
require 'util/validation/order'

module Culqi::List

  def initialize
    @url = ''
  end

  def list(params={})
    error = verifyClassValidation(@url, params)
    if error
      return error
    end
    response = Culqi.connect(@url, Culqi.secret_key, params, 'get', Culqi::LIST_TIMEOUT)
    return response.read_body
  end

  def verifyClassValidation(url='', params)
    begin
      if @url.include? 'token'
        TokenValidation.list(params)
      end

      if @url.include? 'charge'
        ChargeValidation.list(params)
      end
      
      if @url.include? 'card'
        CardValidation.list(params)
      end
      
      if @url.include? 'customer'
        CustomerValidation.list(params)
      end
      
      if @url.include? 'refund'
        RefundValidation.list(params)
      end
      
      if @url.include? 'plan'
        PlanValidation.list(params)
      end
      
      if @url.include? 'subscription'
        SubscriptionValidation.list(params)
      end
      
      if @url.include? 'order'
        OrderValidation.list(params)
      end
    rescue CustomException => e
      return e.message
    end
  end

end
