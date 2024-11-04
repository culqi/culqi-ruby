module Culqi

  class Subscription

    extend List
    extend Post
    extend Delete
    extend Get
    extend Update

    URL = '/recurrent/subscriptions/'

    @url = URL

  end

end
