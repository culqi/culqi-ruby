require 'test_helper'
require 'securerandom'
require 'json'

class CulqiTest < Minitest::Test

  def getYape

    yape = Culqi::Yape.create(
      :amount => '1000',
      :fingerprint => '86d3c875769bf62b0471b47853bfda77',
      :number_phone => '900000001',
      :otp => '111111'
    )
    return JSON.parse(yape)

  end
  def getToken

    token = Culqi::Token.create(
      :card_number => '4111111111111111',
      :cvv => '123',
      :currency_code => 'PEN',
      :email => 'test'+SecureRandom.uuid+'@culqi.com',
      :expiration_month => 12,
      :expiration_year => 2026
    )

    return JSON.parse(token)

  end

  def getCharge

    charge = Culqi::Charge.create(
      :amount => 1000,
      :capture => false,
      :currency_code => 'PEN',
      :description => 'Venta de prueba',
      :email => 'test'+SecureRandom.uuid+'@culqi.com',
      :installments => 0,
      :metadata => ({
          :test => 'test123'
      }),
      :source_id => getToken['id']
    )
    return JSON.parse(charge)

  end

  def getOrder
    order = Culqi::Order.create(
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
      :expiration_date => '1683248919'
    )
    puts order
    return JSON.parse(order)

  end

  def getPlan

    plan = Culqi::Plan.create(
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
    )

    return JSON.parse(plan)

  end

  def getCustomer

    customer = Culqi::Customer.create(
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
    )

    return JSON.parse(customer)

  end

  def getCard

    card = Culqi::Card.create(
      :customer_id => getCustomer['id'],
      :token_id => getToken['id']
    )

    return JSON.parse(card)

  end


  def getSubscription

    subscription = Culqi::Subscription.create(
      :card_id => getCard['id'],
      :plan_id => getPlan['id']
    )

    return JSON.parse(subscription)

  end

  def getRefund
    refund = Culqi::Refund.create(
      :amount => 500,
      :charge_id => getCharge['id'],
      :reason => 'solicitud_comprador'
    )
    return JSON.parse(refund)
  end

  def test_1_yape
    assert_equal 'token', getYape['object']
  end
  def test_1_token
    assert_equal 'token', getToken['object']
  end

  def test_2_charge
    assert_equal 'charge', getCharge['object']
  end

  def test_2_order
    assert_equal 'order', getOrder['object']
  end

  def test_3_plan
    assert_equal "plan", getPlan['object']
  end

  def test_4_customer
    assert_equal 'customer', getCustomer['object']
  end

  def test_5_card
    assert_equal 'card', getCard['object']
  end

  def test_6_subscription
    assert_equal 'subscription', getSubscription['object']
  end

  def test_7_refund
    assert_equal 'refund', getRefund['object']
  end

  # GET RESOURCES

  def test_get_token
    assert_equal 'token', JSON.parse(Culqi::Token.get(getToken['id']))['object']
  end

  def test_get_charge
    assert_equal 'charge', JSON.parse(Culqi::Charge.get(getCharge['id']))['object']
  end

  def test_get_plan
    assert_equal "plan", JSON.parse(Culqi::Plan.get(getPlan['id']))['object']
  end

  def test_get_customer
    assert_equal 'customer', JSON.parse(Culqi::Customer.get(getCustomer['id']))['object']
  end

  def test_get_card
    assert_equal 'card', JSON.parse(Culqi::Card.get(getCard['id']))['object']
  end

  def test_get_subscription
    assert_equal 'subscription', JSON.parse(Culqi::Subscription.get(getSubscription['id']))['object']
  end

  def test_get_refund
    assert_equal 'refund', JSON.parse(Culqi::Refund.get(getRefund['id']))['object']
  end

  # DELETE RESOURCES

  def test_delete_subscription
    assert_equal true, JSON.parse(Culqi::Subscription.delete(getSubscription['id']))['deleted']
  end

  def test_delete_plan
    assert_equal true, JSON.parse(Culqi::Plan.delete(getPlan['id']))['deleted']
  end

  def test_delete_card
    assert_equal true, JSON.parse(Culqi::Card.delete(getCard['id']))['deleted']
  end

  def test_delete_customer
    assert_equal true, JSON.parse(Culqi::Customer.delete(getCustomer['id']))['deleted']
  end

  def test_delete_order
    assert_equal true, JSON.parse(Culqi::Order.delete(getOrder['id']))['deleted']
  end

  # CAPTURE CHARGE

  def test_capture_charge
    assert_equal 'charge', JSON.parse(Culqi::Charge.capture(getCharge['id']))['object']
  end

end
