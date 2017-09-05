gem 'minitest'
require 'minitest/autorun'
require 'culqi-ruby'

class TestList < Minitest::Test

  Culqi.secret_key = ENV['SECRET_KEY']

  def test_tokens
    assert_operator JSON.parse(Culqi::Token.list())['data'].count, :>=, 0
  end

  def test_charges
    assert_operator JSON.parse(Culqi::Charge.list())['data'].count, :>=, 0
  end

  def test_plans
    assert_operator JSON.parse(Culqi::Plan.list())['data'].count, :>=, 0
  end

  def test_customers
    assert_operator JSON.parse(Culqi::Customer.list())['data'].count, :>=, 0
  end

  def test_cards
    assert_operator JSON.parse(Culqi::Card.list())['data'].count, :>=, 0
  end

  def test_refunds
    assert_operator JSON.parse(Culqi::Refund.list())['data'].count, :>=, 0
  end

  def test_events
    assert_operator JSON.parse(Culqi::Event.list())['data'].count, :>=, 0
  end

  def test_transfers
    assert_operator JSON.parse(Culqi::Transfer.list())['data'].count, :>=, 0
  end

end
