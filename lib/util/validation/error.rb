require 'json'

class CustomException < StandardError
  def initialize(merchant_message)
    @error_data = {
      "object" => "error",
      "type" => "param_error",
      "merchant_message" => merchant_message,
      "user_message" => merchant_message
    }
    super("CustomException: #{@error_data}")
  end

  def to_s
    JSON.generate(@error_data)
  end
end
