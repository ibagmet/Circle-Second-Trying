require 'test_helper'
require 'httparty'
require 'ruby-progressbar'

class HomePageTest < NibleyTest
  # Make sure all links on home page go to a URL that returns a 200 OK response.
  # Ignore links that are not visible to the user.
  # Ignore ajax links or any link that is bare hash-path (e.g. href ends
  # with a "#").
  # Note that we only use webdriver to load the home page; all of the links
  # are then tested using HTTParty because it's faster.
  def test_all_links_return_200
    goto '/'
    anchors = browser.driver.find_elements(tag_name: 'a').select(&:displayed?).select do |anchor|
      href = anchor.attribute('href').to_s

      case href
      when ''
        # empty target, probably ajax. Don't follow this.
        false
      when base_url, "#{base_url}/"
        # Home page link, assumed to work because that's where we are.
        # No need to test this.
        false
      when /\#$/
        # Probably an ajax call, Don't follow these.
        false
      when /^(?!http)/
        # Ignore links that aren't http or https.
        false
      else
        # Follow all others
        true
      end
    end

    failures = []

    progressbar = ProgressBar.create(
      title: 'Checking URLs',
      total: anchors.length,
      format: "%t: |%B| %p%% (%c/%C) %e"
    )

    anchors.each_with_index do |anchor, i|
      url = anchor.attribute('href')
      text = anchor.text.inspect
      # puts "Checking link #{i+1}/#{anchors.size}: #{text} (#{url.inspect})"

      failures << anchor unless valid_link?(url)

      progressbar.increment
    end

    assert(failures.empty?,
      [
        'The following links did not returns a 200:',
        failures.map{|anchor|
          "Text: #{anchor.text.inspect}, URL: #{anchor.attribute('href').inspect}"
        }.join("\n")
      ].join("\n"),
      debug_on_failure: false
    )

  end

  # Go through all the links in the drop-down menus of the home page header and
  # make sure they all go to a page that returns 200 OK.
  def test_all_header_menu_links_return_200
    goto '/'

    failures = []

    browser.ul(class: 'nav-links').lis.each{|menu_li|
      next unless menu_li.attribute_value('data-url')

      menu_name = menu_li.text
      # puts menu_name.inspect

      # There may be a hidden <div> in the <li>, or just a link.
      # If it's just a link, record the anchor and continue.
      if !menu_li.div.exists? && menu_li.a.exists?
        unless valid_link?(menu_li.a.attribute_value('href'))
          failures << [menu_name, menu_li.a.attribute_value('href')]
        end
        next
      end

      # before mouse-over, verify the div is hidden.
      assert(!menu_li.div.visible?)

      # next, mouse-over the li and verify the div is now visible
      menu_li.hover
      assert(menu_li.div.visible?)

      # test all the links
      menu_anchors = menu_li.div.as.to_a

      progressbar = ProgressBar.create(
        title: "Links in #{menu_name.inspect}",
        total: menu_anchors.length,
        format: "%t: |%B| %p%% (%c/%C) %e"
      )

      menu_anchors.each do |anchor|
        url = anchor.attribute_value('href')
        text = anchor.text
        # puts "Checking link #{text.inspect} (#{url.inspect})"
        failures << [menu_name, url, text] unless valid_link?(url)
        progressbar.increment
      end
    }

    assert(failures.empty?,
      [
        'The following links did not returns a 200:',
        failures.map{|menu, url, text|
          "Menu: #{menu.inspect}, Text: #{text.inspect}, URL: #{url.inspect}"
        }.join("\n")
      ].join("\n"),
      debug_on_failure: false
    )

  end

private

  # Argument is URL as a string.
  # Returns true if url returns a 200 OK. False if otherwise.
  def valid_link?(url)
    # GET or HEAD? Head is more friendly to the server, but some pages
    # May behave differently depending on HEAD or GET.
    HTTParty.head(url,
      verify: false, # don't verify ssl certs
    ).code == 200
  end
end