require 'test_helper'
require 'faker'

class AccountWithCassesTest < NibleyTest
	include BaseCheckoutHelper
	include StandardCheckoutHelper

		def test_login_top_link

			goto  '/signup'	
			browser.a(text: 'Login').click
			assert_equal("#{base_url}/login", browser.url, "incorrect location")
			assert(
					browser.strong(text: 'Login as Existing Customer').exists?,
					'Expected to find <strong> tag with text "Login as Existing Customer" but did not.'
				)
		end

	    def test_login_bottom_link

            goto "/logout"
		    goto '/login'
		    browser.input(value: 'Login').click
		    assert_equal("#{base_url}/login", browser.url, "incorrect location")
		    assert(browser.div(class: 'flash error').present?)
		    assert(browser.text =~ /Invalid email or password./)
	    end 

	    def test_new_account_link
	    
		    goto  '/login'	
		    browser.a(text: 'Create a new account').click
		    assert_equal("#{base_url}/signup", browser.url, "incorrect location")
		    assert(
					browser.div(text: 'New Customer').exists?,
					'Expected to find <div> tag with text "New Customer" but did not.'
				)
	    end	

		def test_fill_out_form
			goto  '/signup'	
			#generator for name
			email_name = ::Faker::Internet.safe_email
	 		browser.text_field(name: "spree_user[email]").set email_name  #'tests1232@deseretbook.com'
	        browser.text_field(name: "spree_user[first_name]").set 'test_name'
	        browser.text_field(name: "spree_user[last_name]").set 'test_last_name'
			browser.text_field(name: "spree_user[password]").set 'test123'
	        browser.text_field(name: "spree_user[password_confirmation]").set 'test123'
	        browser.input(name: "commit").click
            assert(browser.div(class: 'flash notice').present?)
            
		end

        def test_failure_cases_invaild_password

			goto  '/signup'		
	        browser.text_field(name: "spree_user[first_name]").set 'test_name'
	        browser.text_field(name: "spree_user[last_name]").set 'test_last_name'
			browser.text_field(name: "spree_user[password]").set 'test123'
	        browser.text_field(name: "spree_user[password_confirmation]").set 'test123'
	        browser.input(name: "commit").click
            assert_equal("#{base_url}/signup", browser.url, "incorrect location")
            assert(
					browser.strong(text: '1 error prohibited this record from being saved').exists?,
					'Expected to find <strong> tag with text "1 error prohibited this record from being saved" but did not.'
				)
            
		end

		def test_failure_cases_invaild_password

			goto  '/signup'	
			email_name = ::Faker::Internet.safe_email
	        browser.text_field(name: "spree_user[email]").set email_name  
	        browser.text_field(name: "spree_user[first_name]").set 'test_name'
	        browser.text_field(name: "spree_user[last_name]").set 'test_last_name'
	        browser.input(name: "commit").click
            assert_equal("#{base_url}/signup", browser.url, "incorrect location")
            assert(
					browser.strong(text: '1 error prohibited this record from being saved').exists?,
					'Expected to find <strong> tag with text "1 error prohibited this record from being saved" but did not.'
				)
			
		end


		def test_failure_cases_password_fields_do_not_match

			goto  '/signup'	
			email_name = ::Faker::Internet.safe_email
	 		browser.text_field(name: "spree_user[email]").set email_name  
	        browser.text_field(name: "spree_user[first_name]").set 'test_name'
	        browser.text_field(name: "spree_user[last_name]").set 'test_last_name'
			browser.text_field(name: "spree_user[password]").set 'test123'
	        browser.text_field(name: "spree_user[password_confirmation]").set 'test321'
	        browser.input(name: "commit").click
            assert_equal("#{base_url}/signup", browser.url, "incorrect location")
            assert(
					browser.strong(text: '1 error prohibited this record from being saved').exists?,
					'Expected to find <strong> tag with text "1 error prohibited this record from being saved" but did not.'
				)

		end


end
