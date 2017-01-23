require 'minitest/autorun'
require 'securerandom'
require 'culqi-ruby'

class CulqiTest < Minitest::Test

  Culqi.code_commerce = ENV["CODE_COMMERCE"]
  Culqi.api_key = ENV["API_KEY"]

  def getToken

    token = Culqi::Token.create(
      :card_number => "4111111111111111",
      :currency_code => "PEN",
      :cvv => "123",
      :expiration_month => 9,
      :expiration_year => 2020,
      :last_name => "Will",
      :email => "will@culqi.com",
      :first_name => "Aguirre"
    )

    return JSON.parse(token)

  end

  def getCharge

    charge = Culqi::Charge.create(
      :address => "Avenida Lima 1232",
      :address_city => "LIMA",
      :amount => 1000,
      :country_code => "PE",
      :currency_code => "PEN",
      :email => "will@culqi.com",
      :first_name => "Will",
      :installments => 0,
      :last_name => "Aguirre",
      :metadata => "",
      :phone_number => 3333339,
      :product_description => "Venta de prueba",
      :token_id => getToken["id"]
    )

    return JSON.parse(charge)

  end

  def getPlan

    plan = Culqi::Plan.create(
      :alias => "plan-test-"+SecureRandom.uuid,
      :amount => 1000,
      :currency_code => "PEN",
      :interval => "day",
      :interval_count => 2,
      :limit => 10,
      :name => "Plan de Prueba "+SecureRandom.uuid,
      :trial_days => 50
    )

    return JSON.parse(plan)

  end

  def getSubscription

    subscription = Culqi::Subscription.create(
      :address => "Avenida Lima 123213",
      :address_city => "LIMA",
      :country_code => "PE",
      :email => "wmuro@me.com",
      :last_name => "Muro",
      :first_name => "William",
      :phone_number => 1234567789,
      :plan_alias => getPlan["alias"],
      :token_id => getToken["id"]
    )

    return JSON.parse(subscription)

  end

  def getRefund

    refund = Culqi::Refund.create(
      :amount => 500,
      :charge_id => getCharge["id"],
      :reason => "bought an incorrect product"
    )

    return JSON.parse(refund)

  end

  def test_token
    assert_equal "token", getToken["object"]
  end

  def test_charge
    assert_equal "charge", getCharge["object"]
  end

  def test_plan
    assert_equal "plan", getPlan["object"]
  end

  def test_subscription
    assert_equal "subscription", getSubscription["object"]
  end

  def test_refund
    assert_equal "refund", getRefund["object"]
  end

end
