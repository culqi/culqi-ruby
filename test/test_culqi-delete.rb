require 'test_helper'
require 'securerandom'
require 'json'
require 'CulqiCRUD'

class CulqiTestDelete < Minitest::Test


  # DELETE RESOURCES

  def test_delete_subscription
    assert_equal true, JSON.parse(Culqi::Subscription.delete(CulqiCRUD.createSubscription['id']))['deleted']
  end

  def test_delete_plan
    assert_equal true, JSON.parse(Culqi::Plan.delete(CulqiCRUD.createPlan[0]['id'])[0])['deleted']
  end

  def test_delete_card
    assert_equal true, JSON.parse(Culqi::Card.delete(CulqiCRUD.createCard[0]['id'])[0])['deleted']
  end

  def test_delete_customer
    assert_equal true, JSON.parse(Culqi::Customer.delete(CulqiCRUD.createCustomer[0]['id'])[0])['deleted']
  end

  def test_delete_order
    assert_equal true, JSON.parse(Culqi::Order.delete(CulqiCRUD.createOrder[0]['id'])[0])['deleted']
  end

end
