require 'test_helper'

class GuestCheckoutTest < NibleyTest
  include BaseCheckoutHelper
  include GuestCheckoutHelper

  def test_guest_checkout
    logout
    add_item_to_cart
    begin_checkout
    checkout_as_guest
    input_guest_addresses
    select_delivery
    pay_with_credit_card
    confirm_order
    verify_successful_order
  end

  def test_guest_checkout_with_separate_shipping
    logout
    add_item_to_cart
    begin_checkout
    checkout_as_guest
    input_guest_addresses(false)
    select_delivery
    pay_with_credit_card
    confirm_order
    verify_successful_order
  end
end
