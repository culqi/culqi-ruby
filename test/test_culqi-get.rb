require 'test_helper'
require 'securerandom'
require 'json'
require 'CulqiCRUD'

class CulqiTestGet < Minitest::Test

  # GET RESOURCES

  def test_get_token
    assert_equal 'token', JSON.parse(Culqi::Token.get(CulqiCRUD.createToken[0]['id'])[0])['object']
  end

  def test_get_order
    assert_equal 'order', JSON.parse(Culqi::Order.get(CulqiCRUD.createOrder[0]['id'])[0])['object']
  end

  def test_get_charge
    assert_equal 'charge', JSON.parse(Culqi::Charge.get(CulqiCRUD.createCharge[0]['id'])[0])['object']
  end

  # rake test TEST=test/test_culqi-get.rb TESTOPTS="--name=test_get_plan -v"
  def test_get_plan
    # Obtener el identificador devuelto por createPlan
    created_id = CulqiCRUD.createPlan[0]['id']
  
    # Obtener el identificador devuelto por Culqi::Plan.get
    parsed_json = JSON.parse(Culqi::Plan.get(created_id)[0])
    retrieved_id = parsed_json["id"]
  
    # Verificar que los identificadores sean iguales
    assert_equal created_id, retrieved_id, "Los identificadores no son iguales"
  end

  def test_get_customer
    assert_equal 'customer', JSON.parse(Culqi::Customer.get(CulqiCRUD.createCustomer[0]['id'])[0])['object']
  end

  def test_get_card
    assert_equal 'card', JSON.parse(Culqi::Card.get(CulqiCRUD.createCard[0]['id'])[0])['object']
  end

  # rake test TEST=test/test_culqi-get.rb TESTOPTS="--name=test_get_subscription -v"
  def test_get_subscription
    created_id = CulqiCRUD.createSubscription[0]['id']
  
    # Obtener el identificador devuelto por Culqi::Subscription.get
    parsed_json = JSON.parse(Culqi::Subscription.get(created_id)[0])
    retrieved_id = parsed_json["id"]
  
    # Verificar que los identificadores sean iguales
    assert_equal created_id, retrieved_id, "Los identificadores no son iguales"
  end

  def test_get_refund
    assert_equal 'refund', JSON.parse(Culqi::Refund.get(CulqiCRUD.createRefund[0]['id'])[0])['object']
  end

end
