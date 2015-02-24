require 'test_helper'

class EbookPurchaseTest < NibleyTest
  include BaseCheckoutHelper
  include StandardCheckoutHelper
  include BookshelfHelper

  # test that when an ebook is purchased on the site, the purchase gets sent
  # to bookshelf.
  def test_ebook_purchases_send_to_bookshelf
    puts "test_ebook_purchases_send_to_bookshelf"

    # Verify target bookshelf installation is in nibley mode

    # Log test user in to bookshelf
    bookshelf_token = login_bookshelf_user(
      'tests@deseretbook.com',
      'test123'
    )
    
    # Ensure the book isn't already in the test user's bookshelf account.
    remove_book_from_bookshelf_account(bookshelf_token, digital_product_book_id)

    # do the purchase
    clear_cookies
    login

    add_items_to_cart([:digital])

    begin_checkout

    select_addresses(allow_skip: true)

    select_payment(payment_type: :credit_card)

    confirm_order
    verify_successful_order
    verify_order_state([:digital])

    # Verify the book is now in the test user's bookshelf account.
    # It may take a while to get through the queue so do a timed retry here.
    # This loop will wait a total of 30 seconds.
    retries = 10
    until present = bookshelf_account_contains_book?(bookshelf_token, digital_product_book_id)
      puts "Book #{digital_product_book_id} present yet? #{present.inspect}"
      unless present
        retries -= 1
        puts "#{retries} retries left. Trying again in 3 seconds."
        sleep(3)
      end
    end
    assert(present, "Book #{digital_product_book_id} not in bookshelf account")
  end

end
