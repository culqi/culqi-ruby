require 'date'
require 'uri'
require 'json'
require 'util/country-codes'
require 'util/validation/helper'
require 'util/validation/error'

class CustomerValidation
  def self.create(data)
    # Validate address, firstname, and lastname
    raise CustomException.new('first name is empty.') if data[:first_name].nil? || data[:first_name].empty?
    raise CustomException.new('last name is empty.') if data[:last_name].nil? || data[:last_name].empty?
    raise CustomException.new('address is empty.') if data[:address].nil? || data[:address].empty?
    raise CustomException.new('address_city is empty.') if data[:address_city].nil? || data[:address_city].empty?

    unless data[:phone_number].is_a?(String)
      raise CustomException.new("Invalid 'phone_number'. It should be a string.")
    end

    # Validate country code
    HelperValidation.validate_value(data[:country_code], CountryCodes.get_country_codes)

    # Validate email
    raise 'Invalid email.' unless HelperValidation.is_valid_email(data[:email])
  end
end
