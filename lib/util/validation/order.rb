require 'date'
require 'uri'
require 'json'
require 'util/validation/helper'
require 'util/validation/error'

class OrderValidation
  def self.create(data)
    # Validate amount
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

    # Validate currency
    HelperValidation.validate_currency_code(data[:currency_code])

    # Validate firstname, lastname, and phone
    client_details = data[:client_details] || {}
    raise CustomException.new('first name is empty.') if client_details[:first_name].nil? || client_details[:first_name].empty?
    raise CustomException.new('last name is empty.') if client_details[:last_name].nil? || client_details[:last_name].empty?
    raise CustomException.new('phone_number is empty.') if client_details[:phone_number].nil? || client_details[:phone_number].empty?

    # Validate email
    raise CustomException.new('Invalid email.') unless HelperValidation.is_valid_email(client_details[:email])

    # Validate expiration date
    raise CustomException.new('expiration_date must be a future date.') unless HelperValidation.is_future_date(data[:expiration_date])
  end
end
