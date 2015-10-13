require 'test_helper'
require 'faker'

class PaymentTest < NibleyTest
include GiftCardHelper
include BaseCheckoutHelper
include StandardCheckoutHelper

  def test_form_of_payment
    sigin_up
    searching_for_rings
    credit_card_and_address_setting
    browser.text_field(id: "card_number").set '4111111111111111'
    confirmation_of_oder
    searching_for_rings
    browser.span(text: "8").click
    from_cart_to_payment
    apply_gift_card

    finding_sum

    confirmation_of_oder
    browser.text_field(name: "keywords").set '5080130'  #searching by sku#
    browser.input(class: "btn btn-primary img-responsive js-search-button").click
    assert(browser.h1(text: "Search results for '5080130'").exists?)
    browser.img(alt: "Heavenly Flower CTR Ring").click
    browser.span(text: "6.5").click
    from_cart_to_payment
    apply_gift_card
    
    finding_sum

    apply_gift_card
    amount = get_new_gift_card_number(10)
    browser.text_field(id: "gift_card_number_5").set amount
    gift_card_confirmation
    logout

    browser.goto "#{main_url}/login"
    login_platinum
    empty_cart_main_site
    searching_for_cookbook_main_site
    delivery_options

    platinum_points
    assert(
    browser.button(text: 'Place Order').exists?,
    'Expected to find <button> tag with text "Place Order" but did not.'
    )
    empty_cart_main_site
    logout
  end

  def test_form_of_payment_failure_cases
    sigin_up_for_failure_cases
    searching_for_rings
    credit_card_and_address_setting_for_failure_cases
    browser.text_field(id: "card_number").set '1111111111111111'
    browser.button(class: "btn btn-primary pull-right btn-continue js-submit-btn").click
    assert_equal(browser.div(class: 'flash error').text, "There was a problem with your payment information. Please check your information and try again.")
    sleep(1)
    goto '/cart'
    assert_equal("#{base_url}/cart", browser.url, "incorrect location")
    browser.a(class: "btn btn-primary btn-lg pull-right btn-checkout").click
    assert_equal("#{base_url}/checkout/address", browser.url, "incorrect location")
    browser.button(class: "btn btn-primary pull-right js-form-validate btn-continue").click
    assert_equal("#{base_url}/checkout/delivery", browser.url, "incorrect location")
    browser.button(class: "btn btn-primary pull-right btn-continue").click
    assert_equal("#{base_url}/checkout/payment", browser.url, "incorrect location")
    apply_gift_card
    browser.text_field(id: "gift_card_number_5").set Faker::Number.number(8)
    browser.button(class: "btn btn-primary js-apply-gift-card-btn").click
    assert(
    browser.strong(text: '1 error prohibited this record from being saved').exists?,
    'Expected to find <strong> tag with text "1 error prohibited this record from being saved" but did not.'
    )
    logout
   
    sigin_up
    searching_for_rings
    failure_cases_for_gg
    amount = get_new_gift_card_number(1)
    browser.text_field(id: "gift_card_number_5").set amount
    browser.button(class: "btn btn-primary js-apply-gift-card-btn").click
    sum = browser.span(id: "summary-order-total").text 
    sum = sum.gsub(/[^0-9\.]/, '').to_f

    apply_gift_card
    browser.text_field(id: "gift_card_number_5").set amount
    browser.button(class: "btn btn-primary js-apply-gift-card-btn").click
    sum2 = browser.span(id: "summary-order-total").text 
    sum2 = sum2.gsub(/[^0-9\.]/, '').to_f
    assert_equal(sum, sum2, "You entered valid gift card twice, and it applayed, its bad!")
    
    browser.button(class: "btn btn-primary pull-right btn-continue js-submit-btn").click
    assert(
    browser.strong(text: '1 error prohibited this record from being saved').exists?,
    'Expected to find <strong> tag with text "1 error prohibited this record from being saved" but did not.'
    )
    logout
    
    sigin_up
    searching_for_rings
    failure_cases_for_gg
    browser.text_field(id: "gift_card_number_5").set amount
    browser.button(class: "btn btn-primary js-apply-gift-card-btn").click
    assert_equal(browser.div(class: "flash success").text, "Gift Card was successfully applied to the order.")
    logout
  end

  private

  def failure_cases_for_gg
    browser.span(text: "7.5").click
    browser.button(text: "Add To Cart").click
    assert_equal("#{base_url}/item_added", browser.url, "incorrect location")
    browser.a(class: "btn btn-primary text-uppercase continue").click
    assert_equal("#{base_url}/cart", browser.url, "incorrect location")
    browser.a(class: "btn btn-primary btn-lg pull-right btn-checkout").click
    assert_equal("#{base_url}/checkout/address", browser.url, "incorrect location")
    browser.text_field(name:"order[bill_address_attributes][firstname]").set ::Faker::Name.first_name 
    browser.text_field(name:"order[bill_address_attributes][lastname]").set ::Faker::Name.name
    browser.text_field(name:"order[bill_address_attributes][address1]").set ::Faker::Address.street_address
    browser.text_field(name:"order[bill_address_attributes][address2]").set ::Faker::Address.secondary_address
    browser.text_field(name:"order[bill_address_attributes][zipcode]").set ::Faker::Address.zip_code
    browser.text_field(name:"order[bill_address_attributes][city]").set ::Faker::Address.city
    browser.select(name:"order[bill_address_attributes][state_id]").select 'Colorado'
    browser.text_field(name:"order[bill_address_attributes][phone]").set Faker::PhoneNumber.cell_phone
    browser.label(text: "Use Billing Address").click
    browser.button(class: "btn btn-primary pull-right js-form-validate btn-continue").click
    assert_equal("#{base_url}/checkout/address", browser.url, "incorrect location")
    browser.button(class: "btn btn-primary pull-right js-form-validate btn-continue").click
    assert_equal("#{base_url}/checkout/delivery", browser.url, "incorrect location")
    browser.button(class: "btn btn-primary pull-right btn-continue").click
    assert_equal("#{base_url}/checkout/payment", browser.url, "incorrect location")
    apply_gift_card
  end

  def searching_for_rings
    browser.text_field(name: "keywords").set 'Heavenly Flower CTR Ring'
    browser.input(class: "btn btn-primary img-responsive js-search-button").click
    assert(browser.h1(text: "Search results for 'Heavenly Flower CTR Ring'").exists?)
    browser.img(alt: "Heavenly Flower CTR Ring").click
  end

