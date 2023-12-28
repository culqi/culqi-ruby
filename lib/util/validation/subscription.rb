require 'date'
require 'uri'
require 'json'
require 'util/validation/helper'
require 'util/validation/error'

class SubscriptionValidation
  def self.create(data)
    HelperValidation.validate_string_start(data[:card_id], "crd")
    HelperValidation.validate_string_start(data[:plan_id], "pln")
  end
end
