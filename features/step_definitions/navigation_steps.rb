# Description: This file holds all of the step_definitions pertaining
#              to navigating the browser webpage; i.e. clicking buttons and
#              links, moving to different parent tabs and toggling Show/Hide
#              tabs.
#              * Everything marked as '# WD' is from the old WebDriver Base
#              * file, and is not currently in use
#
# Original Date: August 20th, 2011


# Public: Starts up the video if the test is being run headless, retrieves
#         today's date for relevant tests then switches focus to the
#         outermost page content.
#
# Returns nothing.
Given(/^I am up top$/) do
  kaiki.switch_default_content
end

# Public: Changes to the given parent tab at the top of the page
#
# Parameters:
#   sys_tab - title of system tab to be switched to
#
# Returns nothing.
Given(/^I am on the "([^"]*)" system tab$/) do |sys_tab|
  kaiki.pause
  kaiki.switch_default_content
  kaiki.click_approximate_field(["//a[@title='#{sys_tab}']"])
end

# Public: Clicks the appropriate portal link on the page
#
# Parameters:
#   link - portal link to be clicked
#
# Returns nothing.
When(/^I (?:click|click the) "([^"]*)" portal link$/) do |link|
  kaiki.pause
  kaiki.click_approximate_field(
    ["//td[contains(text(), '#{link}')]/following-sibling::td/a[1]"])
end

# Public: Takes the name of the button and clicks on the button with that name
#
# Parameters:
#   item        - name of the item to be clicked
#   field       - name of the field a particular button/link associated with
#                 said field may have
#   line_number - possible line number the field may show up on
#   subsection  - subsection of the page the radio should be in
#
# Returns nothing.
When(/^I (?:click|click the) "(.*?)" (?:button|on "(.*?)")(?:| on line "(.*?)")(?:| (?:under|in) the "(.*?)" subsection)$/)\
  do |button, field, line_number, subsection|

  kaiki.get_ready
  current_page.click_button(button, field, line_number, subsection)
end

# Public: Selects the radio button next to the option that is given by
#         using the approximation factory to find the xpath to the radio
#         button.
#
# Parameters:
#   field      - name of the label associated with the radio button
#   subsection - subsection of the page the radio should be in
#
# Returns nothing.
When (/^I click the "([^"]*)" radio button(?:| (?:under|in) the "(.*?)" subsection)$/)\
  do |field, subsection|

  kaiki.get_ready
  current_page.click_radio_button(field, subsection)
end

# Public: Locates and clicks the link on the page
#
# Parameters:
#   link - name of the link to click
#
# Returns nothing.
When(/^I (?:click|click the) "([^"]*)" link$/) do |link|
  kaiki.pause
  kaiki.click_approximate_field(["//a[@title = '#{link}']"])
end