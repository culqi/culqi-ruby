require 'util/connect'
require 'util/validation/helper'

module Culqi::Delete

  def initialize
    @url = ''
  end

  def delete(id)
    error = verifyClassValidationGet(@url, id)
    if error
      return error
    end

    response = Culqi.connect("#{@url}#{id}/", Culqi.secret_key, nil, 'delete', Culqi::READ_TIMEOUT)
    return response
  end
end
