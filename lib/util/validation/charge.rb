require 'date'
require 'uri'
require 'json'
require 'util/validation/helper'
require 'util/validation/error'

class ChargeValidation
  def self.create(data)
    data = data.to_json
    data = JSON.parse(data)
    # Validate email
    raise 'Invalid email.' unless HelperValidation.is_valid_email(data['email'])

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

    HelperValidation.validate_currency_code(data['currency_code'])
    source_id = data['source_id']

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

  def self.list(data)
    # Validate email
    if data.key?('email')
      unless Helpers.is_valid_email(data[:email])
        raise CustomException.new('Invalid email.')
      end
    end
  
    # Validate amount
    if data.key?('amount')
      amount = data[:amount]
  
      if amount.is_a?(String)
        begin
          amount = Integer(amount)
        rescue ArgumentError
          raise CustomException.new("Invalid 'amount'. It should be an integer or a string representing an integer.")
        end
      end
  
      unless amount.is_a?(Integer)
        raise CustomException.new("Invalid 'amount'. It should be an integer or a string representing an integer.")
      end
    end
  
    # Validate min_amount
    if data.key?('min_amount')
      unless data[:min_amount].is_a?(Integer)
        raise CustomException.new('Invalid min amount.')
      end
    end
  
    # Validate max_amount
    if data.key?('max_amount')
      unless data[:max_amount].is_a?(Integer)
        raise CustomException.new('Invalid max amount.')
      end
    end
  
    # Validate installments
    if data.key?('installments')
      unless data[:installments].is_a?(Integer)
        raise CustomException.new('Invalid installments.')
      end
    end
  
    # Validate min_installments
    if data.key?('min_installments')
      unless data[:min_installments].is_a?(Integer)
        raise CustomException.new('Invalid min installments.')
      end
    end
  
    # Validate max_installments
    if data.key?('max_installments')
      unless data[:max_installments].is_a?(Integer)
        raise CustomException.new('Invalid max installments.')
      end
    end
  
    # Validate currency_code
    if data.key?('currency_code')
      Helpers.validate_currency_code(data[:currency_code])
    end
  
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
