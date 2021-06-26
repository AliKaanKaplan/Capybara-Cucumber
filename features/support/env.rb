require 'cucumber'
require 'capybara'
require 'capybara/dsl'
require 'rspec'
require 'selenium-webdriver'

include Capybara::DSL
include RSpec::Matchers

RSpec.configure do |config|
  config.include Capybara::DSL, type: :feature
end

Capybara.configure do |config|
  config.app_host = 'https://regression-www.beinconnect.com.tr'
  config.default_selector = :css
  config.default_max_wait_time = 10
  config.default_driver = :selenium
end
