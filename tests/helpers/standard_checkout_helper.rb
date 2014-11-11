module StandardCheckoutHelper 

  def select_addresses
    assert (browser.url == "#{base_url}/checkout/address"), "url should be /checkout/address"

    browser.element(xpath: "//fieldset[@id='billing']/div[@class='select_address']/div[1]/label/input").click

    if !browser.input(id: "order_use_billing").checked?
      browser.element(xpath: "//fieldset[@id='shipping']/div[@class='select_address']/div[1]/label/input").click
    end

    browser.input(name: "commit").when_present.click
  end

  def select_delivery
    assert (browser.url == "#{base_url}/checkout/delivery"), "url should be /checkout/delivery"
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

