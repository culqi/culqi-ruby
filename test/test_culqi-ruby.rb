require 'test_helper'
require 'securerandom'
require 'json'

class CulqiTest < Minitest::Test

  def createTokenEncrypt
    rsa_key = Culqi.rsa_key
    rsa_id = Culqi.rsa_id
    params ={
      :card_number => '4557880621568322',
      :cvv => '111',
      :currency_code => 'PEN',
      :email => 'test1231@culqi.com',
      :expiration_month => 11,
      :expiration_year => 2026
    }
    token = Culqi::Token.create(params, true, rsa_key, rsa_id)
    puts token
    return JSON.parse(token)
  end
  def createYape
    rsa_key = ''
    rsa_id = ''
    params = {
      :amount => '1000',
      :fingerprint => '86d3c875769bf62b0471b47853bfda77',
      :number_phone => '900000001',
      :otp => '111111'
    }

    yape = Culqi::Token.create(params, false, rsa_key, rsa_id)
    return JSON.parse(yape)

  end
  def createToken
    rsa_key = ''
    rsa_id = ''
    params ={
      :card_number => '4557880621568322',
      :cvv => '111',
      :currency_code => 'PEN',
      :email => 'test1231@culqi.com',
      :expiration_month => 11,
      :expiration_year => 2026
    }
    token = Culqi::Token.create(params, false, rsa_key, rsa_id)
    puts token
    return JSON.parse(token)

  end

  def createCharge
    rsa_key = ''
    rsa_id = ''
    params = {
      :amount => 1000,
      :capture => false,
      :currency_code => 'PEN',
      :description => 'Venta de prueba',
      :email => 'test'+SecureRandom.uuid+'@culqi.com',
      :installments => 0,
      :metadata => ({
        :test => 'test123'
      }),
      :source_id => createToken['id']
    }
    charge = Culqi::Charge.create(params, false, rsa_key, rsa_id)
    puts charge
    return JSON.parse(charge)

  end

  def createChargeEncrypt
    rsa_key = Culqi.rsa_key
    rsa_id = Culqi.rsa_id
    params = {
      :amount => 1000,
      :capture => false,
      :currency_code => 'PEN',
      :description => 'Venta de prueba',
      :email => 'test'+SecureRandom.uuid+'@culqi.com',
      :installments => 0,
      :metadata => ({
        :test => 'test123'
      }),
      :source_id => createToken['id']
    }
    charge = Culqi::Charge.create(params, true, rsa_key, rsa_id)
    return JSON.parse(charge)

  end

  def createOrder
    rsa_key = ''
    rsa_id = ''
    params = {
      :amount => 1000,
      :currency_code => 'PEN',
      :description => 'Venta de prueba',
      :order_number => 'pedido-9966690044449',
      :client_details => ({
        :first_name => 'Richard',
        :last_name => 'Hendricks',
        :email => 'richar3d@piedpiper.com',
        :phone_number => '+51945145280'
      }),
      :expiration_date => '1682039645'
    }
    order = Culqi::Order.create(params, false, rsa_key, rsa_id)
    puts order
    return JSON.parse(order)

  end

  def createOrderEncrypt
    rsa_key = Culqi.rsa_key
    rsa_id = Culqi.rsa_id
    params  = {
      :amount => 1000,
      :currency_code => 'PEN',
      :description => 'Venta de prueba',
      :order_number => 'pedido-999002',
      :client_details => ({
        :first_name => 'Richard',
        :last_name => 'Hendricks',
        :email => 'richard@piedpiper.com',
        :phone_number => '+51945145280'
      }),
      :expiration_date => '1682039645'
    }
    order = Culqi::Order.create(params, true, rsa_key, rsa_id)
    return JSON.parse(order)

  end

  def createPlan
    rsa_key = ''
    rsa_id = ''
    params = {
      :amount => 1000,
      :currency_code => 'PEN',
      :interval => 'dias',
      :interval_count => 2,
      :limit => 10,
      :metadata => ({
        :alias => 'plan_test'
      }),
      :name => 'plan-test-'+SecureRandom.uuid,
      :trial_days => 50
    }

    plan = Culqi::Plan.create(params, false, rsa_key, rsa_id)

    return JSON.parse(plan)

  end

  def createCustomer
    rsa_key = ''
    rsa_id = ''
    params = {
      :address => 'Avenida Lima 123213',
      :address_city => 'LIMA',
      :country_code => 'PE',
      :email => 'test'+SecureRandom.uuid+'@culqi.com',
      :first_name => 'William',
      :last_name => 'Muro',
      :metadata => ({
        :other_number => '789953655'
      }),
      :phone_number => 998989789
    }
    customer = Culqi::Customer.create(params, false, rsa_key, rsa_id)

    return JSON.parse(customer)

  end

  def createCard
    rsa_key = ''
    rsa_id = ''
    params = {
      :customer_id => createCustomer['id'],
      :token_id => createToken['id']
    }
    card = Culqi::Card.create(params, false, rsa_key, rsa_id)

    return JSON.parse(card)

  end


  def createSubscription
    rsa_key = ''
    rsa_id = ''
    params = {
      :card_id => createCard['id'],
      :plan_id => createPlan['id']
    }
    subscription = Culqi::Subscription.create(params, false, rsa_key, rsa_id)

    return JSON.parse(subscription)

  end

  def createRefund
    rsa_key = ''
    rsa_id = ''
    params = {
      :amount => 500,
      :charge_id => createCharge['id'],
      :reason => 'solicitud_comprador'
    }
    refund = Culqi::Refund.create(params, false, rsa_key, rsa_id)
    return JSON.parse(refund)
  end

  def confirmOrder
    confirmOrder = Culqi::Order.confirm(
      :order_id => 'ord_live_7QmBi7Sh1ctxAe5s',
      :order_types => ([
        "cuotealo",
        "cip"
      ])
    )
    puts confirmOrder
    return JSON.parse(confirmOrder)
  end

  def test_create_token_encrypt
    assert_equal 'token', createTokenEncrypt['object']
  end
  def test_create_yape
    assert_equal 'token', createYape['object']
  end
  def test_create_token
    assert_equal 'token', createToken['object']
  end

  def test_create_charge
    assert_equal 'charge', createCharge['object']
  end

  def test_create_charge_encrypt
    assert_equal 'charge', createChargeEncrypt['object']
  end

  def test_create_order
    assert_equal 'order', createOrder['object']
  end

  def test_create_order_encrypt
    assert_equal 'order', createOrderEncrypt['object']
  end

  def test_create_plan
    assert_equal "plan", createPlan['object']
  end

  def test_create_customer
    assert_equal 'customer', createCustomer['object']
  end

  def test_create_card
    assert_equal 'card', createCard['object']
  end

  def test_create_subscription
    assert_equal 'subscription', createSubscription['object']
  end

  def test_create_refund
    assert_equal 'refund', createRefund['object']
  end

  #CONFIRM ORDER
  def test_confirm_order
    assert_equal 'order', confirmOrder['object']
  end

  # GET RESOURCES

  def test_get_token
    assert_equal 'token', JSON.parse(Culqi::Token.get(createToken['id']))['object']
  end

  def test_get_order
    assert_equal 'order', JSON.parse(Culqi::Token.get(createOrder['id']))['object']
  end

  def test_get_charge
    assert_equal 'charge', JSON.parse(Culqi::Charge.get(createCharge['id']))['object']
  end

  def test_get_plan
    assert_equal "plan", JSON.parse(Culqi::Plan.get(createPlan['id']))['object']
  end

  def test_get_customer
    assert_equal 'customer', JSON.parse(Culqi::Customer.get(createCustomer['id']))['object']
  end

  def test_get_card
    assert_equal 'card', JSON.parse(Culqi::Card.get(createCard['id']))['object']
  end

  def test_get_subscription
    assert_equal 'subscription', JSON.parse(Culqi::Subscription.get(createSubscription['id']))['object']
  end

  def test_get_refund
    assert_equal 'refund', JSON.parse(Culqi::Refund.get(createRefund['id']))['object']
  end

  # DELETE RESOURCES

  def test_delete_subscription
    assert_equal true, JSON.parse(Culqi::Subscription.delete(createSubscription['id']))['deleted']
  end

  def test_delete_plan
    assert_equal true, JSON.parse(Culqi::Plan.delete(createPlan['id']))['deleted']
  end

  def test_delete_card
    assert_equal true, JSON.parse(Culqi::Card.delete(createCard['id']))['deleted']
  end

  def test_delete_customer
    assert_equal true, JSON.parse(Culqi::Customer.delete(createCustomer['id']))['deleted']
  end

  def test_delete_order
    assert_equal true, JSON.parse(Culqi::Order.delete(createOrder['id']))['deleted']
  end

  # CAPTURE CHARGE

  def test_capture_charge
    assert_equal 'charge', JSON.parse(Culqi::Charge.capture(createCharge['id']))['object']
  end

end
