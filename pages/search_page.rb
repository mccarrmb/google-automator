require 'selenium-webdriver'
require 'page-object'
require_relative 'base_page.rb'
require_relative 'search_results_page.rb'

# Page object for the Google landing page
class SearchPage < BasePage
  include PageObject

  text_field(:search_field, name: 'q')
  button(:search, value: 'Google Search')
  button(:lucky, value: 'I\'m Feeling Lucky')

  def google_search(terms)
    self.search_field = terms
    self.search
    if terms.empty?
      SearchPage.new(@browser)
    else
      SearchResultsPage.new(@browser)
    end
  end
end
