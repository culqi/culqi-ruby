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

  def self.additional_validation(data, required_fields)
    required_fields.each do |field|
      
      if !data.key?(field.to_sym) || data[field.to_sym].nil? || (data[field.to_sym].is_a?(String) && data[field.to_sym].empty?) || data[field.to_sym] == "undefined"
        puts "¡ERROR! El campo '#{field}' es requerido y no está presente"
        raise CustomException.new("El campo '#{field}' es requerido y no está presente")
      end
    end
    return nil
  end

  def self.validate_initial_cycles_parameters(initial_cycles)
    parameters_initial_cycles = ['count', 'has_initial_charge', 'amount', 'interval_unit_time']
    parameters_initial_cycles.each do |campo|
      unless initial_cycles.key?(campo.to_sym)
        raise CustomException.new("El campo obligatorio '#{campo}' no está presente en 'initial_cycles'.")
      end
    end
  
    unless initial_cycles[:count].is_a?(Integer)
      raise CustomException.new("El campo 'initial_cycles.count' es inválido o está vacío, debe tener un valor numérico.")
    end
  
    unless [true, false].include?(initial_cycles[:has_initial_charge])
      raise CustomException.new("El campo 'initial_cycles.has_initial_charge' es inválido o está vacío. El valor debe ser un booleano (true o false).")
    end
  
    unless initial_cycles[:amount].is_a?(Integer)
      raise CustomException.new("El campo 'initial_cycles.amount' es inválido o está vacío, debe tener un valor numérico.")
    end
  
    values_interval_unit_time = [1, 2, 3, 4, 5, 6]
    unless initial_cycles[:interval_unit_time].is_a?(Integer) && values_interval_unit_time.include?(initial_cycles[:interval_unit_time])
      raise CustomException.new("El campo 'initial_cycles.interval_unit_time' tiene un valor inválido o está vacío. Estos son los únicos valores permitidos: [1, 2, 3, 4, 5, 6]")
    end
  end

  def self.validate_enum_currency(currency)
    allowed_values = ["PEN", "USD"]
    return nil if allowed_values.include?(currency)
  
    raise CustomException.new("El campo 'currency' es inválido o está vacío, el código de la moneda en tres letras (Formato ISO 4217). Culqi actualmente soporta las siguientes monedas: #{allowed_values}.")
  end
  
  def self.validate_initial_cycles(has_initial_charge, currency, amount, pay_amount, count)
    if has_initial_charge
      err = validate_enum_currency(currency)
      raise CustomException.new(err) if err
    
      unless (1..9999).include?(count)
        raise CustomException.new("El campo 'initial_cycles.count' solo admite valores numéricos en el rango 1 a 9999.")
      end
  
    else
      unless (0..9999).include?(count)
        raise CustomException.new("El campo 'initial_cycles.count' solo admite valores numéricos en el rango 0 a 9999.")
      end

    end
  end
  
  def self.validate_image(image)
    regex_image = /^(http:\/\/www\.|https:\/\/www\.|http:\/\/|https:\/\/)?[a-zA-Z0-9]+([-.]{1}[a-zA-Z0-9]+)*\.[a-zA-Z]{2,5}(:[0-9]{1,5})?(\/.*)?$/

    unless image.is_a?(String) && (5..250).include?(image.length) && image.match?(regex_image)
        raise CustomException.new("El campo 'image' es inválido. Debe ser una cadena y una URL válida.")
    end
  end

  def self.validate_metadata(metadata)
    return nil if metadata.empty?

    validate_key_and_value_length(metadata)
    begin
        metadata.to_json
    rescue JSON::GeneratorError => e
        return e
    end

    nil
  end

  def self.validate_key_and_value_length(obj_metadata)
    max_key_length = 30
    max_value_length = 200

    obj_metadata.each do |key, value|
        key_str = key.to_s
        value_str = value.to_s
        if key_str.length > max_key_length || value_str.length > max_value_length
          raise CustomException.new("El objeto 'metadata' es inválido, límite key (1 - #{max_key_length}), value (1 - #{max_value_length}).")
        end
    end
  end

  def self.validateId(id)
    unless id.is_a?(String) && id.length == 25
      raise CustomException.new("El campo 'id' es inválido. La longitud debe ser de 25 caracteres.")
    end
  end

end
