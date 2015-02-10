module BaseCheckoutHelper

  def add_item_to_cart
    goto "/products/crucible-doubt-terryl-l-givens-92865"

    browser.button(id: "add-to-cart-button").click
    assert browser.text.include?("Item added to cart"), "Item was not correctly added to cart"
  end

  def add_digital_item_to_cart
    goto "/products/romney-family-table-ann-89648?variant_id=5897"

    # select the eBook product variant
    browser.div(id: 'product-variants').a(title: 'eBook').click
    browser.button(id: "add-to-cart-button").click
    assert browser.text.include?("Item added to cart"), "Item was not correctly added to cart"
  end

  def begin_checkout
    goto "/cart"
    browser.button(id: "checkout-link").click
    # give time for next page to load before continuing
    browser.button(id: "checkout-link").wait_while_present
  end 

  def select_delivery
    assert (browser.url == "#{base_url}/checkout/delivery"), "url should be /checkout/delivery"
    browser.input(name: "commit").when_present.click
  end

  def confirm_order
    assert (browser.url == "#{base_url}/checkout/confirm"), "url should be /checkout/confirm"

    browser.textarea(name: "preferences[comment]").set "this is a test"
    browser.input(name: "commit").when_present.click
  end

  def assert_on_order_confirmation_page
    assert(browser.url =~ /\/orders\//, 'not on an order confirmation page')
  end

  def verify_successful_order
    assert_on_order_confirmation_page
    assert browser.text.include?("Thank You. We have successfully received your order."), "Order did not successfully complete"
  end

  def get_order_number
    assert_on_order_confirmation_page
    # Get order number from the browser URL. Assumes the format is like:
    # https://stage.deseretbook.com/orders/W-STAGE-00535202074?checkout_complete=true
    return browser.url.match(/\/orders\/([A-Za-z0-9\-]+)/)[1]
  end

  def go_to_account_page
    goto '/account'
    assert_equal("#{base_url}/account", browser.url)
  end

  def go_to_order_history_page
    go_to_account_page
    browser.a(text: 'Order History').click
  end

  def confirm_order_shipment_state(order_number, expected_state)
    go_to_order_history_page
    # find the order state by navigation the html table on the order
    # history page.
    found_state = browser.div(id: 'account-orders')
      .table(class: 'order-summary')
      .a(text: order_number)
      .parent.parent
      .td(class: 'order-shipment-state')
      .text
    assert_equal(expected_state.downcase, found_state.downcase)
  end
end
