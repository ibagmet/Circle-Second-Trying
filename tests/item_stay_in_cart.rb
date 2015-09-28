require 'test_helper'
require 'faker'

class ItemStayInCart < NibleyTest

	def test_item_in_cart

		goto  '/signup'	
	 		email_new = ::Faker::Internet.safe_email
	 		browser.text_field(name: "spree_user[email]").set email_new
	        browser.text_field(name: "spree_user[first_name]").set 'test_name'
	        browser.text_field(name: "spree_user[last_name]").set 'test_last_name'
			browser.text_field(name: "spree_user[password]").set 'test123'
	        browser.text_field(name: "spree_user[password_confirmation]").set 'test123'
	        browser.input(name: "commit").click
            assert(browser.div(class: 'flash notice').present?)
            goto '/t/music/christmas'
            searching_for_jingles
            logout
		    goto "/login"
		    browser.text_field(name: "spree_user[email]").set email_new
		    browser.text_field(name: "spree_user[password]").set 'test123'
		    browser.input(name: "commit").click
		    goto '/cart'
		    browser.a(text: "Jingles 3").exists?
			browser.close

			browser = open_browser
			
			browser.goto 'http://deseretbook.net/login'
			browser.text_field(name: "spree_user[email]").set email_new
		    browser.text_field(name: "spree_user[password]").set 'test123'
		    browser.input(name: "commit").click
		    browser.goto 'http://deseretbook.net/cart' 
		    browser.a(text: "Jingles 3").exists?
			browser.close
		end

private

  def searching_for_jingles
      browser.text_field(name: "keywords").set 'Jingles 3'
      browser.input(class: "btn btn-primary img-responsive js-search-button").click
      assert(browser.h1(text: "Search results for 'Jingles 3'").exists?)
      browser.a(text: "Learn More").click
      assert_equal("#{base_url}/p/jingles-3-voice-male-86135?variant_id=10175-cd", browser.url, "incorrect location")
			browser.button(class: "btn btn-lg btn-primary btn-block btn-add-to-cart").exists?
			browser.button(class: "btn btn-lg btn-primary btn-block btn-add-to-cart").click
			assert_equal("#{base_url}/item_added", browser.url, "incorrect location")
  end

	end