#
# Description:  This login_steps.rb file is the framework for the 
#               connection between the Cucumber file and the Ruby 
#               methods for user login information.
# 
# Original Date: August 20, 2011
#

# Public: Logs in as a user set in the Cucumber file as well set to 
#         either backdoored or backdoor depending on the tyranny operation. 
#
# Parameters:
#   user  -  The parameter "user" is set to what is set/entered into
#            the Cucumer file. Like an assignment operator "Sandovar" takes the 
#            place of "([^"]*)" in the Cucumber file and is set == to "user" 
#            and used as the parameter within the kaikifs.backdoor
#
# Example:
#	  Given I backdoored as "Sandovar"
#
# Returns Nothing
#
Given /^I (?:am backdoored|backdoor) as "([^"]*)"$/ do |user|
  kaiki.pause
  kaiki.switch_default_content
  kaiki.backdoor_as user
end
