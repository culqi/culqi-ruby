require 'test_helper'
require 'securerandom'
require 'json'
require 'CulqiCRUD'

class CulqiTestCre < Minitest::Test

  def test_create_token_encrypt
    assert_equal 'token', CulqiCRUD.createTokenEncrypt['object']
  end
  def test_create_yape
    assert_equal 'token', CulqiCRUD.createYape['object']
  end
  def test_create_token
    assert_equal 'token', CulqiCRUD.createToken['object']
  end

  def test_create_charge
    assert_equal 'charge', CulqiCRUD.createCharge['object']
  end

  def test_create_charge_encrypt
    assert_equal 'charge', CulqiCRUD.createChargeEncrypt['object']
  end

  def test_create_order
    assert_equal 'order', CulqiCRUD.createOrder['object']
  end

  def test_update_order
    assert_equal 'order', CulqiCRUD.updateOrder['object']
  end

  def test_create_order_encrypt
    assert_equal 'order', CulqiCRUD.createOrderEncrypt['object']
  end

  def test_create_plan
    assert_equal "plan", CulqiCRUD.createPlan['object']
  end

  def test_create_customer
    assert_equal 'customer', CulqiCRUD.createCustomer['object']
  end

  def test_create_card
    assert_equal 'card', CulqiCRUD.createCard['object']
  end

  def test_create_subscription
    assert_equal 'subscription', CulqiCRUD.createSubscription['object']
  end

  def test_create_refund
    assert_equal 'refund', CulqiCRUD.createRefund['object']
  end

  #CONFIRM ORDER
  def test_confirm_order
    assert_equal 'order', CulqiCRUD.confirmOrder['object']
  end

  # CAPTURE CHARGE

  def test_capture_charge
    assert_equal 'charge', JSON.parse(Culqi::Charge.capture(createCharge['id']))['object']
  end

end
