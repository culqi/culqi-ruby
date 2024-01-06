module Culqi

  class Order

    extend List
    extend Post
    extend Get
    extend Delete
    extend ConfirmType
    extend Update

    URL = '/orders/'

    @url = URL

  end

end
