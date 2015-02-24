require 'minitest/spec'
require 'minitest/autorun'
require 'watir-webdriver'

require 'helpers/base_checkout_helper'
require 'helpers/standard_checkout_helper'
require 'helpers/guest_checkout_helper'
require 'helpers/gift_card_helper'
require 'helpers/bookshelf_helper'

require "minitest/reporters"
Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new

require 'pry-byebug'
 
class NibleyTest < Minitest::Test
  # the browser instance is stored as a classvar so it will stay open and not
  # close and them reopen for every test example (which wastes time).
  def browser
    @@browser
  end

  Minitest.after_run do
    if defined?(@@orders)
      puts "Order Log:"
      puts @@orders.to_json 
    end
    @@browser.close
  end

  # make tests run in alphabetical order
  def self.test_order
   :alpha
  end

  # runs before each test
  def setup 
    # @browser ||= Watir::Browser.new :firefox
    unless defined?(@@browser)
      @@browser = Watir::Browser.new :firefox
    end
  end
   
  # runs after each test
  def teardown 
  end

  def base_url
    "https://stage.deseretbook.com"
  end

  def bookshelf_api_base_url
    "https://stage.bookshelf.deseretbook.com/api/v1"
  end

  def physical_product_url
    "/products/romney-family-table-ann-89648"
  end

  def digital_product_url
    "/products/romney-family-table-ann-89648?variant_id=5897"
  end

  # must be the book id for the product in #digital_product_url
  def digital_product_book_id
    4416
  end

  def goto(route)
    browser.goto "#{base_url}#{route}"
  end

  def logout
    goto "/logout"
  end

  def login
    goto "/login"
    browser.text_field(name: "spree_user[email]").set 'tests@deseretbook.com'
    browser.text_field(name: "spree_user[password]").set 'test123'
    browser.input(name: "commit").when_present.click
    assert browser.text.include?("Logged in successfully"), "Could not log in"
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
    return unless defined?(@@orders) # don't log unless #start_new_order_log called
    return unless @@orders.last[:start] # can't add to order not started.
    return if @@orders.last[:finished] # can't add to order record once finished.
    values = {}

    # populate values hash
    if field.is_a?(Hash)
      field.each{|k,v| values[k] = v }
    else
      values[field.to_sym] = value
    end

    # store items in values hash in @@orders
    values.each do |k,v|
      if (existing_value = @@orders.last[k.to_sym])
        if existing_value.is_a? Array
          @@orders.last[k.to_sym] << v
        else
          # storing a duplicate key; turn this in to an array and store both
          @@orders.last[k.to_sym] = [existing_value, v]
        end
      else
        @@orders.last[k.to_sym] = v
      end
    end
  end

  def close_current_order_log
    return unless defined?(@@orders) # can't close order log that isn't open

    # @@orders.last is current order log, so appending new hash effectively
    # turn off current order log.
    @@orders << {}
  end

  def order_finished
    raise '#start_new_order_log not called yet!' unless @@orders
    @@orders.last[:finished] = true
    @@orders.last[:finish] = Time.now
  end

  # overload assert so that pry debugger starts on failed assertion
  def assert test, msg = nil
    begin
      super
    rescue Minitest::Assertion => e
      puts e
      warn "Assertion Failed. Dropping into debugger now:"
      binding.pry
      raise e
    end
  end

end
