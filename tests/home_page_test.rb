require 'test_helper'
require 'httparty'

class HomePageTest < NibleyTest
  # Make sure all links on home page go to a URL that returns a 200 OK response.
  # Ignore links that are not visible to the user.
  # Ignore ajax links or any link that is bare hash-path (e.g. href ends
  # with a "#").
  # Note that we only use webdriver to load the home page; all of the links
  # are then tested using HTTParty because it's faster.
  def test_all_links_return_200_while_not_logged_in
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

    require 'ruby-progressbar'
    progressbar = ProgressBar.create(
      title: 'Checking URLs',
      total: anchors.length,
      format: "%t: |%B| %p%% (%c/%C) %e"
    )

    anchors.each_with_index do |anchor, i|
      url = anchor.attribute('href')
      text = anchor.text.inspect
      # puts "Checking link #{i+1}/#{anchors.size}: #{text} (#{url.inspect})"

      # GET or HEAD? Head is more friendly to the server, but some pages
      # May behave differently depending on HEAD or GET.
      response = HTTParty.head(url,
        verify: false, # don't verify ssl certs
      )

      failures << anchor unless response.code == 200

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
end