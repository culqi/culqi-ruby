require 'test_helper'

class TestList < Minitest::Test

  def test_tokens
    assert_operator JSON.parse(Culqi::Token.list()[0])['data'].count, :>=, 0
  end

  def test_charges
    assert_operator JSON.parse(Culqi::Charge.list()[0])['data'].count, :>=, 0
  end

  def test_plans
    assert_operator JSON.parse(Culqi::Plan.list()[0])['data'].count, :>=, 0
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

  def test_events
    assert_operator JSON.parse(Culqi::Event.list()[0])['data'].count, :>=, 0
  end

  def test_transfers
    assert_operator JSON.parse(Culqi::Transfer.list()[0])['data'].count, :>=, 0
  end

end
