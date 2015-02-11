module BaseCheckoutHelper
  URL_ORDER_NUMBER_PATTERN = /\/orders\/([A-Za-z0-9\-]+)/

  def add_items_to_cart(item_types, physical_quantity: 1)
    add_physical_item_to_cart(quantity: physical_quantity) if item_types.include? :physical
    add_digital_item_to_cart if item_types.include? :digital
  end

  def add_physical_item_to_cart(quantity: 1)
    goto "/products/crucible-doubt-terryl-l-givens-92865"

    browser.text_field(name: 'quantity').set quantity

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

  # valid for both order confirmation or order history pages.
  def assert_on_order_confirmation_page
    assert_match(URL_ORDER_NUMBER_PATTERN, browser.url, 'not on an order confirmation page')
  end

  def verify_successful_order
    assert_on_order_confirmation_page
    assert browser.text.include?("Thank You. We have successfully received your order."), "Order did not successfully complete"
    verify_order_totals
  end

  def verify_order_state
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

  # Walk through the line items in an order confirmation or order history page
  # and make sure all the numbers add up.
  def verify_order_totals
    assert_on_order_confirmation_page
    calculated_order_subtotal = 0.0
    
    order_details_table = browser.div(class: 'order-details').table

    # Check the subtotals of each line item
    order_details_table.tbody.rows.each do |tr|
      unit_price_cell = tr.td(class: 'price')
      unit_price = unit_price_cell.text.gsub(/[^0-9\.]/, '').to_f

      # quantity cell has no class or id, find it by relation to price cell
      quantity = unit_price_cell.td(xpath: './following-sibling::td[1]').text.to_i

      calculated_line_total = (unit_price * quantity).round(2)
      reported_line_total = tr.td(class: 'total').text.gsub(/[^0-9\.]/, '').to_f
      assert_equal(calculated_line_total, reported_line_total, 'Line item totals do not match')

      calculated_order_subtotal = (calculated_order_subtotal + calculated_line_total).round(2)
    end

    # Check that the order subtotal is are correct
    reported_order_subtotal = order_details_table.tfoot(id: 'subtotal').tr.td(class: 'total').text.gsub(/[^0-9\.]/, '').to_f
    assert_equal(calculated_order_subtotal, reported_order_subtotal, 'Order subtotals do not match')
    
    # Check that the order grand total is correct
    shipping_cost = order_details_table.tfoot(id: 'shipment-total').tr.td(class: 'total').text.gsub(/[^0-9\.]/, '').to_f
    tax = order_details_table.tfoot(id: 'tax-adjustments').tr.td(class: 'total').text.gsub(/[^0-9\.]/, '').to_f
    caclulated_order_total = (calculated_order_subtotal + shipping_cost + tax).round(2)
    reported_order_total = order_details_table.tfoot(id: 'order-total').tr.td(class: 'total').text.gsub(/[^0-9\.]/, '').to_f
    assert_equal(caclulated_order_total, reported_order_total, 'Order grand totals do not match')
  end

  def get_order_number
    assert_on_order_confirmation_page
    # Get order number from the browser URL. Assumes the format is like:
    # https://stage.deseretbook.com/orders/W-STAGE-00535202074?checkout_complete=true
    return browser.url.match(URL_ORDER_NUMBER_PATTERN)[1]
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

  def empty_cart
    cart_indicator = browser.li(class: 'cart')
    assert(cart_indicator.exists?, "Can't find cart icon on page")
    # only empty the cart if there's something in it.
    if cart_indicator.text.to_i > 0
      goto '/cart'
      browser.input(value: 'Empty Cart').click
    end
  end
end
