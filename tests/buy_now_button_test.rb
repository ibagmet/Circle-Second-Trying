require 'test_helper'
require 'faker'

class BuyNowButtonTest < NibleyTest
	include BaseCheckoutHelper
	include StandardCheckoutHelper

	def test_buy_now_button

		goto  '/signup'	
	 		browser.text_field(name: "spree_user[email]").set ::Faker::Internet.safe_email
	        browser.text_field(name: "spree_user[first_name]").set 'test_name'
	        browser.text_field(name: "spree_user[last_name]").set 'test_last_name'
			browser.text_field(name: "spree_user[password]").set 'test123'
	        browser.text_field(name: "spree_user[password_confirmation]").set 'test123'
	        browser.input(name: "commit").click
            assert(browser.div(class: 'flash notice').present?)
            goto '/t/ebooks/history'
			browser.a(text: "L. Tom Perry, An Uncommon L...").click
			assert_equal("#{base_url}/p/l-tom-perry-uncommon-life-years-preparation-1922-1976-lee-87417?taxon_id=434&variant_id=9020-hardcover", browser.url, "incorrect location")
			browser.span(text: "eBook").click
			browser.button(text: "Add To Cart").click
			assert_equal("#{base_url}/item_added", browser.url, "incorrect location")
			browser.a(text: "Proceed to Checkout").click
			assert_equal("#{base_url}/cart", browser.url, "incorrect location")
			assert(
					browser.div(text: 'Shopping Cart').exists?,
					'Expected to find <strong> tag with text "Shopping Cart" but did not.'
				)
			browser.a(text: "Checkout").click
			assert_equal("#{base_url}/checkout/address", browser.url, "incorrect location")
			browser.input(name: "order[use_billing]").click
			browser.text_field(name: "order[bill_address_attributes][firstname]").set ::Faker::Name.first_name 
			browser.text_field(name: "order[bill_address_attributes][lastname]").set ::Faker::Name.last_name 
			browser.text_field(name: "order[bill_address_attributes][address1]").set ::Faker::Address.street_address
			browser.text_field(name: "order[bill_address_attributes][address2]").set ::Faker::Address.secondary_address
			browser.text_field(name: "order[bill_address_attributes][city]").set ::Faker::Address.city
			browser.select_list(name: "order[bill_address_attributes][state_id]").select 'California'
			browser.text_field(name: "order[bill_address_attributes][zipcode]").set ::Faker::Address.zip_code
			browser.text_field(name: "order[bill_address_attributes][phone]").set ::Faker::PhoneNumber.cell_phone
			browser.button(class: "btn btn-primary pull-right js-form-validate btn-continue").click
			assert_equal("#{base_url}/checkout/address", browser.url, "incorrect location")
			browser.button(class: "btn btn-primary pull-right js-form-validate btn-continue").click
			assert_equal("#{base_url}/checkout/payment", browser.url, "incorrect location")
			browser.text_field(id: "name_on_card_2").set 'test user'
			browser.text_field(id: "card_number").set '4111111111111111'
			browser.text_field(id: "card_code").set '555'
			browser.select(id: "date_month").select '1 - January'
			browser.select(id: "date_year").select '2018'
			browser.button(class: "btn btn-primary pull-right btn-continue js-submit-btn").click
			assert_equal("#{base_url}/checkout/confirm", browser.url, "incorrect location")
			browser.button(class: "btn btn-primary btn-lg pull-right btn-continue").click
            assert_equal(browser.div(class: 'flash notice').text, "Thank You. We have successfully received your order.")
            browser.a(class: "btn btn-link btn-left-justify-text").click
			goto '/t/ebooks/biography-slash-autobiography'
			browser.a(text: "To the Rescue: The Biograph...").click
			assert_equal("#{base_url}/p/rescue-biography-thomas-s-monson-heidi-swinton-74648?taxon_id=394&variant_id=24243-audiobook-cd-", browser.url, "incorrect location")
			browser.span(text: "eBook").click
			browser.a(class: "btn btn-lg btn-primary btn-block btn-buy-now text-uppercase").exists?
			browser.a(class: "btn btn-lg btn-primary btn-block btn-buy-now text-uppercase").click
			assert_equal("#{base_url}/checkout/confirm", browser.url, "incorrect location")
			browser.button(class: "btn btn-primary btn-lg pull-right btn-continue").click
		    logout
	
	end
end
