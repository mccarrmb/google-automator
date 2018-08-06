require 'selenium-webdriver'
require 'os'
require 'pry'
require_relative 'local.rb'
require_relative 'remote.rb'
require_relative 'app.rb'

module Config
  # Stores all relative paths for the repo's drivers by OS
  LOCAL_DRIVERS = {
    linux: {
      chrome: File.join(__dir__, '..', 'bin', 'chrome', 'chromedriver_linux64', 'chromedriver'),
      firefox: File.join(__dir__, '..', 'bin', 'firefox', 'geckodriver-v0.20.1-linux64', 'geckodriver')
    },
    macos: {
      chrome: File.join(__dir__, '..', 'bin', 'chrome', 'chromedriver_mac64', 'chromedriver'),
      firefox: File.join(__dir__, '..', 'bin', 'firefox', 'geckodriver-v0.20.1-macos', 'geckodriver'),
      safari: File.join('/', 'usr', 'bin', 'safaridriver')
    },
    windows: {
      chrome: File.join(__dir__, '..', 'bin', 'chrome', 'chromedriver_win32', 'chromedriver.exe'),
      firefox: File.join(__dir__, '..', 'bin', 'firefox', 'geckodriver-v0.20.1-win64', 'geckodriver.exe'),
      edge: File.join(__dir__, '..', 'bin', 'edge', 'microsoft_webdriver_win64', 'MicrosoftWebDriver.exe'),
      ie: File.join(__dir__, '..', 'bin', 'internet_explorer', 'IEDriverServer_Win32_3.9.0', 'IEDriverServer.exe')
    }
  }.freeze

  # Utilize OS gem to better detect host OS (required for running native drivers)
  def self.actual_os
    if OS::Underlying.windows?
      :windows
    elsif OS::Underlying.bsd?
      :macos
    elsif OS::Underlying.linux?
      :linux
    else
      raise UnsupportedOSError
        .new(OS.host_os, 'Your operating system is not supported')
    end
  end

  # Verifies if the browser and platform comination is valid
  def self.browser_valid?
    !LOCAL_DRIVERS[self.class.actual_os][@browser].nil?
  end

  # Make sure all of these files are executable
  def self.prep_binaries
    LOCAL_DRIVERS.each do |_os, apps|
      apps.each do |_app, path|
        File.chmod(0o755, path) unless File.executable?(path)
      end
    end
  end

  # Set driver binary paths to local copies
  def self.prep_paths
    os = actual_os
    WebDriver::Firefox.driver_path = LOCAL_DRIVERS[os][:firefox]
    WebDriver::Chrome.driver_path = LOCAL_DRIVERS[os][:chrome]
    if os == :macos
      WebDriver::Safari.driver_path = LOCAL_DRIVERS[:macos][:safari]
    elsif os == :windows
      WebDriver::Edge.driver_path = LOCAL_DRIVERS[:windows][:edge]
      WebDriver::IE.driver_path = LOCAL_DRIVERS[:windows][:ie]
    end
  end
end
