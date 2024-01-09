require 'date'
require 'uri'
require 'json'
require 'util/validation/error'

class HelperValidation
  
  def self.is_valid_card_number(number)
    !number.match(/^\d{13,19}$/).nil?
  end
  
  def self.is_valid_email(email)
    !email.match(/^\S+@\S+\.\S+$/).nil?
  end

  def self.validate_currency_code(currency_code)
    raise CustomException.new('Currency code is empty.') if currency_code.nil? || currency_code.empty?

    raise CustomException.new('Currency code must be a string.') unless currency_code.is_a?(String)

    allowed_values = ['PEN', 'USD']
    raise CustomException.new('Currency code must be either "PEN" or "USD".') unless allowed_values.include?(currency_code)
  end

  def self.validate_string_start(string, start)
    unless string.start_with?("#{start}_test_") || string.start_with?("#{start}_live_")
      raise CustomException.new("Incorrect format. The format must start with #{start}_test_ or #{start}_live_")
    end
  end

  def self.validate_value(value, allowed_values)
    raise CustomException.new("Invalid value. It must be #{JSON.generate(allowed_values)}.") unless allowed_values.include?(value)
  end

  def self.is_future_date(expiration_date)
    exp_date = Time.at(expiration_date)
    exp_date > Time.now
  end

end
