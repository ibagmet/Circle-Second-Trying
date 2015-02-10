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
  def test_checkout_with_multiple_physical_items_in_single_shipment
    print "test_checkout_with_multiple_physical_items_in_single_shipment "

    [:credit_card, :gift_card].each do |payment_type|
      puts "payment type: #{payment_type}"
      standard_checkout_workflow(
        item_type: :physical,
        payment_type: payment_type,
        physical_quantity: 4
      )
    end
  end

  # Create a physical-only order with large quantities (> 25) that will have split shipments, using a single credit card
  def test_checkout_with_multiple_physical_items_in_split_shipments
    print "test_checkout_with_multiple_physical_items_in_split_shipments "

    [:credit_card, :gift_card].each do |payment_type|
      puts "payment type: #{payment_type}"
      standard_checkout_workflow(
        item_type: :physical,
        payment_type: payment_type,
        physical_quantity: 30
      )
    end
  end

  # Create a mixed physical and digital order with large quantities (> 25) that will have split shipments, using a single credit card (Redd)
  def test_checkout_with_multiple_physical_and_digital_items_in_split_shipments
    print "test_checkout_with_multiple_physical_and_digital_items_in_split_shipments "

    [:credit_card, :gift_card].each do |payment_type|
      puts "payment type: #{payment_type}"
      standard_checkout_workflow(
        item_type: [:digital, :physical],
        payment_type: payment_type,
        physical_quantity: 30
      )
    end
  end
end
