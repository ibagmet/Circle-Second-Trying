require 'test_helper'
require 'faker'

class WriteAReview < NibleyTest
	include BaseCheckoutHelper
	include StandardCheckoutHelper

	def test_guest_cannot_write_a_review
		goto '/p/rm-halestorm-entertainment-47109?taxon_id=148&variant_id=55889'
		assert_equal("#{base_url}/p/rm-halestorm-entertainment-47109?taxon_id=148&variant_id=55889", browser.url, "incorrect location")
		#binding.pry
		if browser.a(text: "Write a Review").exists?
			browser.a(text: "Write a Review").click
			assert_equal("#{base_url}/login", browser.url, "incorrect location")
			#sleep(3)
		else
			false
		end


	end


	def test_success_case_of_review
    goto '/login'

			browser.text_field(name: "spree_user[email]").set 'tests@deseretbook.com'
		    browser.text_field(name: "spree_user[password]").set 'test123'
		    browser.input(name: "commit").click
    goto '/p/rm-halestorm-entertainment-47109?taxon_id=148&variant_id=55889'
    browser.a(text: "Write a Review").click
	assert_equal("#{base_url}/products/rm-halestorm-entertainment-47109/reviews/new", browser.url, "incorrect location")
	
	browser.a(text: "5 stars").click
	browser.text_field(name: "review[name]").set Faker::Name.name 
	browser.text_field(name: "review[title]").set Faker::Company.bs
	browser.text_field(name: "review[review]").set Faker::Hacker.say_something_smart
	browser.input(name: "commit").click
	assert(browser.div(class: 'flash notice').present?)
	assert_equal("#{base_url}/p/rm-halestorm-entertainment-47109?variant_id=55889", browser.url, "incorrect location")
    goto '/logout'
    end

	def test_failure_case_of_review_no_raring
	goto '/login'
	browser.text_field(name: "spree_user[email]").set 'tests@deseretbook.com'
    browser.text_field(name: "spree_user[password]").set 'test123'
    browser.input(name: "commit").click
    goto '/p/rm-halestorm-entertainment-47109?taxon_id=148&variant_id=55889'
    browser.a(text: "Write a Review").click
	assert_equal("#{base_url}/products/rm-halestorm-entertainment-47109/reviews/new", browser.url, "incorrect location")
	
	browser.text_field(name: "review[name]").set Faker::Name.name 
	browser.text_field(name: "review[title]").set Faker::Company.bs
	browser.text_field(name: "review[review]").set Faker::Hacker.say_something_smart
	browser.input(name: "commit").click
	assert_equal("#{base_url}/products/rm-halestorm-entertainment-47109/reviews", browser.url, "incorrect location")
            assert(
					browser.strong(text: '1 error prohibited this record from being saved').exists?,
					'Expected to find <strong> tag with text "1 error prohibited this record from being saved" but did not.'
				)

	goto '/logout'
	end

	def test_failure_case_of_review_no_name
	goto '/login'
	browser.text_field(name: "spree_user[email]").set 'tests@deseretbook.com'
    browser.text_field(name: "spree_user[password]").set 'test123'
    browser.input(name: "commit").click
    goto '/p/rm-halestorm-entertainment-47109?taxon_id=148&variant_id=55889'
    browser.a(text: "Write a Review").click
	assert_equal("#{base_url}/products/rm-halestorm-entertainment-47109/reviews/new", browser.url, "incorrect location")
	
	browser.a(text: "5 stars").click
	browser.text_field(name: "review[title]").set Faker::Company.bs
	browser.text_field(name: "review[review]").set Faker::Hacker.say_something_smart
	browser.input(name: "commit").click
	assert_equal("#{base_url}/products/rm-halestorm-entertainment-47109/reviews", browser.url, "incorrect location")
            assert(
					browser.strong(text: '1 error prohibited this record from being saved').exists?,
					'Expected to find <strong> tag with text "1 error prohibited this record from being saved" but did not.'
				)

	goto '/logout'
	end

	def test_failure_case_of_review_no_content
	goto '/login'
	browser.text_field(name: "spree_user[email]").set 'tests@deseretbook.com'
    browser.text_field(name: "spree_user[password]").set 'test123'
    browser.input(name: "commit").click
    goto '/p/rm-halestorm-entertainment-47109?taxon_id=148&variant_id=55889'
    browser.a(text: "Write a Review").click
	assert_equal("#{base_url}/products/rm-halestorm-entertainment-47109/reviews/new", browser.url, "incorrect location")
	
	browser.a(text: "5 stars").click
	browser.text_field(name: "review[name]").set Faker::Name.name
	browser.text_field(name: "review[title]").set Faker::Company.bs
	browser.input(name: "commit").click
	assert_equal("#{base_url}/products/rm-halestorm-entertainment-47109/reviews", browser.url, "incorrect location")
            assert(
					browser.strong(text: '1 error prohibited this record from being saved').exists?,
					'Expected to find <strong> tag with text "1 error prohibited this record from being saved" but did not.'
				)

	goto '/logout'
	end


end