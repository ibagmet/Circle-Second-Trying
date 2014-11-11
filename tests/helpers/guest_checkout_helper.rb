module GuestCheckoutHelper

  def guest_checkout_workflow(item_type, use_billing_address)
    logout

    add_item_to_cart if item_type.include? 'physical'
    add_digital_item_to_cart if item_type.include? 'digital'

    begin_checkout
    checkout_as_guest
    input_guest_addresses(use_billing_address)

    select_delivery if item_type.include? 'physical'

    pay_with_credit_card
    confirm_order
    verify_successful_order
  end


  def checkout_as_guest
    assert (browser.url == "#{base_url}/checkout/registration"), "url should be /checkout/registration"

    browser.text_field(name: "order[email]").set 'tests@deseretbook.com'
    browser.form(id: "checkout_form_registration").submit
  end

  def input_guest_addresses(use_billing_address = true)
    assert (browser.url == "#{base_url}/checkout"), "url should be /checkout"

    browser.text_field(name: "order[bill_address_attributes][firstname]").set 'test'
    browser.text_field(name: "order[bill_address_attributes][lastname]").set 'user'
    browser.text_field(name: "order[bill_address_attributes][address1]").set '1445 K St'
    browser.text_field(name: "order[bill_address_attributes][city]").set 'Lincoln'
    browser.select_list(name: "order[bill_address_attributes][state_id]").select 'Nebraska'
    browser.text_field(name: "order[bill_address_attributes][zipcode]").set '68508'
    browser.text_field(name: "order[bill_address_attributes][phone]").set '555-5555'
    
    if use_billing_address
      browser.input(id: "order_use_billing").click
    else
      browser.text_field(name: "order[ship_address_attributes][firstname]").set 'test'
      browser.text_field(name: "order[ship_address_attributes][lastname]").set 'user'
      browser.text_field(name: "order[ship_address_attributes][address1]").set '1445 K St'
      browser.text_field(name: "order[ship_address_attributes][city]").set 'Lincoln'
      browser.select_list(name: "order[ship_address_attributes][state_id]").select 'Nebraska'
      browser.text_field(name: "order[ship_address_attributes][zipcode]").set '68508'
      browser.text_field(name: "order[ship_address_attributes][phone]").set '555-5555'
    end

    browser.input(name: "commit").when_present.click
  end


  def pay_with_credit_card
    assert (browser.url == "#{base_url}/checkout/payment"), "url should be /checkout/payment"

    browser.input(id: "order_payments_attributes__payment_method_id_3").click
    browser.text_field(id: "card_number").set '4111111111111111'
    browser.text_field(id: "card_expiry").set '01/18'
    browser.text_field(id: "card_code").set '555'

    browser.input(name: "commit").when_present.click    
  end

end
