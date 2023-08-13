require 'test_helper'
require 'securerandom'
require 'json'
require 'CulqiCRUD'

class CulqiTestGet < Minitest::Test

  # GET RESOURCES

  def test_get_token
    assert_equal 'token', JSON.parse(Culqi::Token.get(CulqiCRUD.createToken['id']))['object']
  end

  def test_get_order
    assert_equal 'order', JSON.parse(Culqi::Token.get(CulqiCRUD.createOrder['id']))['object']
  end

  def test_get_charge
    assert_equal 'charge', JSON.parse(Culqi::Charge.get(CulqiCRUD.createCharge['id']))['object']
  end

  def test_get_plan
    assert_equal "plan", JSON.parse(Culqi::Plan.get(CulqiCRUD.createPlan['id']))['object']
  end

  def test_get_customer
    assert_equal 'customer', JSON.parse(Culqi::Customer.get(CulqiCRUD.createCustomer['id']))['object']
  end

  def test_get_card
    assert_equal 'card', JSON.parse(Culqi::Card.get(CulqiCRUD.createCard['id']))['object']
  end

  def test_get_subscription
    assert_equal 'subscription', JSON.parse(Culqi::Subscription.get(CulqiCRUD.createSubscription['id']))['object']
  end

  def test_get_refund
    assert_equal 'refund', JSON.parse(Culqi::Refund.get(CulqiCRUD.createRefund['id']))['object']
  end

end
