require 'test_helper'
require 'securerandom'
require 'json'
require 'CulqiCRUD'

class CulqiTestDelete < Minitest::Test


  # DELETE RESOURCES

  # rake test TEST=test/test_culqi-delete.rb TESTOPTS="--name=test_delete_plan -v"
  def test_delete_plan
    assert_equal true, JSON.parse(Culqi::Plan.delete(CulqiCRUD.createPlan[0]['id'])[0])['deleted']
  end

  # rake test TEST=test/test_culqi-delete.rb TESTOPTS="--name=test_delete_subscription -v"
  def test_delete_subscription
    assert_equal true, JSON.parse(Culqi::Subscription.delete(CulqiCRUD.createSubscription[0]['id'])[0])['deleted']
  end  

  def test_delete_card
    assert_equal true, JSON.parse(Culqi::Card.delete(CulqiCRUD.createCard[0]['id'])[0])['deleted']
  end

  def test_delete_customer
    assert_equal true, JSON.parse(Culqi::Customer.delete(CulqiCRUD.createCustomer[0]['id'])[0])['deleted']
  end

  def test_delete_order
    _, response_status = Culqi::Order.delete(CulqiCRUD.createOrder[0]['id'])
    # Verifica que el status 204 (Not content)
    assert_equal 204, response_status  
  end

end
