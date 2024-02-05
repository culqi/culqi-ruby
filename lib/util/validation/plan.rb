require 'date'
require 'uri'
require 'json'
require 'util/validation/helper'
require 'util/validation/error'

class PlanValidation
  def self.create(data)
    required_payload = ['short_name', 'description', 'amount', 'currency', 'interval_unit_time',
                    'interval_count', 'initial_cycles', 'name']
    result_validation = HelperValidation.additional_validation(data, required_payload)
    if result_validation != nil
      raise CustomException.new("#{result_validation}")
    else
      # Validate interval_unit_time
      values_interval_unit_time = [1, 2, 3, 4, 5, 6]
      if !data[:interval_unit_time].is_a?(Integer) || !values_interval_unit_time.include?(data[:interval_unit_time])
        raise CustomException.new("El campo 'interval_unit_time' tiene un valor inválido o está vacío. Estos son los únicos valores permitidos: [1, 2, 3, 4, 5, 6]")
      end
      
      # Validate interval_count
      range_interval_count = (0..9999)
      if !data[:interval_count].is_a?(Integer) || !range_interval_count.include?(data[:interval_count])
          raise CustomException.new("El campo 'interval_count' solo admite valores numéricos en el rango 0 a 9999.")
      end

      # Validate amount
      if !data[:amount].is_a?(Integer)
          raise CustomException.new("El campo 'amount' es inválido o está vacío, debe tener un valor numérico.")
      end

      # Validate name
      name_range = (5..50)
      unless data[:name].is_a?(String) && name_range.cover?(data[:name].length)
        raise CustomException.new("El campo 'name' es inválido o está vacío. El valor debe tener un rango de 5 a 50 caracteres.")
      end

      # Validate description
      description_range = (5..250)
      unless data[:description].is_a?(String) && description_range.cover?(data[:description].length)
        raise CustomException.new("El campo 'description' es inválido o está vacío. El valor debe tener un rango de 5 a 250 caracteres.")
      end

      # Validate short_name
      short_name_range = (5..50)
      unless data[:short_name].is_a?(String) && short_name_range.cover?(data[:short_name].length)
        raise CustomException.new("El campo 'short_name' es inválido o está vacío. El valor debe tener un rango de 5 a 50 caracteres.")
      end

      HelperValidation.validate_initial_cycles_parameters(data[:initial_cycles])
      initial_cycles = data[:initial_cycles]
      HelperValidation.validate_initial_cycles(initial_cycles[:has_initial_charge], data[:currency], data[:amount], initial_cycles[:amount], initial_cycles[:count])

      if data.key?(:imagen)
        HelperValidation.validate_image(data[:imagen])
      end

      # Validate metadata
      if data.key?(:metadata)
        HelperValidation.validate_metadata(data[:metadata]) 
      end 
    end
  end


  def self.list(data)
    # Validate parameters status
    if data.key?(:status)
      values_status = [1, 2]
      unless data[:status].is_a?(Integer) && values_status.include?(data[:status])
        raise CustomException.new("El filtro 'status' tiene un valor inválido o está vacío. Estos son los únicos valores permitidos: 1, 2.")
      end
    end

    # Validate parameters creation_date_from
    if data.key?(:creation_date_from)
      unless data[:creation_date_from].is_a?(String) && (data['creation_date_from'].length == 10 || data['creation_date_from'].length == 13)
        raise CustomException.new("El campo 'creation_date_from' debe tener una longitud de 10 o 13 caracteres.")
      end
    end

    # Validate parameters creation_date_to
    if data.key?(:creation_date_to)
      unless data[:creation_date_to].is_a?(String) && (data[:creation_date_to].length == 10 || data[:creation_date_to].length == 13)
        raise CustomException.new("El campo 'creation_date_to' debe tener una longitud de 10 o 13 caracteres.")
      end
    end

    # Validate parameters before
    if data.key?(:before)
      unless data[:before].is_a?(String) && data[:before].length == 25
        raise CustomException.new("El campo 'before' es inválido. La longitud debe ser de 25 caracteres.")
      end
    end

    # Validate parameters after
    if data.key?(:after)
      unless data[:after].is_a?(String) && data[:after].length == 25
        raise CustomException.new("El campo 'after' es inválido. La longitud debe ser de 25 caracteres.")
      end
    end

    # Validate parameters limit
    if data.key?(:limit)
      range_limit = (1..100)
      unless data[:limit].is_a?(Integer) && range_limit.include?(data[:limit])
        raise CustomException.new("El filtro 'limit' admite valores en el rango 1 a 100.")
      end
    end

    # Validate parameters max_amount
    if data.key?(:max_amount)
      range_max_amount = (300..500000)
      unless data[:max_amount].is_a?(Integer) && range_max_amount.include?(data[:max_amount])
        raise CustomException.new("El filtro 'max_amount' admite valores en el rango 300 a 500000.")
      end
    end

    # Validate parameters min_amount
    if data.key?(:min_amount)
      range_min_amount = (300..500000)
      unless data[:min_amount].is_a?(Integer) && range_min_amount.include?(data[:min_amount])
        raise CustomException.new("El filtro 'min_amount' admite valores en el rango 300 a 500000.")
      end
    end

    if data.key?('creation_date_from') && data.key?('creation_date_to')
      HelperValidation.validate_date_filter(data[:creation_date_from], data[:creation_date_to])
    end
  end

  def self.update(data)
    # Validate parameters status
    if data.key?(:status)
      values_status = [1, 2]
      unless data[:status].is_a?(Integer) && values_status.include?(data[:status])
        raise CustomException.new("El filtro 'status' tiene un valor inválido o está vacío. Estos son los únicos valores permitidos: 1, 2.")
      end
    end

    if data.key?(:imagen)
      HelperValidation.validate_image(data[:imagen])
    end

    # Validate metadata
    if data.key?(:metadata)
      HelperValidation.validate_metadata(data[:metadata]) 
    end 

    # Validate data update
    if data.key?(:short_name)
      range_short_name = (5..50)
      unless data[:short_name].is_a?(String) && range_short_name.cover?(data[:short_name].length)
          raise CustomException.new("El campo 'short_name' es inválido o está vacío. El valor debe tener un rango de 5 a 50 caracteres.")
      end
    end

    if data.key?(:name)
      range_name = (5..50)
      unless data[:name].is_a?(String) && range_name.cover?(data[:name].length)
          raise CustomException.new("El campo 'name' es inválido o está vacío. El valor debe tener un rango de 5 a 50 caracteres.")
      end
    end

    if data.key?(:description)
      range_description = (5..250)
      unless data[:description].is_a?(String) && range_description.cover?(data[:description].length)
          raise CustomException.new("El campo 'description' es inválido o está vacío. El valor debe tener un rango de 5 a 250 caracteres.")
      end
    end

  end

end