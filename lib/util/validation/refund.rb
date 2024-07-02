require 'date'
require 'uri'
require 'json'
require 'util/validation/helper'
require 'util/validation/error'

class RefundValidation
  def self.create(data)
    data = data.to_json
    data = JSON.parse(data)
    # Validate charge format
    HelperValidation.validate_string_start(data['charge_id'], "chr")

    # Validate reason
    allowed_values = ['duplicado', 'fraudulento', 'solicitud_comprador']
    HelperValidation.validate_value(data['reason'], allowed_values)

    # Validate amount
    amount = data['amount']

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
  end

  def self.list(data)
    # Validate card_brand
    if data.key?('reason')
      allowed_brand_values = ['duplicado', 'fraudulento', 'solicitud_comprador']
      Helpers.validate_value(data[:reason], allowed_brand_values)
    end
  
    # Validate date filter
    if data.key?('creation_date_from') && data.key?('creation_date_to')
      Helpers.validate_date_filter(data[:creation_date_from], data[:creation_date_to])
    end
  end
end
