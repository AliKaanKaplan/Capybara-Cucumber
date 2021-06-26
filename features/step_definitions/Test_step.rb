deneme_page = DENEME.new

Given('i visit page') do
  visit "deneme"
end



=begin
Given('i visit page {string}') do |site|
  visit site
  page.driver.browser.manage.window.maximize
end

When(/^Click Formula 1 menu button$/) do
  click_link("FORMULA 1")
  #find_link(link, :visible => :all).click
  #page.find('#notice_sent', visible: :all)
  #within_frame (".notification-wrapper")
  #  click "btn-later"
  driver = Selenium::WebDriver.for :chrome
  # driver.find_element(:id, 'notification-dlg').click
  # a = driver.switch_to.alert
  # if a.text == 'Daha Sonra'
  #   a.dismiss
  # else
  #   a.accept
  #   end
  #
  #  find(:id,"btn-later").click
  # page.driver.browser.switch_to.alert.accept
  # accept_alert(:object_i)
end
When(/^Check active header menu$/) do
  page.has_css?(".header-menu-item.active")
  # expect(page).to have_css("row bottom-banner-list")
end
When(/^Click Tenis menu button$/) do
  click_link("TENİS")
end

When(/^Hover "([^"]*)" menu button and select "([^"]*)"$/) do |menu, submenu|
  # a = within all(text:menu)
  # #page.driver.browser.action.move_to(a.native).perform
  # a.click
  a = page.find('div', text:menu).first
  a.click
  sleep 5
  b = all(submenu).first
  click_link(b)
  sleep 5
end
=end