def finding_for_rings
    browser.text_field(name: "keywords").set 'Heavenly Flower CTR Ring'
    browser.input(class: "btn btn-primary img-responsive js-search-button").click
    assert(browser.h1(text: "Search results for 'Heavenly Flower CTR Ring'").exists?)
    browser.img(alt: "Heavenly Flower CTR Ring").click
  end

  def from_cart_to_payment
    browser.button(text: "Add To Cart").click
    assert_equal("#{base_url}/item_added", browser.url, "incorrect location")
    browser.a(class: "btn btn-primary text-uppercase continue").click
    assert_equal("#{base_url}/cart", browser.url, "incorrect location")
    browser.a(class: "btn btn-primary btn-lg pull-right btn-checkout").click
    assert_equal("#{base_url}/checkout/address", browser.url, "incorrect location")
    browser.button(class: "btn btn-primary pull-right js-form-validate btn-continue").click
    assert_equal("#{base_url}/checkout/delivery", browser.url, "incorrect location")
    browser.button(class: "btn btn-primary pull-right btn-continue").click
    assert_equal("#{base_url}/checkout/payment", browser.url, "incorrect location")
  end

  def confirmation_of_oder
    browser.button(class: "btn btn-primary pull-right btn-continue js-submit-btn").click
    assert_equal("#{base_url}/checkout/confirm", browser.url, "incorrect location")
    browser.button(class: "btn btn-primary btn-lg pull-right btn-continue").click
    assert_equal(browser.div(class: 'flash notice').text, "Thank You. We have successfully received your order.")
  end
  
  def pushing_ring_size_nine
    browser.span(text: "9").click
  end

  def gift_card_confirmation
    browser.button(class: "btn btn-primary js-apply-gift-card-btn").click
    assert_equal("#{base_url}/checkout/confirm", browser.url, "incorrect location")
    browser.button(class: "btn btn-primary btn-lg pull-right btn-continue").click
    assert_equal(browser.div(class: 'flash notice').text, "Thank You. We have successfully received your order.")
  end     

  def apply_gift_card
    browser.div(text: "Apply a Deseret Book Gift Card").click
    sleep(2) #needs to wait for animation
  end

  def sigin_up
    goto  '/signup' 
    browser.text_field(name: "spree_user[email]").set ::Faker::Internet.safe_email
    browser.text_field(name: "spree_user[first_name]").set ::Faker::Name.first_name
    browser.text_field(name: "spree_user[last_name]").set ::Faker::Name.last_name
    browser.text_field(name: "spree_user[password]").set 'test123'
    browser.text_field(name: "spree_user[password_confirmation]").set 'test123'
    browser.input(name: "commit").click
    assert(browser.div(class: 'flash notice').present?)
  end

  def credit_card_and_address_setting
    browser.span(text: "7.5").click
    browser.button(text: "Add To Cart").click
    assert_equal("#{base_url}/item_added", browser.url, "incorrect location")
    browser.a(class: "btn btn-primary text-uppercase continue").click
    assert_equal("#{base_url}/cart", browser.url, "incorrect location")
    #browser.a(text: "Close").click
    browser.a(class: "btn btn-primary btn-lg pull-right btn-checkout").click
    assert_equal("#{base_url}/checkout/address", browser.url, "incorrect location")
    browser.text_field(name:"order[bill_address_attributes][firstname]").set ::Faker::Name.first_name
    browser.text_field(name:"order[bill_address_attributes][lastname]").set ::Faker::Name.last_name
    browser.text_field(name:"order[bill_address_attributes][address1]").set ::Faker::Address.street_address
    browser.text_field(name:"order[bill_address_attributes][address2]").set ::Faker::Address.secondary_address
    browser.text_field(name:"order[bill_address_attributes][zipcode]").set ::Faker::Address.zip_code
    browser.text_field(name:"order[bill_address_attributes][city]").set ::Faker::Address.city
    browser.select(name:"order[bill_address_attributes][state_id]").select 'Colorado'
    browser.text_field(name:"order[bill_address_attributes][phone]").set ::Faker::PhoneNumber.cell_phone
    browser.label(text: "Use Billing Address").click
    browser.button(class: "btn btn-primary pull-right js-form-validate btn-continue").click
    assert_equal("#{base_url}/checkout/address", browser.url, "incorrect location")
    browser.button(class: "btn btn-primary pull-right js-form-validate btn-continue").click
    assert_equal("#{base_url}/checkout/delivery", browser.url, "incorrect location")
    browser.button(class: "btn btn-primary pull-right btn-continue").click
    assert_equal("#{base_url}/checkout/payment", browser.url, "incorrect location")
    browser.text_field(id: "card_code").set '555'
    browser.select(id: "date_month").select '1 - January'
    browser.select(id: "date_year").select '2018'
  end

  def credit_card_and_address_setting_for_failure_cases
    browser.span(text: "7.5").click
    browser.button(text: "Add To Cart").click
    assert_equal("#{base_url}/item_added", browser.url, "incorrect location")
    browser.a(class: "btn btn-primary text-uppercase continue").click
    assert_equal("#{base_url}/cart", browser.url, "incorrect location")
    browser.a(class: "btn btn-primary btn-lg pull-right btn-checkout").click
    assert_equal("#{base_url}/checkout/address", browser.url, "incorrect location")
    browser.text_field(name:"order[bill_address_attributes][firstname]").set ::Faker::Name.first_name 
    browser.text_field(name:"order[bill_address_attributes][lastname]").set ::Faker::Name.name
    browser.text_field(name:"order[bill_address_attributes][address1]").set ::Faker::Address.street_address
    browser.text_field(name:"order[bill_address_attributes][address2]").set ::Faker::Address.secondary_address
    browser.text_field(name:"order[bill_address_attributes][zipcode]").set ::Faker::Address.zip_code
    browser.text_field(name:"order[bill_address_attributes][city]").set ::Faker::Address.city
    browser.select(name:"order[bill_address_attributes][state_id]").select 'Colorado'
    browser.text_field(name:"order[bill_address_attributes][phone]").set Faker::PhoneNumber.cell_phone
    browser.label(text: "Use Billing Address").click
    browser.button(class: "btn btn-primary pull-right js-form-validate btn-continue").click
    assert_equal("#{base_url}/checkout/address", browser.url, "incorrect location")
    browser.button(class: "btn btn-primary pull-right js-form-validate btn-continue").click
    assert_equal("#{base_url}/checkout/delivery", browser.url, "incorrect location")
    browser.button(class: "btn btn-primary pull-right btn-continue").click
    assert_equal("#{base_url}/checkout/payment", browser.url, "incorrect location")
    browser.text_field(id: "name_on_card_2").set 'test user'
    browser.text_field(id: "card_code").set '555'
    browser.select(id: "date_month").select '1 - January'
    browser.select(id: "date_year").select '2018'
  end

  def sigin_up_for_failure_cases
    goto  '/signup' 
    browser.text_field(name: "spree_user[email]").set ::Faker::Internet.safe_email
    browser.text_field(name: "spree_user[first_name]").set ::Faker::Name.first_name
    browser.text_field(name: "spree_user[last_name]").set ::Faker::Name.name
    browser.text_field(name: "spree_user[password]").set 'test123'
    browser.text_field(name: "spree_user[password_confirmation]").set 'test123'
    browser.input(name: "commit").click
    assert(browser.div(class: 'flash notice').present?)
  end

  def login_platinum
    browser.text_field(name: "spree_user[email]").set 'platinumtest@deseretbook.com'
    browser.text_field(name: "spree_user[password]").set 'Fzxtuw;.?r\+Z5{]ME'
    browser.button(name: "commit").click 
  end
 
  def searching_for_cookbook_main_site
    browser.text_field(name: "keywords").set 'Lion House Bakery Cookbook'
    browser.input(class: "btn btn-primary img-responsive js-search-button").click
    assert(browser.h1(text: "Search results for 'Lion House Bakery Cookbook'").exists?)
    browser.img(alt: "Lion House Bakery Cookbook").click
    assert_equal("#{main_url}/p/lion-house-bakery-cookbook-70083?variant_id=29484-hardcover", browser.url, "incorrect location")
    browser.button(class: "btn btn-lg btn-primary btn-block btn-add-to-cart").click
    assert_equal("#{main_url}/item_added", browser.url, "incorrect location")
    browser.a(text: "Proceed to Checkout").click
    assert_equal("#{main_url}/cart", browser.url, "incorrect location")
    browser.a(class: "btn btn-primary btn-lg pull-right btn-checkout").click
  end

  def delivery_options
    assert_equal("#{main_url}/checkout/address", browser.url, "incorrect location")
    browser.button(class: "btn btn-primary pull-right js-form-validate btn-continue").click
    assert_equal("#{main_url}/checkout/delivery", browser.url, "incorrect location")
    browser.button(class: "btn btn-primary pull-right btn-continue").click
    assert_equal("#{main_url}/checkout/payment", browser.url, "incorrect location")
  end

  def finding_sum
    sum = browser.span(id: "summary-order-total").text 
    sum = sum.gsub(/[^0-9\.]/, '').to_f
    sum = (sum - 10)
    amount = get_new_gift_card_number(sum)  
    browser.text_field(id: "gift_card_number_5").set amount
    browser.button(class: "btn btn-primary js-apply-gift-card-btn").click
  end

  def platinum_points
    browser.img(alt: "Platinum").click
    sleep(1) #animation
    sum = browser.span(id: "summary-order-total").text 
    sum = sum.gsub(/[^0-9]/, '').to_i
    #puts "#{sum}"
    browser.text_field(id: "order_platinum_points").set sum
    browser.button(class: "btn btn-primary js-apply-platinum-points-btn").click
    assert_equal("#{main_url}/checkout/confirm", browser.url, "incorrect location")
  end

  def empty_cart_main_site
    browser.goto "#{main_url}/cart"
    browser.input(value: "Empty Cart").click
  end

end
