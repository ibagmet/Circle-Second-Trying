require 'test_helper'

class LoginAndCheckoutTest < NibleyTest
  include BaseCheckoutHelper
  include StandardCheckoutHelper
  include GiftCardHelper


  def test_the_login_and_checkout 
    login_type = 'before'
    product_type = ['physical']
    payment_type = 'gift card'

    ['before', 'during'].each do |login_type|
      [['physical'], ['digital'], ['physical', 'digital']].each do |product_type|
        ['credit card', 'gift card'].each do |payment_type|
          puts "standard checkout running login type: #{login_type}  product type: #{product_type}   payment type: #{payment_type}"
          standard_checkout_workflow login_type, product_type, payment_type
        end
      end
    end
  end

end
