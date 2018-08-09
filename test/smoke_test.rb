require 'test_base.rb'
require 'search_page.rb'
require 'search_results_page.rb'

class SearchTest < TestBase
  def setup
    super
    @browser.navigate.to(@google.app_url)
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

  def test_search_non_blank_term
    search = SearchPage.new(@browser)
    search_result = search.google_search('sample search')
    assert(search_result.is_a?(SearchResultsPage), 'Browser not displaying results page on non-blank term.')
  end
end
