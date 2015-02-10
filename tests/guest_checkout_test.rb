require 'test_helper'

class GuestCheckoutTest < NibleyTest
  include BaseCheckoutHelper
  include GuestCheckoutHelper
  include GiftCardHelper

  def test_guest_checkout
    [[:physical]].each do |product_type|
      [true, false].each do |use_billing_address| 
        [:credit_card, :gift_card].each do |payment_type|
          puts "guest checkout running product type: #{product_type}  use_billing_address: #{use_billing_address}  payment type: #{payment_type}"
          guest_checkout_workflow product_type, use_billing_address, payment_type
        end
      end
    end
  end

  def test_guests_cannot_check_out_with_digital_items
    [[:digital], [:physical, :digital]].each do |product_type|
      puts "guest users cannot check out with digital items. product type: #{product_type}"
      clear_cookies
      add_item_to_cart if product_type.include? :physical
      add_digital_item_to_cart if product_type.include? :digital
      begin_checkout
      
      assert_checkout_as_guest_form_is_disabled
    end
  end

end
