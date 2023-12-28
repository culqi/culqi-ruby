require 'test_helper'
require 'securerandom'
require 'json'
require 'CulqiCRUD'

class CulqiTestCre < Minitest::Test

  def test_create_token_encrypt
    token_string =  CulqiCRUD.createTokenEncrypt
    token_json = JSON.parse(JSON.generate(token_string[0]))
    id_value = token_json['object']
    assert_equal 'token', id_value
  end
  def test_create_yape
    token_string =  CulqiCRUD.createYape
    token_json = JSON.parse(JSON.generate(token_string[0]))
    id_value = token_json['object']
    assert_equal 'token', id_value
  end
  def test_create_token
    token_string =  CulqiCRUD.createToken
    token_json = JSON.parse(JSON.generate(token_string[0]))
    id_value = token_json['object']
    print id_value
    assert_equal 'token', id_value
  end

  def test_create_charge
    charge_string =  CulqiCRUD.createCharge
    charge_json = JSON.parse(JSON.generate(charge_string[0]))
    id_value = charge_json['object']
    assert_equal 'charge',id_value
  end

  def test_create_charge_encrypt
    charge_string =  CulqiCRUD.createChargeEncrypt
    charge_json = JSON.parse(JSON.generate(charge_string[0]))
    id_value = charge_json['object']
    assert_equal 'charge',id_value
  end

  def test_create_order
    token_string =  CulqiCRUD.createOrder
    token_json = JSON.parse(JSON.generate(token_string[0]))
    id_value = token_json['object']
    assert_equal 'order',id_value
  end

  def test_update_order
    order_string =  CulqiCRUD.updateOrder
    order_json = JSON.parse(JSON.generate(order_string[0]))
    id_value = order_json['object']
    assert_equal 'order', id_value
  end

  def test_create_order_encrypt
    order_string =  CulqiCRUD.createOrderEncrypt
    order_json = JSON.parse(JSON.generate(order_string[0]))
    id_value = order_json['object']
    assert_equal 'order', id_value
  end

  def test_create_plan
    plan_string =  CulqiCRUD.createPlan
    plan_json = JSON.parse(JSON.generate(plan_string[0]))
    id_value = plan_json['object']
    assert_equal "plan", id_value
  end

  def test_create_customer
    customer_string =  CulqiCRUD.createCustomer
    customer_json = JSON.parse(JSON.generate(customer_string[0]))
    id_value = customer_json['object']
    assert_equal 'customer', id_value
  end

  def test_create_card
    card_string =  CulqiCRUD.createCard
    card_json = JSON.parse(JSON.generate(card_string[0]))
    id_value = card_json['object']
    assert_equal 'card',id_value
  end

  def test_create_subscription
    subscription_string =  CulqiCRUD.createSubscription
    subscription_json = JSON.parse(JSON.generate(subscription_string[0]))
    id_value = subscription_json['object']
    assert_equal 'subscription', id_value
  end

  def test_create_refund
    refund_string =  CulqiCRUD.createRefund
    refund_json = JSON.parse(JSON.generate(refund_string[0]))
    id_value = refund_json['object']
    assert_equal 'refund',id_value
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
