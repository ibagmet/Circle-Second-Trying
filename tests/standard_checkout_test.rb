require 'test_helper'

class LoginAndCheckoutTest < NibleyTest
  include BaseCheckoutHelper
  include StandardCheckoutHelper
  include GiftCardHelper

  def test_the_login_and_checkout 
    # login_type = :before
    # product_type = [:physical]
    # payment_type = :gift_card

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
    [:credit_card, :gift_card].each do |payment_type|
      puts "test_checkout_with_multiple_physical_items_in_single_shipment payment type: #{payment_type}"
      standard_checkout_workflow(
        item_type: :physical,
        payment_type: payment_type,
        physical_quantity: 4
      )
    end
  end

  # Create a physical-only order with large quantities (> 25) that will have split shipments, using a single credit card
  def test_checkout_with_multiple_physical_items_in_split_shipments
    [:credit_card, :gift_card].each do |payment_type|
      puts "test_checkout_with_multiple_physical_items_in_split_shipments payment type: #{payment_type}"
      standard_checkout_workflow(
        item_type: :physical,
        payment_type: payment_type,
        physical_quantity: 30
      )
    end
  end

  # Create a mixed physical and digital order with large quantities (> 25) that will have split shipments, using a single credit card (Redd)
  def test_checkout_with_multiple_physical_and_digital_items_in_split_shipments
    [:credit_card, :gift_card].each do |payment_type|
      puts "test_checkout_with_multiple_physical_and_digital_items_in_split_shipments payment type: #{payment_type}"
      standard_checkout_workflow(
        item_type: [:digital, :physical],
        payment_type: payment_type,
        physical_quantity: 30
      )
    end
  end

  # test that you cannot check out using a gift card that has insufficient funds
  def test_gift_card_with_insufficient_funds
    [[:digital], [:physical]].each do |item_type|
      puts "test_gift_card_with_insufficient_funds item_type: #{item_type}"  
      login

      empty_cart

      add_items_to_cart(item_type)

      begin_checkout

      select_addresses(allow_skip: (!item_type.include? (:physical)))

      select_delivery if item_type.include? :physical

      select_payment(
        payment_type: :gift_card,
        gift_card_type: :insufficient_funds
      )

      assert_equal("#{base_url}/checkout/update/payment", browser.url, "incorrect location")
      assert(browser.div(class: 'flash error').present?)
      assert(browser.text =~ /has no remaining funds/)
    end
  end

  # test that you cannot check out using a gift card that is invalid
  # Nearly a duplicate of #test_gift_card_with_insufficient_funds. See how
  # much logic can be combined.
  def test_invalid_gift_card
    [[:digital], [:physical]].each do |item_type|
      puts "test_invalid_gift_card item_type: #{item_type}"  
      login

      empty_cart

      add_items_to_cart(item_type)

      begin_checkout

      select_addresses(allow_skip: (!item_type.include? (:physical)))

      select_delivery if item_type.include? :physical

      select_payment(
        payment_type: :gift_card,
        gift_card_type: :invalid
      )

      assert_equal("#{base_url}/checkout/update/payment", browser.url, "incorrect location")
      assert(browser.div(class: 'flash error').present?)
      assert(browser.text =~ /No matching Gift Card account was found/i)
    end
  end

end
