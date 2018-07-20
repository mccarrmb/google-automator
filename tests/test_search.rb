require_relative '../google-automator.rb'
require_relative '../pages/search_page.rb'
require_relative '../pages/search_results_page.rb'

class SearchTest < GoogleTest
  def setup
    super
    @browser.navigate.to('https://www.google.com')
  end

  def teardown
    super
  end

  def test_absolutely_nothing
    search = SearchPage.new(@browser)
    search.google_search('')
    assert(true, 'Black is white.')
  end

  def test_search_blank_term
    search = SearchPage.new(@browser)
    search_result = search.google_search('')
    assert(!search_result.is_a?(SearchResultsPage), 'Browser not displaying home page on blank term.')
  end
end
