require 'test_helper'

class LoginAndCheckoutTest < NibleyTest
  include BaseCheckoutHelper
  include StandardCheckoutHelper

  def test_the_login_and_checkout 
    login_type = 'before'
    product_type = ['physical']

    standard_checkout_workflow login_type, product_type 
  end

  def test_the_login_and_checkout_digital_product
    login_type = 'before'
    product_type = ['digital']

    standard_checkout_workflow login_type, product_type 
  end

  def test_the_login_and_checkout_mixed_products
    login_type = 'before'
    product_type = ['physical', 'digital']

    standard_checkout_workflow login_type, product_type 
  end

  def test_login_after_selecting_item
    login_type = 'during'
    product_type = ['physical']

    standard_checkout_workflow login_type, product_type 
  end

  def test_login_after_selecting_digital_item
    login_type = 'during'
    product_type = ['digital']

    standard_checkout_workflow login_type, product_type 
  end

  def test_login_after_selecting_mixed_items
    login_type = 'during'
    product_type = ['physical', 'digital']

    standard_checkout_workflow login_type, product_type 
  end

end
