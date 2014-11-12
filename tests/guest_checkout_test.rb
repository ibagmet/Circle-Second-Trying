require 'test_helper'

class GuestCheckoutTest < NibleyTest
  include BaseCheckoutHelper
  include GuestCheckoutHelper
  include GiftCardHelper

  def test_guest_checkout
    [['physical'], ['digital'], ['physical', 'digital']].each do |product_type|
      [true, false].each do |use_billing_address| 
        ['credit card', 'gift card'].each do |payment_type|
          puts "guest checkout running product type: #{product_type}  use_billing_address: #{use_billing_address}  payment type: #{payment_type}"
          guest_checkout_workflow product_type, use_billing_address, payment_type
        end
      end
    end
  end

end
