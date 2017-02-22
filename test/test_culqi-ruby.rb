gem 'minitest'
require 'minitest/autorun'
require 'securerandom'
require 'culqi-ruby'

class CulqiTest < Minitest::Test

  Culqi.public_key = ENV['CODE_COMMERCE']
  Culqi.secret_key = ENV['API_KEY']

  def getToken

    token = Culqi::Token.create(
      :card_number => '4111111111111111',
      :cvv => '123',
      :currency_code => 'PEN',
      :email => 'test@culqi.com',
      :expiration_month => 9,
      :expiration_year => 2020
    )

    return JSON.parse(token)

  end

  def getCharge

    charge = Culqi::Charge.create(
      :amount => 1000,
      :capture => true,
      :currency_code => "PEN",
      :description => "Venta de prueba",
      :email => 'wmuro@me.com',
      :installments => 0,
      :metadata => ({
          :test => 'test123'
      }),
      :source_id => getToken["id"]
    )

    return JSON.parse(charge)

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
      :customer_id => getCustomer["id"],
      :token_id => getToken["id"]
    )

    return JSON.parse(card)

  end


  def getSubscription

    subscription = Culqi::Subscription.create(
      :card_id => getCard["id"],
      :plan_id => getPlan["id"]
    )

    return JSON.parse(subscription)

  end

  #def getRefund
  #  refund = Culqi::Refund.create(
  #    :amount => 500,
  #    :charge_id => getCharge["id"],
  #    :reason => "bought an incorrect product"
  #  )
  #  return JSON.parse(refund)
  #end

  def test_1_token
    assert_equal "token", getToken["object"]
  end

  def test_2_charge
    assert_equal "charge", getCharge["object"]
  end

  def test_3_plan
    assert_equal "plan", getPlan["object"]
  end

  def test_4_customer
    assert_equal "customer", getCustomer["object"]
  end

  def test_5_card
    assert_equal "card", getCard["object"]
  end

  def test_6_subscription
    assert_equal "subscription", getSubscription["object"]
  end

  #def test_refund
  #  assert_equal "refund", getRefund["object"]
  #end

end
