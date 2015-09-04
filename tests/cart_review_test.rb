require 'test_helper'

class CartReviewTest < NibleyTest
  include BaseCheckoutHelper
  include StandardCheckoutHelper

  def test_add_twice_to_cart
  	empty_cart
  	add_physical_item_to_cart(quantity: 2)
  	goto  '/cart'
  	
  	quantity = browser.text_field(class: 'line_item_quantity').value.to_i
  	cart_item_price = browser.td(class: 'cart-item-price').text.split("\n").first.gsub(/[^0-9\.]/, '').to_f
  	cart_item_total = browser.td(class: 'cart-item-total').text.split("\n").first.gsub(/[^0-9\.]/, '').to_f

  	assert(quantity == 2)
  	assert((cart_item_price * quantity) == cart_item_total)
  	browser.text_field(class: 'line_item_quantity').set(1)

  	wait = 5
  	while (wait >= 0) do
  		if browser.td(class: 'cart-item-total').value == cart_item_total
  			break
  		end
  		sleep(1)
  		wait = wait - 1
  	end

  	quantity = browser.text_field(class: 'line_item_quantity').value.to_i
  	cart_item_price = browser.td(class: 'cart-item-price').text.split("\n").first.gsub(/[^0-9\.]/, '').to_f
  	cart_item_total = browser.td(class: 'cart-item-total').text.split("\n").first.gsub(/[^0-9\.]/, '').to_f

  	assert(quantity == 1)
  	assert(cart_item_price * quantity == cart_item_total)
  end
     
   def test_remove_item_from_card
  	add_physical_item_to_cart(quantity: 1)
  	goto  '/cart'	
  	browser.a(text: 'Remove').click
  	assert(
  		browser.p(text: 'Your cart is empty').exists?,
  		'Expected to find <P> tag with text "Your cart is empty" but did not.'
  	)
  end

  def test_empty_cart_link
  	add_physical_item_to_cart(quantity: 1)
  	goto  '/cart'	
  	browser.input(value: 'Empty Cart').click
  	assert(
  		browser.p(text: 'Your cart is empty').exists?,
  		'Expected to find <P> tag with text "Your cart is empty" but did not.'
  	)
  end

end
