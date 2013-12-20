# Description:  This file contains everything pertaining to logging in
#               to the UofA kuali websites. This assumes the WebAuth system is
#               in place.
#
# Original Date: August 20, 2011

# KC  all features

# Description: Backdoors as the given username to the Kuali system.
#
# Parameters:
#	  username - Desired user to be backdoored as
#
# Example:
#	  Given I backdoored as "Sandovar"
#
# Returns nothing.
Given(/^I (?:am backdoored|backdoor) as "([^"]*)"$/) do |username|
  kaiki.pause
  kaiki.switch_default_content
  kaiki.backdoor_as(username)
end

# KFS all features

# Description: Calls the capybara_driver method "login_as" and passes two parameters
#         to it, user and the "type" of log in to perform.
#         ***At the moment if this step is used by Jenkins test (or other CI
#            environment that exports a build number) it will log out and
#            relog using WebAuth.
#            If the test is run elsewhere, it backdoors using the given
#            username from the feature file.
#
# Parameters:
#	  username - Desired user to be logged in as
#
# Example:
#	  Given I login as "Sandovar"
#
# Returns nothing.
Given (/^I (?:am logged in|log in) as "(.*?)"$/) do |username|
  kaiki.pause
  kaiki.switch_default_content
  if ENV['BUILD_NUMBER'].nil?
    kaiki.login_as(username, :backdoor)
  else
    kaiki.login_as(username)
  end

end

# Description: Logs in the user that kicked off the tests to WebAuth using the
#              existing username and password
#
# Returns nothing.
Then(/^I log in to Web Auth$/) do
  username = kaiki.username
  password = kaiki.password
  kaiki.login_via_webauth_with(username, password)
end