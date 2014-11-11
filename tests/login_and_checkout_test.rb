require 'test_helper'

class LoginAndCheckoutTest < NibleyTest
  include BaseCheckoutHelper
  include StandardCheckoutHelper

  def test_the_login_and_checkout 
    login
    add_item_to_cart
    begin_checkout
    select_addresses
    select_delivery
    select_payment
    confirm_order
    verify_successful_order 
  end

  def test_login_after_selecting_item
    logout
    add_item_to_cart
    begin_checkout

    browser.text_field(name: "spree_user[email]").set 'tests@deseretbook.com'
    browser.text_field(name: "spree_user[password]").set 'test123'
    browser.input(name: "commit").when_present.click

    select_addresses
    select_delivery
    select_payment
    confirm_order
    verify_successful_order 
  end
end
