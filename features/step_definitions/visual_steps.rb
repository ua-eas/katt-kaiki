# Description: This file houses the interpretation of visual steps used by 
#              Cucumber features.
#
# Original Date: August 20, 2011


# Public: Clicks on "Show/Hide" on the specific tab
#
# Parameters: 
#   option - "Show" or "Hide"
#   value  - Which tab is being toggled
#
# Returns nothing.
When(/^I click "([^"]*)" on the "([^"]*)" (?:tab|section)$/) do |option, name|
  kaiki.pause
  if option == "Show"
    kaiki.show_tab(name)
  elsif option == "Hide"
    kaiki.hide_tab(name)
  else
    raise NotImplementedError
  end
end

# Public: The following Webdriver code tells the kaikifs show an Item's
#         sub-item based on its ordered position.
#
# Parameters:
#   ordinal - this is the ordinal provided by the user (1,2,3,4,etc).
#   tab     - this is the sub-item specified.
#
# Returns nothing.
When(/^I show the ([0-9a-z]+) Item's "([^"]*)"/i) do |ordinal, tab|
  numeral = EnglishNumbers::ORDINAL_TO_NUMERAL[ordinal]
  xpath = 
    "//td[contains(text(), 'Item #{numeral}')]" \
    "/../following-sibling::tr//div[contains(text()[2], '#{tab}')]//input"
  showHide = kaiki.find(:xpath, xpath)
  if showHide[:alt] == 'hide'
    # It's already shown!
  else
    showHide.click
  end
  sleep(3)
end

# Public: The following Webdriver code tells the kaikifs to click on a form
#         item that is within another element.
#
# Parameters:
#   button  - this is the item to be clicked on.
#   tab     - this is the element that the button is inside.
#
# Returns nothing.
When(/^I click "([^"]*)" under (.*)$/) do |button, tab|
  case
  when button =~ /inactive/
    kaiki.click_and_wait(
      :xpath, 
      "//h2[contains(text(), '#{tab}')]"\
      "/../following-sibling::*//input[contains(@title, 'inactive')]")
  end
end
