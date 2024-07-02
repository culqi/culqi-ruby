require 'date'
require 'uri'
require 'json'
require 'util/validation/helper'
require 'util/validation/error'

class OrderValidation
  def self.create(data)
    # Validate amount
    data = data.to_json
    data = JSON.parse(data)
    amount = data['amount'];

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

    # Validate currency
    HelperValidation.validate_currency_code(data['currency_code'])

    # Validate firstname, lastname, and phone
    client_details = data['client_details'] || {}
    raise CustomException.new('first name is empty.') if client_details['first_name'].nil? || client_details['first_name'].empty?
    raise CustomException.new('last name is empty.') if client_details['last_name'].nil? || client_details['last_name'].empty?
    raise CustomException.new('phone_number is empty.') if client_details['phone_number'].nil? || client_details['phone_number'].empty?

    # Validate email
    raise CustomException.new('Invalid email.') unless HelperValidation.is_valid_email(client_details['email'])

    # Validate expiration date
    raise CustomException.new('expiration_date must be a future date.') unless HelperValidation.is_future_date(data['expiration_date'])
  end

  def self.list(data)
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

    if data.key?('creation_date_from') && data.key?('creation_date_to')
      HelperValidation.validate_date_filter(data[:creation_date_from], data[:creation_date_to])
    end
  end
end
