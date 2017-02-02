gem "minitest"
require 'minitest/autorun'
require 'securerandom'
require 'culqi-ruby'

class CulqiTest < Minitest::Test

  Culqi.code_commerce = ENV["CODE_COMMERCE"]
  Culqi.api_key = ENV["API_KEY"]

  def getToken

    token = Culqi::Token.create(
      :card_number => "4111111111111111",
      :cvv => "123",
      :email => "will@culqi.com",
      :expiration_month => 9,
      :expiration_year => 2020,
      :fingerprint => "fffqweqwq"
    )

    return JSON.parse(token)

  end

  def getCharge

    charge = Culqi::Charge.create(
      :amount => 1000,
      :antifraud_details => {
        :address => "Avenida Lima 1232",
        :address_city => "LIMA",
        :country_code => "PE",
        :email => "will@culqi.com",
        :first_name => "Will",
        :last_name => "Aguirre",
        :phone_number => 3333339,
      }
      :capture => true,
      :currency_code => "PEN",
      :description => "Venta de prueba",
      :installments => 0,
      :metadata => "",
      :source_id => getToken["id"]
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
      :card_id => "{card_id}",
      :plan_id => getPlan["id"]
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
