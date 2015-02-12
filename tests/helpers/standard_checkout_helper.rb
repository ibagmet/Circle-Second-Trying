module StandardCheckoutHelper 

  def standard_checkout_workflow(login_type: :before, item_type: [:physical, :digital], payment_type: :credit_card, physical_quantity: 1)
    item_type = Array(item_type) # ensure item_type is an array.
    start_new_order_log(
      login_type: login_type,
      item_type: item_type,
      payment_type: payment_type,
      physical_quantity: physical_quantity
    )

    clear_cookies
    if login_type == :before
      login
      empty_cart
    end

    add_items_to_cart(item_type, physical_quantity: physical_quantity)

    begin_checkout
  
    if login_type == :during
      # .when_present below because the field may take a moment to appear
      browser.text_field(name: "spree_user[email]").when_present.set 'tests@deseretbook.com'
      browser.text_field(name: "spree_user[password]").set 'test123'
      browser.input(name: "commit").when_present.click
      if item_type.include?(:digital)
        browser.button(id: "checkout-link").click
        browser.button(id: "checkout-link").wait_while_present
      end
    end

    select_addresses(allow_skip: (!item_type.include? (:physical)))

    select_delivery if item_type.include? :physical

    select_payment(payment_type: payment_type)
    
    confirm_order
    verify_successful_order
    verify_order_state(item_type)
    order_finished
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

  def select_payment(payment_type:, gift_card_type: :valid)
    assert (browser.url == "#{base_url}/checkout/payment"), "url should be /checkout/payment"

    if payment_type == :credit_card
      if browser.input(id: "use_existing_card_yes").present?
        if !browser.input(id: "use_existing_card_yes").checked?
          browser.input(id: "use_existing_card_yes").click
        end
        order_log(credit_card_number: :saved_number)
      else
        # This is the "Credit Card" radio button on Payment Information page.
        browser.label(text: 'Credit Card').input.click
        browser.text_field(
          id: browser.label(text: 'Name on card').for
        ).set 'test user'
        browser.text_field(
          id: browser.label(text: 'Card Number').for
        ).set '4111111111111111'
        browser.text_field(
          id: browser.label(text: 'Expiration').for
        ).set '01/18'
        browser.text_field(
          id: browser.label(text: 'Card Code').for
        ).set '555'
        order_log(credit_card_number: '4111111111111111')
      end
    end

    if payment_type == :gift_card
      number = gift_card_number(
        type: gift_card_type,
        amount: get_order_total_from_payment_summary
      )
      if browser.input(id: "use_existing_card_no").present?
        browser.input(id: "use_existing_card_no").click
      end
      browser.label(text: 'Gift Card').input(type: 'radio').click
      browser.text_field(
        id: browser.label(text: 'Gift Card Number').for
      ).set number
      order_log(gift_card_number: number)
    end
    
    browser.input(name: "commit").when_present.click
  end
end

