module StandardCheckoutHelper 

  def standard_checkout_workflow(login_type: :before, item_type: [:physical, :digital], payment_type: :credit_card)
    clear_cookies
    login if login_type == :before

    add_item_to_cart if item_type.include? :physical
    add_digital_item_to_cart if item_type.include? :digital

    begin_checkout
  
    if login_type == :during
      browser.text_field(name: "spree_user[email]").set 'tests@deseretbook.com'
      browser.text_field(name: "spree_user[password]").set 'test123'
      browser.input(name: "commit").when_present.click
      if item_type.include?(:digital)
        browser.button(id: "checkout-link").click
        browser.button(id: "checkout-link").wait_while_present
      end
    end

    select_addresses(allow_skip: (!item_type.include? (:physical)))

    select_delivery if item_type.include? :physical

    select_payment(payment_type)
    confirm_order
    verify_successful_order

    # verify the order state
    order_number = get_order_number
    if item_type.include?(:digital)
      if item_type.include?(:physical)
        # confirm that the order state is 'partial'
        confirm_order_shipment_state(order_number, 'partial')
      else
        # confirm that the order state is 'shipped'
        confirm_order_shipment_state(order_number, 'shipped')
      end
    else
      # confirm that the order state is 'pending'
      confirm_order_shipment_state(order_number, 'pending')
    end
  end

  def select_addresses(allow_skip: false)
    if allow_skip
      # if we're only doing digital items, there is a change we'll be sent to
      # the select payment page instead; this is normal. If so, all this step
      # to be skipped.
      return if browser.url == "#{base_url}/checkout/payment"
    else
      assert_equal("#{base_url}/checkout/address", browser.url, "incorrect location")
    end

    browser.element(xpath: "//fieldset[@id='billing']/div[@class='select_address']/div[1]/label/input").click

    if !browser.input(id: "order_use_billing").checked?
      browser.element(xpath: "//fieldset[@id='shipping']/div[@class='select_address']/div[1]/label/input").click
    end

    browser.input(name: "commit").when_present.click
  end

  def select_payment(payment_type)
    assert (browser.url == "#{base_url}/checkout/payment"), "url should be /checkout/payment"

    if payment_type == :credit_card
      if browser.input(id: "use_existing_card_yes").present?
        if !browser.input(id: "use_existing_card_yes").checked?
          browser.input(id: "use_existing_card_yes").click
        end
      else
        # This is the "Credit Card" radio button on Payment Information page.
        # should find more definite way of identifying this.
        browser.input(id: 'order_payments_attributes__payment_method_id_4').click
        browser.text_field(name: "payment_source[4][name]").set 'test user'
        browser.text_field(id: "card_number").set '4111111111111111'
        browser.text_field(id: "card_expiry").set '01/18'
        browser.text_field(id: "card_code").set '555'
      end
    end

    if payment_type == :gift_card
      browser.input(id: "use_existing_card_no").click
      browser.label(text: 'Gift Card').input(type: 'radio').click
      browser.text_field(id: "gift_card_number_2").set gift_card_numbers[-1]

    end
    

    browser.input(name: "commit").when_present.click
  end
end

