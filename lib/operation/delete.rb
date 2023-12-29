require 'util/connect'
require 'util/validation/helper'

module Culqi::Delete

  def initialize
    @url = ''
  end

  def delete(id)
    error = verifyClassValidation(@url, id)
    if error
      return error
    end
    response = Culqi.connect("#{@url}#{id}/", Culqi.secret_key, nil, 'delete', Culqi::READ_TIMEOUT)
    return response.read_body
  end

  def verifyClassValidation(url='', id)
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
        HelperValidation.validate_string_start(id, "pln")
      end
      
      if @url.include? 'subscription'
        HelperValidation.validate_string_start(id, "sxn")
      end
      
      if @url.include? 'order'
        HelperValidation.validate_string_start(id, "ord")
      end
    rescue CustomException => e
      return e.message
    end

end
