require 'test_helper'
require 'securerandom'
require 'json'

class CulqiCRUD

  def self.createTokenEncrypt
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
    token, statusCode = Culqi::Token.create(params,  rsa_key, rsa_id)
    puts token
    return JSON.parse(token), statusCode
  end

  def self.createToken
    params ={
      :card_number => '4111111111111111',
      :cvv => '123',
      :currency_code => 'PEN',
      :email => 'test1231@culqi.com',
      :expiration_month => 9,
      :expiration_year => 2025
    }
    token, statusCode = Culqi::Token.create(params)
    token_string = token.to_s
    token_json = JSON.parse(token_string)
    id_value = token_json['id']
    print id_value
    return [token_json, statusCode]

  end

  def self.createYape
    params = {
      :amount => '1000',
      :fingerprint => '86d3c875769bf62b0471b47853bfda77',
      :number_phone => '900000001',
      :otp => '111111'
    }

    yape, statusCode = Culqi::Token.create(params)
    return JSON.parse(yape), statusCode

  end

  def self.createCharge
    token_string =  CulqiCRUD.createToken
    token_json = JSON.parse(JSON.generate(token_string[0]))


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
      :source_id => token_json['id']
    }
    charge, statusCode = Culqi::Charge.create(params)
    puts "Cargo"
    puts charge
    puts statusCode
    return JSON.parse(charge), statusCode

  end

  def self.createChargeEncrypt
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
    charge, statusCode = Culqi::Charge.create(params, rsa_key, rsa_id)
    puts charge
    return JSON.parse(charge), statusCode

  end

  def self.createOrder
    params = {
      :amount => 10000,
      :currency_code => 'PEN',
      :description => 'Venta de prueba',
      :order_number => 'pedido-ruby-'+SecureRandom.random_number(50).to_s,
      :client_details => ({
        :first_name => 'Richard',
        :last_name => 'Hendricks',
        :email => 'richar3d@piedpiper.com',
        :phone_number => '+51945145280'
      }),
      :expiration_date => (Time.now + (2*7*24*60*60)).to_i,
      :confirm => false
    }
    order, statusCode = Culqi::Order.create(params)
    puts order
    return JSON.parse(order), statusCode

  end

  def self.updateOrder
    id = createOrder['id']
    params = {
      :metadata => ({
        :dni => '71701978'
      }),
      :expiration_date => (Time.now + (2*7*24*60*60)).to_i
    }
    order, statusCode = Culqi::Order.update(id, params)
    puts order
    return JSON.parse(order), statusCode

  end

  def self.createOrderEncrypt
    rsa_key = Culqi.rsa_key
    rsa_id = Culqi.rsa_id
    params  = {
      :amount => 1000,
      :currency_code => 'PEN',
      :description => 'Venta de prueba',
      :order_number => 'pedido-'+SecureRandom.random_number(50).to_s,
      :client_details => ({
        :first_name => 'Richard',
        :last_name => 'Hendricks',
        :email => 'richard@piedpiper.com',
        :phone_number => '+51945145280'
      }),
      :expiration_date => (Time.now + (2*7*24*60*60)).to_i
    }
    order, statusCode = Culqi::Order.create(params,  rsa_key, rsa_id)
    puts order
    return JSON.parse(order), statusCode

  end

  def self.createPlan
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

    plan, statusCode = Culqi::Plan.create(params)
    puts plan
    return JSON.parse(plan), statusCode

  end

  def self.createCustomer
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
    customer, statusCode = Culqi::Customer.create(params)
    puts customer
    puts statusCode
    return JSON.parse(customer), statusCode

  end

  def self.createCard
    customer_string =  CulqiCRUD.createCustomer
    customer_json = JSON.parse(JSON.generate(customer_string[0]))
    id_value = customer_json['id']

    token_string =  CulqiCRUD.createToken
    token_json = JSON.parse(JSON.generate(token_string[0]))
    id_value2 = token_json['id']

    params = {
      :customer_id => id_value,
      :token_id => id_value2
    }
    card, statusCode = Culqi::Card.create(params)
    puts card
    return JSON.parse(card), statusCode

  end

  def self.createSubscription
    card_string =  CulqiCRUD.createCard
    card_json = JSON.parse(JSON.generate(card_string[0]))
    id_value = card_json['id']

    plan_string =  CulqiCRUD.createPlan
    plan_json = JSON.parse(JSON.generate(plan_string[0]))
    id_value2 = plan_json['id']

    params = {
      :card_id => id_value,
      :plan_id => id_value2
    }
    subscription, statusCode = Culqi::Subscription.create(params)
    puts subscription
    return JSON.parse(subscription), statusCode

  end

  def self.createRefund
    charge_string =  CulqiCRUD.createCharge
    charge_json = JSON.parse(JSON.generate(charge_string[0]))
    id_value = charge_json['id']

    params = {
      :amount => 500,
      :charge_id => id_value,
      :reason => 'solicitud_comprador'
    }
    refund, statusCode = Culqi::Refund.create(params)
    puts refund
    return JSON.parse(refund), statusCode
  end

  def self.confirmOrder
    order_string =  CulqiCRUD.createOrder
    order_json = JSON.parse(JSON.generate(order_string[0]))
    id_value = order_json['id']

    confirmOrder = Culqi::Order.confirm(
      :order_id => id_value,
      :order_types => ([
        "cuotealo",
        "cip"
      ])
    )
    puts confirmOrder
    return JSON.parse(confirmOrder)
  end

end
