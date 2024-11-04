require 'test_helper'

class TestList < Minitest::Test

  def test_tokens
    assert_operator JSON.parse(Culqi::Token.list()[0])['data'].count, :>=, 0
  end

  def test_charges
    assert_operator JSON.parse(Culqi::Charge.list()[0])['data'].count, :>=, 0
  end
  
  #rake test TEST=test/test_culqi-list.rb TESTOPTS="--name=test_plans -v"
  def test_plans
    assert_operator JSON.parse(Culqi::Plan.list(
      :limit => 100,
      #:before => "pln_live_g11kldu3uFr1pOUN",
      #:after => "pln_live_z9IBLFrXsZ7EJklN",
      #:min_amount => 300,
      #:max_amount => 500000,
      #:status => 1,
      #:creation_date_from => "",
      #:creation_date_to => ""
    )[0])['data'].count, :>=, 0
  end

    #rake test TEST=test/test_culqi-list.rb TESTOPTS="--name=test_subscriptions -v"
    def test_subscriptions
      assert_operator JSON.parse(Culqi::Subscription.list(
        :limit => 1,
        #:before => "sxn_live_JerEsyqmMaJzcCcw",
        #:after => "sxn_live_neFrhLrXQvozBdWn",
        #:status => 1,
        #:creation_date_from => "",
        #:creation_date_to => ""
      )[0])['data'].count, :>=, 0
    end

  def test_customers
    assert_operator JSON.parse(Culqi::Customer.list()[0])['data'].count, :>=, 0
  end

  def test_cards
    assert_operator JSON.parse(Culqi::Card.list()[0])['data'].count, :>=, 0
  end

  def test_refunds
    assert_operator JSON.parse(Culqi::Refund.list()[0])['data'].count, :>=, 0
  end

  #def test_events
  #  assert_operator JSON.parse(Culqi::Event.list()[0])['data'].count, :>=, 0
  #end
  #
  #def test_transfers
  #  assert_operator JSON.parse(Culqi::Transfer.list()[0])['data'].count, :>=, 0
  #end

end
