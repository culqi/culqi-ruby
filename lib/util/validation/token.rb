require 'date'
require 'uri'
require 'json'
require 'util/country-codes'
require 'util/validation/helper'
require 'util/validation/error'

class TokenValidation
  def self.create(data)
    data = data.to_json
    data = JSON.parse(data)

    # Validate card number
    raise CustomException.new('Invalid card number.') unless HelperValidation.is_valid_card_number(data['card_number'])

    # Validate CVV
    raise CustomException.new('Invalid CVV.') unless data['cvv']&.match?(/^\d{3,4}$/)

    # Validate email
    raise CustomException.new('Invalid email.') unless HelperValidation.is_valid_email(data['email'])

    # Validate expiration month
    raise 'Invalid expiration month.' unless data['expiration_month'].to_s.match?(/^(0?[1-9]|1[012])$/)

    # Validate expiration year
    current_year = Date.today.year
    if !data['expiration_year'].to_s.match?(/^\d{4}$/) || data['expiration_year'].to_s.to_i < current_year
      raise 'Invalid expiration year.'
    end

    # Check if the card is expired
    exp_date = Date.strptime("#{data['expiration_year']}-#{data['expiration_month']}", '%Y-%m')
    raise 'Card has expired.' if exp_date < Date.today
  end

  def self.create_token_yape_validation(data)
    data = data.to_json
    data = JSON.parse(data)
    # Validate amount
    unless data['amount'].is_a?(Numeric) && data['amount'].to_i == data['amount']
      raise CustomException.new('Invalid amount.')
    end
  end
  
  def self.list(data)
    if data.key?('device_type')
      allowed_device_values = ['desktop', 'mobile', 'tablet']
      HelperValidation.validate_value(data[:device_type], allowed_device_values)
    end
  
    if data.key?('card_brand')
      allowed_brand_values = ['Visa', 'Mastercard', 'Amex', 'Diners']
      HelperValidation.validate_value(data[:card_brand], allowed_brand_values)
    end
  
    if data.key?('card_type')
      allowed_card_type_values = ['credito', 'debito', 'internacional']
      HelperValidation.validate_value(data[:card_type], allowed_card_type_values)
    end
  
    if data.key?('country_code')
      HelperValidation.validate_value(data[:country_code], get_country_codes)
    end
  
    if data.key?('creation_date_from') && data.key?('creation_date_to')
      HelperValidation.validate_date_filter(data[:creation_date_from], data[:creation_date_to])
    end
  end
  
end
