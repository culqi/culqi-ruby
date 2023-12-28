require 'date'
require 'uri'
require 'json'
require 'util/validation/helper'
require 'util/validation/error'

class CardValidation
  def self.create(data)
    HelperValidation.validate_string_start(data[:customer_id], "cus")
    HelperValidation.validate_string_start(data[:token_id], "tkn")
  end
end
