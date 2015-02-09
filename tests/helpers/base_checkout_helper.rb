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

  def verify_successful_order
    assert browser.text.include?("Thank You. We have successfully received your order."), "Order did not successfully complete"
  end
end
