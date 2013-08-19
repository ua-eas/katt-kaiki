# Description: This file houses the interpretation of verification steps used 
#              by Cucumber features.
#
# Original Date: August 20, 2011


# Public: The following Webdriver code tells kaikifs to check for the specified 
#         message at the top of the page.
#
# Parameters:
#   text - the user's specified text.
#
# Returns nothing.
Then /^I should see the message "([^"]*)"$/ do |text|
  kaiki.pause
  kaiki.switch_default_content
  kaiki.select_frame "iframeportlet"
  kaiki.wait_for(:xpath, "//div[@class='msg-excol']")
  kaiki.should have_content text
end

# Public: Verifies given text is present in the document header
#
# where  -  loction of the text to be verified
# text  -  text to be verified
#
# Returns: nothing 
Then /^I should see "([^"]*)" set to "([^"]*)" in the document header$/\
  do |where, text|
  kaiki.pause
  kaiki.switch_default_content
  kaiki.select_frame "iframeportlet"
  kaiki.wait_for(:xpath, "//div[@class='headerbox']")
  kaiki.should have_content text
end

# Public: Verifies given text is present under the sponsor code
#
# Parameters:
#   text  -  text to be verified
#
# Returns: nothing  
Then /^I should see "([^"]*)" under the sponsor code$/ do |text|
  kaiki.pause
  kaiki.switch_default_content
  kaiki.select_frame "iframeportlet"
  kaiki.wait_for(:xpath, "//*[@id='sponsorName.div']")
  kaiki.should have_content text
end

# Public: The following Capybara code tells kaikifs to check for an item called
#         Action List on the page.
#
# Returns nothing.
#Then /^I should see my Action List$/ do
  #kaiki.pause(1)
  #kaiki.should have_content("Action List")
#end

# Public: The following Capybara code tells kaikifs to check for the specified 
#         text on the page.
#
# Parameters:
#   text - the user's specified text.
#
# Returns nothing.
#Then /^I should see "([^"]*)"$/ do |text|
  #kaiki.pause(1)
  #kaiki.should have_content(text)
#end

# Public: The following Webdriver code tells kaikifs to check for the specified 
#         text in the specified iframe.
#
# Parameters:
#   text  - the user's specified text.
#   frame - the frame to search in.
#
# Returns nothing.
#Then /^I should see "([^"]*)" in the "([^"]*)" iframe$/ do |text, frame|
  #kaiki.select_frame(frame+"IFrame")
  #wait = Selenium::WebDriver::Wait.new(:timeout => 8)
  #wait.until { kaiki.find_element(:xpath, "//div[@id='workarea']") }
  #kaiki.should have_content(text)
  #kaiki.switch_to.default_content
  #kaiki.select_frame("iframeportlet")
#end

# Public: The following Webdriver code tells kaikifs to check for the specified 
#         text in the route log section of the page.
#
# Parameters:
#   text - the user's specified text.
#
# Returns nothing.
#Then /^I should see "([^"]*)" in the route log$/ do |text|
  #refresh_tries = 5
  #wait_time = 1

  #kaiki.select_frame("routeLogIFrame")
  #begin
    #wait = Selenium::WebDriver::Wait.new(:timeout => 4).
      #until { kaiki.find_element(:xpath, "//div[@id='workarea']") }
    #if kaiki.has_content? text
      #kaiki.should have_content(text)
    #end
  #rescue Selenium::WebDriver::Error::TimeOutError => command_error
    #puts "#{refresh_tries} retries left... #{Time.now}"
    #refresh_tries -= 1
    #if refresh_tries == 0
      #kaiki.should have_content(text)
    #end

    #kaiki.click_and_wait :alt, "refresh"  # 'refresh'
    #kaiki.pause wait_time
    #retry
  #ensure
    #kaiki.switch_to.default_content
    #kaiki.select_frame("iframeportlet")
  #end
#end

# Public: The following Capybara code tells kaikifs to check for the specified 
#         text in the specified element.
#
# Parameters:
#   text  - the user's specified text.
#   el    - the element to search.
#
# Returns nothing.
#Then /^I should see "([^"]*)" in "([^"]*)"$/ do |text, el|
  #kaiki.select_frame("iframeportlet")
  #puts kaiki.wait_for_text(text, :element => el, :timeout_in_seconds => 30);
  #kaiki.switch_to.default_content
#end

# Public: The following Capybara code tells kaikifs to check for an HTTP Status 
#         message. If there is one, it is bad.
#
# Parameters:
#   status_no - the status number to be checked for.
#
# Returns nothing.
#Then /^I shouldn't get an HTTP Status (\d+)$/ do |status_no|
  #kaiki.should_not have_content("HTTP Status #{status_no}")
#end

# Public: The following Webdriver code tells kaikifs to check for an incident 
#         report. If there is one, it's bad.
#
# Returns nothing.
#Then /^I shouldn't see an incident report/ do
  #kaiki.should_not have_content('Incident Report')
#end
