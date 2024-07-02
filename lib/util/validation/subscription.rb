require 'date'
require 'uri'
require 'json'
require 'util/validation/helper'
require 'util/validation/error'

class SubscriptionValidation
  def self.create(data)
    data = data.to_json
    data = JSON.parse(data)
    HelperValidation.validate_string_start(data['card_id'], "crd")
    HelperValidation.validate_string_start(data['plan_id'], "pln")
  end

  def self.list(data)
    # Validate card_brand
    if data.key?('plan_id')
      HelperValidation.validate_string_start(data[:plan_id], "pln")
    end
  
    # Validate date filter
    if data.key?('creation_date_from') && data.key?('creation_date_to')
      Helpers.validate_date_filter(data[:creation_date_from], data[:creation_date_to])
    end
  end
end
