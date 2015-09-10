require 'test_helper'
require 'faker'

class WriteAReview < NibleyTest

  def test_guest_cannot_write_a_review
    logout
    go_to_variant_page
    if browser.a(text: "Write a Review").exists?
      browser.a(text: "Write a Review").click
      assert_equal("#{base_url}/login", browser.url, "incorrect location")
    else
      false
    end
  end

  def test_success_case_of_review
    login
    go_to_variant_page
    click_review_link

    browser.a(text: "5 stars").click
    browser.text_field(name: "review[name]").set Faker::Name.name
    browser.text_field(name: "review[title]").set Faker::Company.bs
    browser.textarea(name: "review[review]").set Faker::Hacker.say_something_smart
    browser.input(name: "commit").click
    assert_equal(browser.div(class: 'flash notice').text, "Review was successfully submitted")
    assert_equal("#{base_url}/p/rm-halestorm-entertainment-47109?variant_id=55889", browser.url, "incorrect location")
    logout
  end

  def test_failure_case_of_review_no_raring
    login
    go_to_variant_page
    click_review_link

    browser.text_field(name: "review[name]").set Faker::Name.name
    browser.text_field(name: "review[title]").set Faker::Company.bs
    browser.textarea(name: "review[review]").set Faker::Hacker.say_something_smart
    submit_review
    assert(
      browser.strong(text: '1 error prohibited this record from being saved').exists?,
      'Expected to find <strong> tag with text "1 error prohibited this record from being saved" but did not.'
    )

    logout
  end

  def test_failure_case_of_review_no_name
    login
    go_to_variant_page
    click_review_link

    browser.a(text: "5 stars").click
    browser.text_field(name: "review[title]").set Faker::Company.bs
    browser.textarea(name: "review[review]").set Faker::Hacker.say_something_smart
    submit_review
    assert(
      browser.strong(text: '1 error prohibited this record from being saved').exists?,
      'Expected to find <strong> tag with text "1 error prohibited this record from being saved" but did not.'
    )

    logout
  end

  def test_failure_case_of_review_no_content
    login
    go_to_variant_page
    click_review_link

    browser.a(text: "5 stars").click
    browser.text_field(name: "review[name]").set Faker::Name.name
    browser.text_field(name: "review[title]").set Faker::Company.bs
    submit_review
    assert(
      browser.strong(text: '1 error prohibited this record from being saved').exists?,
      'Expected to find <strong> tag with text "1 error prohibited this record from being saved" but did not.'
    )

    logout
  end

private

  def write_review(options={})
    browser.a(text: "#{options[:stars].to_i} stars").click
    if options[:name]
      browser.text_field(name: "review[name]").set Faker::Name.name
    end
    if options[:title]
      browser.text_field(name: "review[title]").set Faker::Company.bs
    end
    if options[:review]
      browser.textarea(name: "review[review]").set Faker::Hacker.say_something_smart
    end
    submit_review
  end

  def go_to_variant_page
    goto '/p/rm-halestorm-entertainment-47109?taxon_id=148&variant_id=55889'
  end

  def click_review_link
    browser.a(text: "Write a Review").click
    assert_equal("#{base_url}/products/rm-halestorm-entertainment-47109/reviews/new", browser.url, "incorrect location")
  end

  def submit_review
    browser.input(name: "commit").click
    assert_equal("#{base_url}/products/rm-halestorm-entertainment-47109/reviews", browser.url, "incorrect location")
  end
end