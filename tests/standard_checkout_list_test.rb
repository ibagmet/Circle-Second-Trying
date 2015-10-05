require 'test_helper'
require 'faker'

class StandardCheckoutListTest < NibleyTest
  include GiftCardHelper

  def test_guest_checkout_physical_item
    empty_cart_t
    searching_for_dining
    billing_address_form
    delivery_options
    and_credit_card
    confirmation_of_oder
    logout
    
    searching_for_dining
    billing_address_form
    delivery_options   
    and_gift_card
    gift_card_confirmation
    logout

    searching_for_dining
    billing_address_form
    delivery_options
    and_gift_card_less_amount
    and_credit_card
    confirmation_of_oder
    logout

    searching_for_dining_with_more_amount
    billing_address_form
    delivery_options
    and_gift_card
    and_gift_card_number_two
    gift_card_confirmation
    logout

    searching_for_dining_with_more_amount
    billing_address_form
    delivery_options  
    and_gift_card_less_amount
    and_gift_card_number_two
    and_credit_card
    confirmation_of_oder
    logout

    searching_for_dining_with_more_amount
    billing_address_form
    delivery_options
    and_gift_card_less_amount
    and_gift_card_number_two
    and_gift_card_number_three
    gift_card_confirmation
    logout
  end
  
  def test_guest_checkout_digital_item
    empty_cart_t
    searching_for_dining_digital
    billing_address_form
    and_credit_card
    confirmation_of_oder
    logout
    
    searching_for_dining_digital
    billing_address_form
    and_gift_card
    gift_card_confirmation
    logout

    searching_for_dining_digital
    billing_address_form
    and_gift_card_less_amount
    and_credit_card
    confirmation_of_oder
    logout

    searching_for_dining_with_more_amount_digital
    procced_to_checkout
    billing_address_form
    and_gift_card
    and_gift_card_number_two
    gift_card_confirmation
    logout

    searching_for_dining_with_more_amount_digital
    procced_to_checkout
    billing_address_form
    and_gift_card
    and_gift_card_less_amount
    and_credit_card
    confirmation_of_oder
    logout

    searching_for_dining_with_more_amount_digital
    searching_for_God_Remembered_Me_digital
    procced_to_checkout
    billing_address_form
    and_gift_card_less_amount
    and_gift_card_number_two
    and_gift_card_number_three
    gift_card_confirmation
    logout
  end

  def test_guest_checkout_physical_and_digital_items
    empty_cart_t
    
    searching_for_dining_and_digital
    procced_to_checkout
    billing_address_form
    delivery_options
    and_credit_card
    confirmation_of_oder
    logout

    searching_for_dining_and_digital
    procced_to_checkout
    billing_address_form
    delivery_options
    and_gift_card_number_one
    gift_card_confirmation
    logout

    searching_for_dining_and_digital
    procced_to_checkout
    billing_address_form
    delivery_options
    and_gift_card_less_amount
    and_credit_card
    confirmation_of_oder
    logout

    searching_for_dining_and_digital
    procced_to_checkout
    billing_address_form
    delivery_options
    and_gift_card
    and_gift_card_number_two
    gift_card_confirmation
    logout

    searching_for_dining_and_digital
    procced_to_checkout
    billing_address_form
    delivery_options
    and_gift_card_less_amount
    and_gift_card_number_two
    and_credit_card
    confirmation_of_oder
    logout

    searching_for_dining_and_digital
    procced_to_checkout
    billing_address_form
    delivery_options
    and_gift_card_less_amount
    and_gift_card_number_two
    and_gift_card_number_three
    gift_card_confirmation
    logout
  end

  def test_checkout_physical_item_login_before_checkout
    sigin_up
    empty_cart_t
    searching_for_dining_login
    billing_address_form
    delivery_options
    and_credit_card
    confirmation_of_oder
    logout
    
    sigin_up
    searching_for_dining_login
    billing_address_form
    delivery_options
    and_gift_card
    gift_card_confirmation
    logout

    sigin_up
    searching_for_dining_login
    billing_address_form
    delivery_options
    and_gift_card_less_amount
    and_credit_card
    confirmation_of_oder
    logout

    sigin_up
    searching_for_dining_login
    billing_address_form
    delivery_options
    and_gift_card_less_amount
    and_gift_card_number_three
    gift_card_confirmation
    logout

    sigin_up
    searching_for_dining_with_more_amount_login
    billing_address_form
    delivery_options
    and_gift_card_less_amount
    and_gift_card_number_two
    and_credit_card
    confirmation_of_oder
    logout

    sigin_up
    searching_for_dining_with_more_amount_login
    billing_address_form
    delivery_options
    and_gift_card_less_amount
    and_gift_card_number_two
    and_gift_card_number_three
    gift_card_confirmation
    logout
  end

  def test_checkout_digital_item_login_before_checkout
    sigin_up
    empty_cart_t
    searching_for_dining_digital_login
    billing_address_form
    and_credit_card
    confirmation_of_oder
    logout
    
    sigin_up
    searching_for_dining_digital_login
    billing_address_form
    and_gift_card
    gift_card_confirmation
    logout

    sigin_up
    searching_for_dining_digital_login
    billing_address_form
    and_gift_card_less_amount
    and_credit_card
    confirmation_of_oder
    logout
    
    sigin_up
    searching_for_dining_with_more_amount_digital
    procced_to_checkout_login
    billing_address_form
    and_gift_card
    and_gift_card_number_two
    gift_card_confirmation
    logout

    sigin_up
    searching_for_dining_with_more_amount_digital
    searching_for_God_Remembered_Me_digital
    procced_to_checkout_login
    billing_address_form
    and_gift_card_less_amount
    and_gift_card_number_two
    and_credit_card
    confirmation_of_oder
    logout

    sigin_up
    searching_for_dining_with_more_amount_digital
    searching_for_God_Remembered_Me_digital
    procced_to_checkout_login
    billing_address_form
    and_gift_card_less_amount
    and_gift_card_number_two
    and_gift_card_number_three
    gift_card_confirmation
    logout
  end
  
  def test_checkout_physical_and_digital_items_login
    sigin_up
    empty_cart_t
    searching_for_dining_and_digital
    procced_to_checkout_login
    billing_address_form
    delivery_options
    and_credit_card
    confirmation_of_oder
    logout

    sigin_up
    searching_for_dining_and_digital
    procced_to_checkout_login
    billing_address_form
    delivery_options
    and_gift_card_number_one
    gift_card_confirmation
    logout
    
    sigin_up
    searching_for_dining_and_digital
    procced_to_checkout_login
    billing_address_form
    delivery_options
    and_gift_card_less_amount
    and_credit_card
    confirmation_of_oder
    logout

    sigin_up
    searching_for_dining_and_digital
    procced_to_checkout_login
    billing_address_form
    delivery_options
    and_gift_card
    and_gift_card_number_two
    gift_card_confirmation
    logout

    sigin_up
    searching_for_dining_and_digital
    procced_to_checkout_login
    billing_address_form
    delivery_options
    and_gift_card_less_amount
    and_gift_card_number_two
    and_credit_card
    confirmation_of_oder
    logout

    sigin_up
    searching_for_dining_and_digital
    procced_to_checkout_login
    billing_address_form
    delivery_options
    and_gift_card_less_amount
    and_gift_card_number_two
    and_gift_card_number_three
    gift_card_confirmation
    logout
  end

  private

  def sigin_up
    goto  '/signup' 
    browser.text_field(name: "spree_user[email]").set ::Faker::Internet.safe_email
    browser.text_field(name: "spree_user[first_name]").set 'test_name'
    browser.text_field(name: "spree_user[last_name]").set 'ValidLast'
    browser.text_field(name: "spree_user[password]").set 'test123'
    browser.text_field(name: "spree_user[password_confirmation]").set 'test123'
    browser.input(name: "commit").click
    assert(browser.div(class: 'flash notice').present?)
  end
    
  def searching_for_dining_login
    browser.text_field(name: "keywords").set 'Dining with the Prophets'
    browser.input(class: "btn btn-primary img-responsive js-search-button").click
    assert(browser.h1(text: "Search results for 'Dining with the Prophets'").exists?)
    browser.img(alt: "Dining with the Prophets").click
    assert_equal("#{base_url}/p/dining-prophets-lion-house-92869?variant_id=2692-hardcover", browser.url, "incorrect location")
    browser.button(class: "btn btn-lg btn-primary btn-block btn-add-to-cart").click
    assert_equal("#{base_url}/item_added", browser.url, "incorrect location")
    browser.a(text: "Proceed to Checkout").click
    assert_equal("#{base_url}/cart", browser.url, "incorrect location")
    browser.a(class: "btn btn-primary btn-lg pull-right btn-checkout").click
  end

  def searching_for_dining_with_more_amount_login
    browser.text_field(name: "keywords").set 'Dining with the Prophets'
    browser.input(class: "btn btn-primary img-responsive js-search-button").click
    assert(browser.h1(text: "Search results for 'Dining with the Prophets'").exists?)
    browser.img(alt: "Dining with the Prophets").click
    assert_equal("#{base_url}/p/dining-prophets-lion-house-92869?variant_id=2692-hardcover", browser.url, "incorrect location")
    browser.button(class: "btn btn-lg btn-primary btn-block btn-add-to-cart").click
    assert_equal("#{base_url}/item_added", browser.url, "incorrect location")
    
    browser.text_field(name: "keywords").set 'The Romney Family Table'
    browser.input(class: "btn btn-primary img-responsive js-search-button").click
    assert(browser.h1(text: "Search results for 'The Romney Family Table'").exists?)
    browser.img(alt: "The Romney Family Table").click
    assert_equal("#{base_url}/p/romney-family-table-ann-89648?variant_id=6324-hardcover", browser.url, "incorrect location")
    browser.button(class: "btn btn-lg btn-primary btn-block btn-add-to-cart").click
    assert_equal("#{base_url}/item_added", browser.url, "incorrect location")
    browser.a(text: "Proceed to Checkout").click
    assert_equal("#{base_url}/cart", browser.url, "incorrect location")
    browser.a(class: "btn btn-primary btn-lg pull-right btn-checkout").click
  end

  def searching_for_dining
    browser.text_field(name: "keywords").set 'Dining with the Prophets'
    browser.input(class: "btn btn-primary img-responsive js-search-button").click
    assert(browser.h1(text: "Search results for 'Dining with the Prophets'").exists?)
    browser.img(alt: "Dining with the Prophets").click
    assert_equal("#{base_url}/p/dining-prophets-lion-house-92869?variant_id=2692-hardcover", browser.url, "incorrect location")
    browser.button(class: "btn btn-lg btn-primary btn-block btn-add-to-cart").click
    assert_equal("#{base_url}/item_added", browser.url, "incorrect location")
    browser.a(text: "Proceed to Checkout").click
    assert_equal("#{base_url}/cart", browser.url, "incorrect location")
    browser.a(class: "btn btn-primary btn-lg pull-right btn-checkout").click
    assert_equal("#{base_url}/checkout/registration", browser.url, "incorrect location")
    browser.a(text: "Create a new account").click
    assert_equal("#{base_url}/signup", browser.url, "incorrect location")
    browser.text_field(name: "spree_user[email]").set ::Faker::Internet.email
    browser.text_field(name: "spree_user[first_name]").set 'test_name'
    browser.text_field(name: "spree_user[last_name]").set 'test_last_name'
    browser.text_field(name: "spree_user[password]").set 'test123'
    browser.text_field(name: "spree_user[password_confirmation]").set 'test123'
    browser.input(name: "commit").click
    assert(browser.div(class: 'flash notice').present?)
  end

  def searching_for_dining_digital_login
    browser.text_field(name: "keywords").set 'Dining with the Prophets'
    browser.input(class: "btn btn-primary img-responsive js-search-button").click
    assert(browser.h1(text: "Search results for 'Dining with the Prophets'").exists?)
    browser.img(alt: "Dining with the Prophets").click
    assert_equal("#{base_url}/p/dining-prophets-lion-house-92869?variant_id=2692-hardcover", browser.url, "incorrect location")
    browser.span(text: "eBook").click
    browser.button(class: "btn btn-lg btn-primary btn-block btn-add-to-cart").click
    assert_equal("#{base_url}/item_added", browser.url, "incorrect location")
    browser.a(text: "Proceed to Checkout").click
    assert_equal("#{base_url}/cart", browser.url, "incorrect location")
    browser.a(class: "btn btn-primary btn-lg pull-right btn-checkout").click
  end

  def searching_for_dining_digital
    browser.text_field(name: "keywords").set 'Dining with the Prophets'
    browser.input(class: "btn btn-primary img-responsive js-search-button").click
    assert(browser.h1(text: "Search results for 'Dining with the Prophets'").exists?)
    browser.img(alt: "Dining with the Prophets").click
    assert_equal("#{base_url}/p/dining-prophets-lion-house-92869?variant_id=2692-hardcover", browser.url, "incorrect location")
    browser.span(text: "eBook").click
    browser.button(class: "btn btn-lg btn-primary btn-block btn-add-to-cart").click
    assert_equal("#{base_url}/item_added", browser.url, "incorrect location")
    browser.a(text: "Proceed to Checkout").click
    assert_equal("#{base_url}/cart", browser.url, "incorrect location")
    browser.a(class: "btn btn-primary btn-lg pull-right btn-checkout").click
    assert_equal("#{base_url}/checkout/registration", browser.url, "incorrect location")
    browser.a(text: "Create a new account").click
    assert_equal("#{base_url}/signup", browser.url, "incorrect location")
    browser.text_field(name: "spree_user[email]").set ::Faker::Internet.email
    browser.text_field(name: "spree_user[first_name]").set 'test_name'
    browser.text_field(name: "spree_user[last_name]").set 'test_last_name'
    browser.text_field(name: "spree_user[password]").set 'test123'
    browser.text_field(name: "spree_user[password_confirmation]").set 'test123'
    browser.input(name: "commit").click
    assert(browser.div(class: 'flash notice').present?)
    browser.a(class: "btn btn-primary btn-lg pull-right btn-checkout").click
  end

  def searching_for_dining_with_more_amount_digital
    browser.text_field(name: "keywords").set 'Dining with the Prophets'
    browser.input(class: "btn btn-primary img-responsive js-search-button").click
    assert(browser.h1(text: "Search results for 'Dining with the Prophets'").exists?)
    browser.img(alt: "Dining with the Prophets").click
    assert_equal("#{base_url}/p/dining-prophets-lion-house-92869?variant_id=2692-hardcover", browser.url, "incorrect location")
    browser.span(text: "eBook").click
    browser.button(class: "btn btn-lg btn-primary btn-block btn-add-to-cart").click
    assert_equal("#{base_url}/item_added", browser.url, "incorrect location")
    
    browser.text_field(name: "keywords").set 'The Romney Family Table'
    browser.input(class: "btn btn-primary img-responsive js-search-button").click
    assert(browser.h1(text: "Search results for 'The Romney Family Table'").exists?)
    browser.img(alt: "The Romney Family Table").click
    browser.span(text: "eBook").click
    assert_equal("#{base_url}/p/romney-family-table-ann-89648?variant_id=7330-ebook", browser.url, "incorrect location")
    browser.button(class: "btn btn-lg btn-primary btn-block btn-add-to-cart").click
    assert_equal("#{base_url}/item_added", browser.url, "incorrect location")
  end

  def procced_to_checkout_login
    browser.a(text: "Proceed to Checkout").click
    assert_equal("#{base_url}/cart", browser.url, "incorrect location")
    browser.a(class: "btn btn-primary btn-lg pull-right btn-checkout").click
  end

  def procced_to_checkout
    browser.a(text: "Proceed to Checkout").click
    assert_equal("#{base_url}/cart", browser.url, "incorrect location")
    browser.a(class: "btn btn-primary btn-lg pull-right btn-checkout").click
    assert_equal("#{base_url}/checkout/registration", browser.url, "incorrect location")
    browser.a(text: "Create a new account").click
    assert_equal("#{base_url}/signup", browser.url, "incorrect location")
    browser.text_field(name: "spree_user[email]").set ::Faker::Internet.email
    browser.text_field(name: "spree_user[first_name]").set 'test_name'
    browser.text_field(name: "spree_user[last_name]").set 'test_last_name'
    browser.text_field(name: "spree_user[password]").set 'test123'
    browser.text_field(name: "spree_user[password_confirmation]").set 'test123'
    browser.input(name: "commit").click
    assert(browser.div(class: 'flash notice').present?)
    browser.a(class: "btn btn-primary btn-lg pull-right btn-checkout").click
  end
  
  def searching_for_God_Remembered_Me_digital
    browser.text_field(name: "keywords").set 'God Remembered Me'
    browser.input(class: "btn btn-primary img-responsive js-search-button").click
    assert(browser.h1(text: "Search results for 'God Remembered Me'").exists?)
    browser.img(alt: "God Remembered Me").click
    assert_equal("#{base_url}/p/god-remembered-me-joseph-banks-88389?variant_id=9017-ebook", browser.url, "incorrect location")
    browser.button(class: "btn btn-lg btn-primary btn-block btn-add-to-cart").click
    assert_equal("#{base_url}/item_added", browser.url, "incorrect location")
  end

  def searching_for_dining_with_more_amount
    browser.text_field(name: "keywords").set 'Dining with the Prophets'
    browser.input(class: "btn btn-primary img-responsive js-search-button").click
    assert(browser.h1(text: "Search results for 'Dining with the Prophets'").exists?)
    browser.img(alt: "Dining with the Prophets").click
    assert_equal("#{base_url}/p/dining-prophets-lion-house-92869?variant_id=2692-hardcover", browser.url, "incorrect location")
    browser.button(class: "btn btn-lg btn-primary btn-block btn-add-to-cart").click
    assert_equal("#{base_url}/item_added", browser.url, "incorrect location")
    
    browser.text_field(name: "keywords").set 'The Romney Family Table'
    browser.input(class: "btn btn-primary img-responsive js-search-button").click
    assert(browser.h1(text: "Search results for 'The Romney Family Table'").exists?)
    browser.img(alt: "The Romney Family Table").click
    assert_equal("#{base_url}/p/romney-family-table-ann-89648?variant_id=6324-hardcover", browser.url, "incorrect location")
    browser.button(class: "btn btn-lg btn-primary btn-block btn-add-to-cart").click
    assert_equal("#{base_url}/item_added", browser.url, "incorrect location")

    browser.a(text: "Proceed to Checkout").click
    assert_equal("#{base_url}/cart", browser.url, "incorrect location")
    browser.a(class: "btn btn-primary btn-lg pull-right btn-checkout").click
    assert_equal("#{base_url}/checkout/registration", browser.url, "incorrect location")
    browser.a(text: "Create a new account").click
    assert_equal("#{base_url}/signup", browser.url, "incorrect location")
    browser.text_field(name: "spree_user[email]").set ::Faker::Internet.email
    browser.text_field(name: "spree_user[first_name]").set 'test_name'
    browser.text_field(name: "spree_user[last_name]").set 'test_last_name'
    browser.text_field(name: "spree_user[password]").set 'test123'
    browser.text_field(name: "spree_user[password_confirmation]").set 'test123'
    browser.input(name: "commit").click
    assert(browser.div(class: 'flash notice').present?)
  end

  def searching_for_dining_and_digital
    browser.text_field(name: "keywords").set 'Dining with the Prophets'
    browser.input(class: "btn btn-primary img-responsive js-search-button").click
    assert(browser.h1(text: "Search results for 'Dining with the Prophets'").exists?)
    browser.img(alt: "Dining with the Prophets").click
    assert_equal("#{base_url}/p/dining-prophets-lion-house-92869?variant_id=2692-hardcover", browser.url, "incorrect location")
    browser.span(text: "eBook").click
    browser.button(class: "btn btn-lg btn-primary btn-block btn-add-to-cart").click
    assert_equal("#{base_url}/item_added", browser.url, "incorrect location")
    
    browser.text_field(name: "keywords").set 'The Romney Family Table'
    browser.input(class: "btn btn-primary img-responsive js-search-button").click
    assert(browser.h1(text: "Search results for 'The Romney Family Table'").exists?)
    browser.img(alt: "The Romney Family Table").click
    assert_equal("#{base_url}/p/romney-family-table-ann-89648?variant_id=6324-hardcover", browser.url, "incorrect location")
    browser.button(class: "btn btn-lg btn-primary btn-block btn-add-to-cart").click
    assert_equal("#{base_url}/item_added", browser.url, "incorrect location")
  end

  def billing_address_form
    assert_equal("#{base_url}/checkout/address", browser.url, "incorrect location")
    browser.text_field(name:"order[bill_address_attributes][firstname]").set ::Faker::Name.first_name  
    browser.text_field(name:"order[bill_address_attributes][lastname]").set ::Faker::Name.name
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
  end

  def delivery_options
    assert_equal("#{base_url}/checkout/delivery", browser.url, "incorrect location")
    browser.button(class: "btn btn-primary pull-right btn-continue").click
    assert_equal("#{base_url}/checkout/payment", browser.url, "incorrect location")
  end

  def and_credit_card
    browser.text_field(id: "name_on_card_2").set 'test user'
    browser.text_field(id: "card_code").set '555'
    browser.select(id: "date_month").select '1 - January'
    browser.select(id: "date_year").select '2018'
    browser.text_field(id: "card_number").set '4111111111111111'
    browser.button(class: "btn btn-primary pull-right btn-continue js-submit-btn").click
  end

  def and_gift_card
    browser.div(text: "Apply a Deseret Book Gift Card").click
    sleep(1) #for_aniamtion
    amount = get_new_gift_card_number(13.48)
    browser.text_field(id: "gift_card_number_5").set amount
    browser.button(class: "btn btn-primary js-apply-gift-card-btn").click
  end

  def and_gift_card_number_two
    browser.div(text: "Apply a Deseret Book Gift Card").click
    sleep(1) #for_aniamtion
    amount = get_new_gift_card_number(16.50)
    browser.text_field(id: "gift_card_number_5").set amount
    browser.button(class: "btn btn-primary js-apply-gift-card-btn").click
    sleep(2)
  end

  def and_gift_card_number_three
    browser.div(text: "Apply a Deseret Book Gift Card").click
    sleep(1) #for_aniamtion
    amount = get_new_gift_card_number(2.98)
    browser.text_field(id: "gift_card_number_5").set amount
    browser.button(class: "btn btn-primary js-apply-gift-card-btn").click
  end

  def and_gift_card_number_one
    browser.div(text: "Apply a Deseret Book Gift Card").click
    sleep(1) #for_aniamtion
    amount = get_new_gift_card_number(29.98)
    browser.text_field(id: "gift_card_number_5").set amount
    browser.button(class: "btn btn-primary js-apply-gift-card-btn").click
  end

  def and_gift_card_less_amount
    browser.div(text: "Apply a Deseret Book Gift Card").click
    sleep(1) #for_aniamtion
    amount = get_new_gift_card_number(10.50)
    browser.text_field(id: "gift_card_number_5").set amount
    browser.button(class: "btn btn-primary js-apply-gift-card-btn").click
  end

  def gift_card_confirmation
    assert_equal("#{base_url}/checkout/confirm", browser.url, "incorrect location")
    browser.button(class: "btn btn-primary btn-lg pull-right btn-continue").click
    assert_equal(browser.div(class: 'flash notice').text, "Thank You. We have successfully received your order.")
  end    

  def confirmation_of_oder
    assert_equal("#{base_url}/checkout/confirm", browser.url, "incorrect location")
    browser.button(class: "btn btn-primary btn-lg pull-right btn-continue").click
    assert_equal(browser.div(class: 'flash notice').text, "Thank You. We have successfully received your order.")
  end

  def empty_cart_t
    goto  '/cart'
    browser.input(value: "Empty Cart").click
  end

end
