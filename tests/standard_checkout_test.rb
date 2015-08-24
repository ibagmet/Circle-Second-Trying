require 'test_helper'

class LoginAndCheckoutTest < NibleyTest
  include BaseCheckoutHelper
  include StandardCheckoutHelper
  include GiftCardHelper

  def test_login_before_checkout
  
    [:physical, :digital, [:physical, :digital]].each do |product_type|
      [
        :credit_card,
        :gift_card,
        [:gift_card, :credit_card],
        [:gift_card, :gift_card, :credit_card],
        [:gift_card, :gift_card],
        [:gift_card, :gift_card, :gift_card]
      ].each do |payment_type|
        puts "standard checkout running login type: :before  product type: #{product_type}   payment type: #{payment_type}"
        standard_checkout_workflow(
          login_type: :before,
          item_type: product_type,
          payment_type: payment_type
        )
      end
    end
  end

  def test_login_during_checkout
    [:physical, :digital, [:physical, :digital]].each do |product_type|
      [
        :credit_card,
        :gift_card,
        [:gift_card, :credit_card]
      ].each do |payment_type|
        puts "standard checkout running login type: :during  product type: #{product_type}   payment type: #{payment_type}"
        standard_checkout_workflow(
          login_type: :during,
          item_type: product_type,
          payment_type: payment_type
        )
      end
    end
  end

  def test_checkout_with_gift_card_and_credit_card
    puts "test_checkout_with_gift_card_and_credit_card"
    standard_checkout_workflow(
      login_type: :before,
      item_type: :physical,
      payment_type: [:gift_card, :credit_card]
    )
  end

  # check out with multiple gift that don't cover the whole balance, use a
  # credit card for the remaining balance.
  def test_checkout_with_multiple_gift_cards_and_credit_card
    puts "test_checkout_with_multiple_gift_cards_and_credit_card"
    standard_checkout_workflow(
      login_type: :before,
      item_type: :physical,
      payment_type: [:gift_card, :gift_card, :gift_card, :credit_card]
    )
  end

  # check out with multiple gift cards but no credit cards.
  def test_checkout_with_multiple_gift_cards
    puts "test_checkout_with_multiple_gift_cards"
    standard_checkout_workflow(
      login_type: :before,
      item_type: :physical,
      payment_type: [:gift_card, :gift_card]
    )
  end

  # Create a physical-only order with small quantities (< 5) that will ship in one shipment, using a single credit card
  # Create a physical-only order with small quantities (< 5) that will ship in one shipment, using multiple gift cards and a credit card
  def test_checkout_with_multiple_physical_items_in_single_shipment
    [:credit_card, :gift_card, [:gift_card, :gift_card, :credit_card]].each do |payment_type|
      puts "test_checkout_with_multiple_physical_items_in_single_shipment payment type: #{payment_type}"
      standard_checkout_workflow(
        item_type: :physical,
        payment_type: payment_type,
        physical_quantity: 2
      )
    end
  end

  # Create a physical-only order with large quantities (> 25) that will have split shipments, using a single credit card
  # Create a physical-only order with large quantities (> 25) that will have split shipments, using multiple gift cards and a credit card
  def test_checkout_with_multiple_physical_items_in_split_shipments
    [:credit_card, :gift_card, [:gift_card, :gift_card, :credit_card]].each do |payment_type|
      puts "test_checkout_with_multiple_physical_items_in_split_shipments payment type: #{payment_type}"
      standard_checkout_workflow(
        item_type: :physical,
        payment_type: payment_type,
        physical_quantity: 26
      )
    end
  end

  # Create a mixed physical and digital order with large quantities (> 25) that will have split shipments, using a single credit card
  # Create a mixed physical and digital order with large quantities (> 25) that will have split shipments, using multiple gift cards and a credit card
  def test_checkout_with_multiple_physical_and_digital_items_in_split_shipments
    [:credit_card, :gift_card, [:gift_card, :gift_card, :credit_card]].each do |payment_type|
      puts "test_checkout_with_multiple_physical_and_digital_items_in_split_shipments payment type: #{payment_type}"
      standard_checkout_workflow(
        item_type: [:digital, :physical],
        payment_type: payment_type,
        physical_quantity: 26
      )
    end
  end

  # test that you cannot check out using a gift card that has insufficient funds
  def test_gift_card_with_insufficient_funds
    [[:digital], [:physical]].each do |item_type|
      puts "test_gift_card_with_insufficient_funds item_type: #{item_type}"
      clear_cookies
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
      clear_cookies
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
