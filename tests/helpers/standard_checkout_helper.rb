module StandardCheckoutHelper 

  def standard_checkout_workflow(login_type, item_type)
    login_type == "before" ? login : logout

    add_item_to_cart if item_type.include? 'physical'
    add_digital_item_to_cart if item_type.include? 'digital'

    begin_checkout
  
    if login_type == "during"
      browser.text_field(name: "spree_user[email]").set 'tests@deseretbook.com'
      browser.text_field(name: "spree_user[password]").set 'test123'
      browser.input(name: "commit").when_present.click
    end

    select_addresses

    select_delivery if item_type.include? 'physical'

    select_payment
    confirm_order
    verify_successful_order 
  end


  def select_addresses
    assert (browser.url == "#{base_url}/checkout/address"), "url should be /checkout/address"

    browser.element(xpath: "//fieldset[@id='billing']/div[@class='select_address']/div[1]/label/input").click

    if !browser.input(id: "order_use_billing").checked?
      browser.element(xpath: "//fieldset[@id='shipping']/div[@class='select_address']/div[1]/label/input").click
    end

    browser.input(name: "commit").when_present.click
  end

  def select_payment
    assert (browser.url == "#{base_url}/checkout/payment"), "url should be /checkout/payment"
    if !browser.input(id: "use_existing_card_yes").checked?
      # input payment information
    end

    browser.input(name: "commit").when_present.click
  end
end

