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
#	  user  -  The parameter "user" is set to what is set/entered into
#            the Cucumer file. Like an assignment operator "Sandovar" takes the 
#            place of "([^"]*)" in the Cucumber file and is set == to "user" 
#            and used as the parameter within the kaikifs.backdoor
#
# Example:
#	  Given I backdoored as "Sandovar"
#
# Returns Nothing
Given /^I (?:am backdoored|backdoor) as "([^"]*)"$/ do |user|
  kaiki.pause
  kaiki.switch_default_content
  kaiki.backdoor_as user
end

# Public: Logs in as a user set in the Cucumber file as well set to 
#         either backdoored or backdoor depending on the tyranny operation.
#
# Parameters:
#	  title  -  The parameter "title" is set to what is set/entered into
#             the Cucumer file. Like an assignment operator "Admin" takes the 
#             place of "(.*)" in the Cucumber file and is set == to "title" 
#             and used as the parameter within the kaikifs.user_by_title
#
# Example:
#	  Given I backdoored as the "Admin"
#
# Returns Nothing
# Given /^I (?:am backdoored|backdoor) as the (.*)$/ do |title|
  # user = kaiki.user_by_title(title)
  # puts "The #{title} is #{user}"
  # kaiki.backdoor_as user
# end
# 
# Public: Sets a users login status as backdoor on login.
#
# Example:
#	  Given I login
#
# Returns Nothing
# Given /^I (?:am logged in|log in)$/ do
  # kaiki.backdoor_as kaiki.username
# end
# 
# 
# Public: Checks user and determins if @login method produces backdoor, 
#         this logs the user in as backdoor. Otherwise logs the user out and 
#         logs in via webauthorization with the user.
#
# Parameters:
#	  user  -  The parameter "user" is set to what is set/entered into
#            the Cucumer file. Like an assignment operator "Sandovar" takes the 
#            place of "([^"]*)" in the Cucumber file and is set == to "user" 
#            and used as the parameter within the kaikifs.login_as
#
# Example:
#	  Given I login as "Sandovar"
#
# Returns Nothing
# Given /^I (?:am logged in|log in) as "([^"]*)"$/ do |user|
  # kaiki.login_as user
# end
# 
#
# Public: Sets user title and logs in as user.
#
# Parameters:
#	  title  -  The parameter "title" is set to what is set/entered into
#             the Cucumer file. Like an assignment operator "Admin" takes the 
#             place of "(.*)" in the Cucumber file and is set == to "title" 
#             and used as the parameter within the kaikifs.user_by_title and set 
#             equal to "user" before being used as a parameter within the 
#             kaikifs.login_as
#
# Example:
#	  Given I login as the "Admin"
#
# Returns Nothing
# Given /^I (?:am logged in|log in) as the (.*)$/ do |title|
  # user = kaiki.user_by_title(title)
  # puts "The #{title} is #{user}"
  # kaiki.login_as user
# end
# 
#
# Public: Sets user title and accounts value to the user.
#
# Parameters:
#	  title  -  The parameter "title" is set to what is set/entered into
#             the Cucumer file. Like an assignment operator "Admin" takes the 
#             place of "(.*)" in the Cucumber file and is set == to "title" 
#             and used as the parameter within the kaikifs.user_by_title and set 
#             equal to "user" before being used as a parameter within the 
#             kaikifs.user_by_sinngularized_title
#
# Example:
#	  Given I login as a "Admin"
#
# Returns Nothing
# Given /^I (?:am logged in|log in) as a (.*)$/ do |title|
  # user = kaiki.user_by_singularized_title(title)
  # puts "The #{title} is #{user}"
  # kaiki.login_as user
# end
