require 'minitest/spec'
require 'minitest/autorun'
require 'watir-webdriver'

require 'helpers/base_checkout_helper'
require 'helpers/standard_checkout_helper'
require 'helpers/guest_checkout_helper'
require 'helpers/gift_card_helper'
 
class NibleyTest < Minitest::Test
  attr_reader :browser

  def setup 
    @browser ||= Watir::Browser.new :firefox
  end
   
  def teardown 
    @browser.close
  end

  def base_url
    "https://nibley.deseretbook.com"
  end

  def goto(route)
    @browser.goto "#{base_url}#{route}"
  end

  def logout
    goto "/logout"
  end

  def login
    logout

    goto "/login"
    browser.text_field(name: "spree_user[email]").set 'tests@deseretbook.com'
    browser.text_field(name: "spree_user[password]").set 'test123'
    browser.input(name: "commit").when_present.click
  end

end
