require 'test_helper'
# require 'watir-webdriver'

class AddressTest < NibleyTest
	include BaseCheckoutHelper
	include StandardCheckoutHelper


			def test_my_account
		    goto "/login"
		    browser.text_field(name: "spree_user[email]").set 'tests@deseretbook.com'
		    browser.text_field(name: "spree_user[password]").set 'test123'
		    browser.input(name: "commit").click
			end

			def test_my_account_address
		    browser.a(text: "My Account").click
		    assert_equal("#{base_url}/account", browser.url, "incorrect location")
		    assert browser.text.include?("My Account")

		    browser.a(text: "Addresses").click
			assert(
					browser.h3(text: 'Saved Addresses').exists?,
					'Expected to find <h3> tag with text "Saved Addresses" but did not.'
				)
			end

            def test_my_account_address_inside
            browser.a(text: "Add new address").click
            assert_equal("#{base_url}/addresses/new", browser.url, "incorrect location")
            assert browser.text.include?("New Address")

            browser.text_field(name: "address[firstname]").set 'test'
		    browser.text_field(name: "address[lastname]").set 'user'
		    browser.text_field(name: "address[address1]").set '5000 M St'
		    browser.text_field(name: "address[city]").set 'Munich'
		    browser.select_list(name: "address[state_id]").select 'Hawaii'
		    browser.text_field(name: "address[zipcode]").set '55667'
		    browser.select_list(name: "address[country_id]").select 'United States of America'
		    browser.text_field(name: "address[phone]").set '555-5555'
			
			browser.input(name: "commit").click
			assert_equal("#{base_url}/account", browser.url, "incorrect location")
			assert(browser.div(class: 'flash notice').present?)

			browser.a(text: "Addresses").click
		    assert_equal("#{base_url}/account", browser.url, "incorrect location")
		    end

       def test_my_account_delete_address
			 goto "/logout"
		     goto '/login'

			browser.text_field(name: "spree_user[email]").set 'tests@deseretbook.com'
		    browser.text_field(name: "spree_user[password]").set 'test123'
		    browser.input(name: "commit").click

		    browser.a(text: "My Account").click
		    assert_equal("#{base_url}/account", browser.url, "incorrect location")
		    assert browser.text.include?("My Account")

		    browser.a(text: "Addresses").click
		    assert_equal("#{base_url}/account", browser.url, "incorrect location")
		    #assert browser.text.include?("My Saved Addresses")
			assert(
					browser.h3(text: 'Saved Addresses').exists?,
					'Expected to find <h3> tag with text "Saved Addresses" but did not.'
				)
          
            browser.a(text: "Addresses").click
		    assert_equal("#{base_url}/account", browser.url, "incorrect location")

            address_tr = browser.driver.find_elements(tag_name: 'tr', class: 'address').detect{|tr|
            	tr.find_elements(tag_name: 'address').detect{|address| address.text =~ /Munich/}
            }

            address_tr.find_elements(tag_name: 'a').detect{|a| a.text == 'Remove'}.click
            browser.driver.switch_to.alert.accept

          browser.a(text: "Addresses").click
		    assert_equal("#{base_url}/account", browser.url, "incorrect location")
			assert(
					browser.h3(text: 'Saved Addresses').exists?,
					'Expected to find <h3> tag with text "Saved Addresses" but did not.'
				)
			browser.driver.page_source.include? 'Munich'
            

            
	   end
  end