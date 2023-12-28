require 'date'
require 'uri'
require 'json'
require 'util/validation/helper'
require 'util/validation/error'

class ChargeValidation
  def self.create(data)
    # Validate email
    raise 'Invalid email.' unless HelperValidation.is_valid_email(data[:email])

    # Validate amount
    amount = data[:amount]

    if amount.is_a?(String)
      begin
        amount = Integer(amount)
        print amount
      rescue ArgumentError
        raise CustomException.new("Invalid 'amount'. It should be an integer or a string representing an integer.")
      end
    end

    unless amount.is_a?(Integer)
      raise CustomException.new("Invalid 'amount'. It should be an integer or a string representing an integer.")
    end

    HelperValidation.validate_currency_code(data[:currency_code])
    source_id = data[:source_id]

    if source_id.start_with?("tkn")
      HelperValidation.validate_string_start(source_id, "tkn")
    elsif source_id.start_with?("ype")
      HelperValidation.validate_string_start(source_id, "ype")
    elsif source_id.start_with?("crd")
      HelperValidation.validate_string_start(source_id, "crd")
    else
      raise CustomException.new("Incorrect format. The format must start with tkn, ype, or crd")
    end

  end
end
