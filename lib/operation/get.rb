require 'util/connect'
require 'util/validation/helper'

module Culqi::Get

  def initialize
    @url = ''
  end

  def get(id)
    error = verifyClassValidationGet(@url, id)
    if error
      puts "Error: #{error}" 
      return error
    end
    response = Culqi.connect("#{@url}#{id}/", Culqi.secret_key, nil, 'get', Culqi::READ_TIMEOUT)
    return response
  end

  def verifyClassValidationGet(url='', id)
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
        HelperValidation.retrieve(id)
        HelperValidation.validate_string_start(id, "pln")
      end
      
      if @url.include? 'subscription'
        HelperValidation.retrieve(id)
        HelperValidation.validate_string_start(id, "sxn")
      end
      
      if @url.include? 'order'
        HelperValidation.validate_string_start(id, "ord")
      end
    rescue CustomException => e
      return e.message
    end
  end

end
