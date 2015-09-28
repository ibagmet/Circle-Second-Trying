require 'test_helper'
require 'faker'

class PasswordChangeTest < NibleyTest
	include BaseCheckoutHelper
	include StandardCheckoutHelper

	def test_password_change_login
	  goto  '/signup'	
		email_name = ::Faker::Internet.safe_email
		browser.text_field(name: "spree_user[email]").set email_name  #'tests1232@deseretbook.com'
	  browser.text_field(name: "spree_user[first_name]").set 'test_name'
	  browser.text_field(name: "spree_user[last_name]").set 'test_last_name'
		browser.text_field(name: "spree_user[password]").set 'test123'
	  browser.text_field(name: "spree_user[password_confirmation]").set 'test123'
	  browser.input(name: "commit").click
	  assert(browser.div(class: 'flash notice').present?)

		goto "/logout"
	  goto "/login"
	  browser.text_field(name: "spree_user[email]").set email_name
	  browser.text_field(name: "spree_user[password]").set 'test123'
	  browser.input(name: "commit").click
	  browser.a(text: "My Account").click
	  assert_equal("#{base_url}/account", browser.url, "incorrect location")
	  assert browser.text.include?("My Account")
		browser.a(text: "Edit").click
		browser.text_field(name: "user[password]").set "test321"
		browser.text_field(name: "user[password_confirmation]").set "test321"
		browser.input(name: "commit").click
		assert_equal("#{base_url}/login", browser.url, "incorrect location")
		assert(browser.div(class: 'flash notice').present?)
		browser.text_field(name: "spree_user[email]").set email_name
	  browser.text_field(name: "spree_user[password]").set 'test321'
	  browser.input(name: "commit").click
	  assert(browser.div(class: 'flash success').present?)

			end
end