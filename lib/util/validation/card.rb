require 'date'
require 'uri'
require 'json'
require 'util/validation/helper'
require 'util/validation/error'

class CardValidation
  def self.create(data)
    data = data.to_json
    data = JSON.parse(data)
    HelperValidation.validate_string_start(data['customer_id'], "cus")
    HelperValidation.validate_string_start(data['token_id'], "tkn")
  end

  def self.list(data)
    # Validate card_brand
    if data.key?('card_brand')
      allowed_brand_values = ['Visa', 'Mastercard', 'Amex', 'Diners']
      Helpers.validate_value(data[:card_brand], allowed_brand_values)
    end
  
    # Validate card_type
    if data.key?('card_type')
      allowed_card_type_values = ['credito', 'debito', 'internacional']
      Helpers.validate_value(data[:card_type], allowed_card_type_values)
    end
  
    # Validate date filter
    if data.key?('creation_date_from') && data.key?('creation_date_to')
      Helpers.validate_date_filter(data[:creation_date_from], data[:creation_date_to])
    end
  
    # Validate country_code
    if data.key?('country_code')
      Helpers.validate_value(data[:country_code], get_country_codes)
    end
  end
end
