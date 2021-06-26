Before do |scenario|
  options = Selenium::WebDriver::Chrome::Options.new
  #options.add_argument('--headless')
#      options.add_argument('--windows-size=1920,1080')
#      options.add_argument('--disable-popup-blocking')
#      options.add_argument('--ignore-certificate-errors')

  Capybara.register_driver :Selenium do |app|
    Capybara::Selenium::Driver.new(app,
                                   browser: :chrome,
                                   options: options)
  end

  page.driver.browser.manage.windows.maximize
  puts "Scenario running: #{scenario.name}"
end

After do |scenario|
  scenario_name = scenario.name.gsub(/[^A-Za-z0-9 ]/, '').gsub(/\s+/, '-')

  if scenario.failed?
    puts "FAILED ==> Feature: #{scenario.feature.name} => Scenario: #{scenario_name}"
    puts "EXCEPTION_MESSAGE =>> #{scenario.exception.message}"
  else
    puts "PASSED ==> Feature: #{} =>> Scenario: #{scenario_name}"
  end
  Capybara.current_session.driver.quit
end
