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
    token = Culqi::Token.create(params,  rsa_key, rsa_id)
    puts token
    return JSON.parse(token)
  end

  def self.createToken
    params ={
      :card_number => '4557880621568322',
      :cvv => '111',
      :currency_code => 'PEN',
      :email => 'test1231@culqi.com',
      :expiration_month => 11,
      :expiration_year => 2026
    }
    token = Culqi::Token.create(params)
    puts token
    return JSON.parse(token)

  end

  def self.createYape
    params = {
      :amount => '1000',
      :fingerprint => '86d3c875769bf62b0471b47853bfda77',
      :number_phone => '900000001',
      :otp => '111111'
    }

    yape = Culqi::Token.create(params)
    return JSON.parse(yape)

  end

  def self.createCharge
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
    charge = Culqi::Charge.create(params)
    puts charge
    return JSON.parse(charge)

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
    charge = Culqi::Charge.create(params, rsa_key, rsa_id)
    puts charge
    return JSON.parse(charge)

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
    order = Culqi::Order.create(params)
    puts order
    return JSON.parse(order)

  end

  def self.updateOrder
    id = createOrder['id']
    params = {
      :metadata => ({
        :dni => '71701978'
      }),
      :expiration_date => (Time.now + (2*7*24*60*60)).to_i
    }
    order = Culqi::Order.update(id, params)
    puts order
    return JSON.parse(order)

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
    order = Culqi::Order.create(params,  rsa_key, rsa_id)
    puts order
    return JSON.parse(order)

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

    plan = Culqi::Plan.create(params)
    puts plan
    return JSON.parse(plan)

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
    customer = Culqi::Customer.create(params)
    puts customer
    return JSON.parse(customer)

  end

  def self.createCard
    params = {
      :customer_id => createCustomer['id'],
      :token_id => createToken['id']
    }
    card = Culqi::Card.create(params)
    puts card
    return JSON.parse(card)

  end

  def self.createSubscription
    params = {
      :card_id => createCard['id'],
      :plan_id => createPlan['id']
    }
    subscription = Culqi::Subscription.create(params)
    puts subscription
    return JSON.parse(subscription)

  end

  def self.createRefund
    params = {
      :amount => 500,
      :charge_id => createCharge['id'],
      :reason => 'solicitud_comprador'
    }
    refund = Culqi::Refund.create(params)
    puts refund
    return JSON.parse(refund)
  end

  def self.confirmOrder
    confirmOrder = Culqi::Order.confirm(
      :order_id => createOrder['id'],
      :order_types => ([
        "cuotealo",
        "cip"
      ])
    )
    puts confirmOrder
    return JSON.parse(confirmOrder)
  end

end
