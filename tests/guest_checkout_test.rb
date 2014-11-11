require 'test_helper'

class GuestCheckoutTest < NibleyTest
  include BaseCheckoutHelper
  include GuestCheckoutHelper

  def test_guest_checkout_physical
    product_type = ['physical']
    use_billing_address = true

    guest_checkout_workflow product_type, use_billing_address
  end

  def test_guest_checkout_digital
    product_type = ['digital']
    use_billing_address = true

    guest_checkout_workflow product_type, use_billing_address
  end


  def test_guest_checkout_both
    product_type = ['physical', 'digital']
    use_billing_address = true

    guest_checkout_workflow product_type, use_billing_address
  end


  def test_guest_checkout_physical_with_separate_shipping
    product_type = ['physical']
    use_billing_address = false

    guest_checkout_workflow product_type, use_billing_address
  end

  def test_guest_checkout_digital_with_separate_shipping
    product_type = ['digital']
    use_billing_address = false

    guest_checkout_workflow product_type, use_billing_address
  end


  def test_guest_checkout_both_with_separate_shipping
    product_type = ['physical', 'digital']
    use_billing_address = false 

    guest_checkout_workflow product_type, use_billing_address
  end


end
