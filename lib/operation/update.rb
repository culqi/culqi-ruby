require 'util/connect'
require 'util/validation/helper'
require 'util/validation/plan'
require 'util/validation/subscription'

module Culqi::Update

  def initialize
    @url = ''
  end

  def update(id, params={}, rsa_key='', rsa_id='')
    error = verifyClassValidationUpdate(@url, id, params)
    if error
      puts "Error: #{error} "
      return error
    end
    if(rsa_key != '')
      params = Encrypt.encrypt_with_aes_rsa(params, rsa_key, true)
    end
    if @url.include?('plans') || @url.include?('subscriptions')
      response, statuscode = Culqi.connect("#{@url}#{id}/", Culqi.secret_key, params, 'patch', Culqi::READ_TIMEOUT, false, '')
      return response, statuscode
    end
    response, statusCode = Culqi.connect("#{@url}#{id}/", Culqi.secret_key, params, 'patch', Culqi::READ_TIMEOUT, rsa_id)
    return response, statusCode
  end

  def verifyClassValidationUpdate(url='', id, params)
    begin
      if @url.include? 'token'
        HelperValidation.validate_string_start(id, "tkn")
      end

      if @url.include? 'charge'
        HelperValidation.validate_string_start(id, "chr")
      end
      
      if @url.include? 'card'
        HelperValidation.validate_string_start(id, "crd")
      end
      
      if @url.include? 'customer'
        HelperValidation.validate_string_start(id, "cus")
      end
      
      if @url.include? 'refund'
        HelperValidation.validate_string_start(id, "ref")
      end
      
      if @url.include? 'plan'
        HelperValidation.validateId(id)
        HelperValidation.validate_string_start(id, "pln")
        PlanValidation.update(params)
      end
      
      if @url.include? 'subscription'
        HelperValidation.validateId(id)
        HelperValidation.validate_string_start(id, "sxn")
        SubscriptionValidation.update(params)
      end
      
      if @url.include? 'order'
        HelperValidation.validate_string_start(id, "ord")
      end
    rescue CustomException => e
      return e.message
    end
  end

end
