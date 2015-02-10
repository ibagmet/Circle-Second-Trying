require 'test_helper'

class LoginAndCheckoutTest < NibleyTest
  include BaseCheckoutHelper
  include StandardCheckoutHelper
  include GiftCardHelper

  def test_the_login_and_checkout 
    login_type = :before
    product_type = [:physical]
    payment_type = :gift_card

    [:before, :during].each do |login_type|
      [:physical, :digital, [:physical, :digital]].each do |product_type|
        [:credit_card, :gift_card].each do |payment_type|
          puts "standard checkout running login type: #{login_type}  product type: #{product_type}   payment type: #{payment_type}"
          standard_checkout_workflow(
            login_type: login_type,
            item_type: product_type,
            payment_type: payment_type
          )
        end
      end
    end
  end

  ### Create a physical-only order with small quantities (< 5) that will ship in one shipment, using a single credit card
  def test_checkout_with_multiple_physical_items
    puts "test_checkout_with_multiple_physical_items"

    standard_checkout_workflow(
      item_type: :physical,
      physical_quantity: 4
    )
  end

end
