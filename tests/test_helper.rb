require 'minitest/spec'
require 'minitest/autorun'
require 'watir-webdriver'

require 'helpers/base_checkout_helper'
require 'helpers/standard_checkout_helper'
require 'helpers/guest_checkout_helper'
require 'helpers/gift_card_helper'

require "minitest/reporters"
Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new

require 'pry-byebug'
 
class NibleyTest < Minitest::Test
  attr_reader :browser

  Minitest.after_run do
    puts "Order Log:"
    puts @@orders.to_json 
  end

  def self.test_order
   :alpha
  end

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
    clear_cookies
    goto "/login"
    browser.text_field(name: "spree_user[email]").set 'tests@deseretbook.com'
    browser.text_field(name: "spree_user[password]").set 'test123'
    browser.input(name: "commit").when_present.click
  end

  def clear_cookies
    browser.cookies.clear
  end

  def start_new_order_log(*parameters)
    @@orders ||= []
    @@orders << { start: Time.now, parameters: parameters, finished: false }
  end

  # can be called with either (field, value) or ({field: value})
  def order_log(field, value = nil)
    raise '#start_new_order_log not called yet!' unless @@orders
    if field.is_a?(Hash)
      field.each{|k,v| @@orders.last[k.to_sym] = v }
    else
      @@orders.last[field.to_sym] = value
    end
  end

  def order_finished
    raise '#start_new_order_log not called yet!' unless @@orders
    @@orders.last[:finished] = true
    @@orders.last[:finish] = Time.now
  end

end
