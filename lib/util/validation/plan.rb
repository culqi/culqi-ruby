require 'date'
require 'uri'
require 'json'
require 'util/validation/helper'
require 'util/validation/error'

class PlanValidation
  def self.create(data)
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

    # Validate interval
    allowed_values = ['dias', 'semanas', 'meses', 'años']
    HelperValidation.validate_value(data[:interval], allowed_values)

    # Validate currency
    HelperValidation.validate_currency_code(data[:currency_code])
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

    if 'creation_date_from' in data and 'creation_date_to' in data:
      Helpers.validate_date_filter(data['creation_date_from'], data['creation_date_to'])
    end
  end
end
