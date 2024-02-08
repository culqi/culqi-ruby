require 'date'
require 'uri'
require 'json'
require 'util/validation/helper'
require 'util/validation/error'

class SubscriptionValidation
  def self.create(data)
    required_payload = ['card_id','plan_id', 'tyc']
    result_validation = HelperValidation.additional_validation(data, required_payload)
    if result_validation != nil
      raise CustomException.new("#{result_validation}")
    else
      HelperValidation.validate_string_start(data[:card_id], "crd")
      # Validate card_id
      if !data[:card_id].is_a?(String) || data[:card_id].length != 25
        raise CustomException.new("El campo 'card_id' es inválido o está vacío, debe ser una cadena.")
      end

      HelperValidation.validate_string_start(data[:plan_id], "pln")
      # Validate plan_id
      if !data[:plan_id].is_a?(String) || data[:plan_id].length != 25
        raise CustomException.new("El campo 'plan_id' es inválido o está vacío, debe ser una cadena.")
      end

      # Validate tyc
      if !data[:tyc].is_a?(TrueClass) && !data[:tyc].is_a?(FalseClass)
        raise CustomException.new("El campo 'tyc' es inválido o está vacío. El valor debe ser un booleano.")
      end

      # Validate metadata
      if data.key?(:metadata)
        HelperValidation.validate_metadata(data[:metadata]) 
      end
    end
  end

  def self.list(data)
    # Validate plan_id
    if data.key?(:plan_id)
      if !data[:plan_id].is_a?(String) || data[:plan_id].length != 25
          raise CustomException.new("El campo 'plan_id' es inválido. La longitud debe ser de 25.")
      end
      HelperValidation.validate_string_start(data[:plan_id], "pln")
    end

    # Validate status
    if data.key?(:status)
      values_status = [1, 2, 3, 4, 5, 6, 8]
      if !data[:status].is_a?(Integer) || !values_status.include?(data[:status])
          raise CustomException.new("El campo 'status' es inválido. Estos son los únicos valores permitidos: 1, 2, 3, 4, 5, 6, 8")
      end
    end

    # Validate parameters creation_date_from          
    if data.key?(:creation_date_from)
      if !data[:creation_date_from].is_a?(String) || !(data[:creation_date_from].length == 10 || data[:creation_date_from].length == 13)
          raise CustomException.new("El campo 'creation_date_from' debe tener una longitud de 10 o 13 caracteres.")
      end
    end

    # Validate parameters creation_date_to
    if data.key?(:creation_date_to)
      if !data[:creation_date_to].is_a?(String) || !(data[:creation_date_to].length == 10 || data[:creation_date_to].length == 13)
          raise CustomException.new("El campo 'creation_date_to' debe tener una longitud de 10 o 13 caracteres.")
      end
    end

    # Validate parameters before
    if data.key?(:before)
      if !data[:before].is_a?(String) || data[:before].length != 25
          raise CustomException.new("El campo 'before' es inválido. La longitud debe ser de 25 caracteres.")
      end
    end

    # Validate parameters after
    if data.key?(:after)
      if !data[:after].is_a?(String) || data[:after].length != 25
          raise CustomException.new("El campo 'after' es inválido. La longitud debe ser de 25 caracteres.")
      end
    end

    # Validate parameters limit
    if data.key?(:limit)
      range_limit = (1..100)
      if !data[:limit].is_a?(Integer) || !range_limit.include?(data[:limit])
          raise CustomException.new("El filtro 'limit' admite valores en el rango 1 a 100.")
      end
    end
  
    # Validate date filter
    if data.key?('creation_date_from') && data.key?('creation_date_to')
      Helpers.validate_date_filter(data[:creation_date_from], data[:creation_date_to])
    end
  end

  def self.update(data)
    required_payload = ['card_id']
    result_validation = HelperValidation.additional_validation(data, required_payload)
    if result_validation != nil
      raise CustomException.new("#{result_validation}")
    else
      # Validate card_id
      if !data[:card_id].is_a?(String) || data[:card_id].length != 25
        raise CustomException.new("El campo 'card_id' es inválido. La longitud debe ser de 25.")
      end
      HelperValidation.validate_string_start(data[:card_id], "crd")

      # Validate metadata
      if data.key?(:metadata)
        HelperValidation.validate_metadata(data[:metadata]) 
      end
    end
  end

end
