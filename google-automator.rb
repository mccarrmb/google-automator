require 'selenium-webdriver'
require 'page-object'
require 'page-object/page_factory'
require 'minitest/autorun'
require 'minitest/unit'
require_relative './lib/os.rb'

class GoogleTest < Minitest::Test

  log_directory = File.join(File.dirname(__FILE__), "log")
  Dir.mkdir(log_directory) unless File.exists?(log_directory)
  Selenium::WebDriver.logger.level = :debug
  Selenium::WebDriver.logger.output = File.join(File.dirname(__FILE__), "log", "selenium.log")
  
  def setup
    Selenium::WebDriver::Firefox.driver_path = (File.join(\
      File.dirname(__FILE__), "bin", "firefox", (OS.is_macos?) ? \
      "geckodriver-v0.20.1-macos" : "geckodriver-v0.20.1-linux64", \
      "geckodriver"))
    opts = Selenium::WebDriver::Firefox::Options.new()
    opts.headless!
    @browser = Selenium::WebDriver.for :firefox
    @browser
  end

  def teardown
    @browser != nil ? @browser.quit : false
  end

end
