require 'test_helper'

class CouponsTest < NibleyTest

	def test_coupons_failure_cases
    goto '/login'
    browser.text_field(name: "spree_user[email]").set 'ibagmet@deseretbook.com'
    browser.text_field(name: "spree_user[password]").set 'test123'
    browser.input(name: "commit").click
    assert_equal(browser.div(class: 'flash success').text, "Logged in successfully")
    browser.text_field(name: "keywords").set 'The Book of Mormon for Latter-day Saint Families'
    browser.input(class: "btn btn-primary img-responsive js-search-button").click
    assert(browser.h1(text: "Search results for 'The Book of Mormon for Latter-day Saint Families'").exists?)
    browser.a(text: "Hardcover").click
    browser.button(class: "btn btn-lg btn-primary btn-block btn-add-to-cart").click
    assert_equal("#{base_url}/item_added", browser.url, "incorrect location")
    browser.a(class: "btn btn-primary text-uppercase continue").click
    assert_equal("#{base_url}/cart", browser.url, "incorrect location")
    browser.a(text: "Close").click
    browser.a(class: "btn btn-primary btn-lg pull-right btn-checkout").click
    assert_equal("#{base_url}/checkout/address", browser.url, "incorrect location")
    browser.button(class: "btn btn-primary pull-right js-form-validate btn-continue").click
    assert_equal("#{base_url}/checkout/delivery", browser.url, "incorrect location")
    browser.button(class: "btn btn-primary pull-right btn-continue").click
    assert_equal("#{base_url}/checkout/payment", browser.url, "incorrect location")
    browser.a(text: "Enter coupon code").click
    browser.text_field(name: "order[coupon_code]").set 'smth_strange'
    browser.button(text: "Apply Coupon Code").click
    browser.div(text: "The coupon code you entered doesn't exist. Please try again.").exists?
    sleep(1)
    browser.text_field(name: "order[coupon_code]").set 'test123_expired'
    browser.button(text: "Apply Coupon Code").click
    browser.div(text: "The coupon code is expired").exists?
    sleep(1)
    browser.text_field(name: "order[coupon_code]").set 'text123_only_for_digital'
    browser.button(text: "Apply Coupon Code").click
    browser.div(text: "This coupon code could not be applied to the cart at this time.").exists?
    sleep(1)
    browser.text_field(name: "order[coupon_code]").set 'test123_50'
    browser.button(text: "Apply Coupon Code").click
    browser.div(text: "The coupon code was successfully applied to your order.").exists?
    sleep(1)
    browser.text_field(name: "order[coupon_code]").set 'test123_50'
    browser.button(text: "Apply Coupon Code").click
    browser.div(text: "The coupon code has already been applied to this order").exists?
    sleep(1)
    browser.text_field(name: "order[coupon_code]").set 'test123_one_more'
    browser.button(text: "Apply Coupon Code").click
    browser.div(text: "The coupon code was successfully applied to your order.").exists?
    browser.driver.page_source.include? 'Promotion (test_coupon_success)'
    browser.driver.page_source.include? 'Promotion (test_coupon_50%)'

    browser.button(class: "btn btn-primary pull-right btn-continue js-submit-btn").click
    assert_equal("#{base_url}/checkout/confirm", browser.url, "incorrect location")
    browser.button(class: "btn btn-primary btn-lg pull-right btn-continue").click
    assert_equal(browser.div(class: 'flash notice').text, "Thank You. We have successfully received your order.")
    
    goto '/cart'
    browser.input(class: "btn btn-sm btn-link-plain").click
    logout
	end

	end
 