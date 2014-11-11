require 'test_helper'
 
class SetupTest < NibleyTest

  def test_the_setup
    logout

    browser.link(text: "Login").when_present.click
    browser.link(text: "Create a new account").when_present.click
    browser.text_field(name: "spree_user[email]").set 'tests@deseretbook.com'
    browser.text_field(name: "spree_user[first_name]").set 'test'
    browser.text_field(name: "spree_user[last_name]").set 'user'
    browser.text_field(name: "spree_user[password]").set 'test123'
    browser.text_field(name: "spree_user[password_confirmation]").set 'test123'
    browser.form(id: "new_spree_user").when_present.submit

    login

    browser.link(text: "My Account").when_present.click
    browser.link(text: "Addresses").when_present.click
    
    browser.div(id: "user_addresses").wait_until_present
    browser.div(id: "new_address_link").wait_until_present

    if browser.div(id: "users-address-list-empty").present?
      browser.link(text: "Add new address").click

      browser.text_field(name: "address[firstname]").set 'test'
      browser.text_field(name: "address[lastname]").set 'user'
      browser.text_field(name: "address[address1]").set '1445 K St'
      browser.text_field(name: "address[city]").set 'Lincoln'
      browser.select_list(name: "address[state_id]").select 'Nebraska'
      browser.text_field(name: "address[zipcode]").set '68508'
      browser.text_field(name: "address[phone]").set '555-5555'
      browser.input(name: "commit").when_present.click

      assert browser.text.include?('Address has been successfully created!'), "Address was not successfully created."
    else
      assert browser.text.include?('test user'), "user name not on page"
      assert browser.text.include?('5550 Adams'), "street address not on page"
      assert browser.text.include?('Lincoln NE 68507'), "city/state/zip not on page"
      assert browser.text.include?('United States'), "country not on page"
    end
  end
end
