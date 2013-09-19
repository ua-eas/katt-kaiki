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
When(/^I click "([^"]*)" (?:on the "([^"]*)" (?:tab|for "([^"]*)"))$/)         \
  do |option, name, extra|
  kaiki.pause
  if option == "Show"
    kaiki.show_tab(name)
  elsif option == "Hide"
    kaiki.hide_tab(name)
  else
    raise NotImplementedError
  end
end

# Public: This function is to click on the show/hide button for a section
#         within a tab.
#
# Parameters:
#    tab     - this is the tab to look into
#    section - this is the section we want to show/hide
#    option  - this is the action we want to perform
#
# Returns nothing.
When(/^I click "(.*?)" on the "(.*?)" section under "(.*?)"$/)                 \
  do |option, section, tab|
  kaiki.pause
  kaiki.switch_default_content
  kaiki.select_frame("iframeportlet")
  if option == "Show"
    action = "'open #{section}'"
  elsif option == "Hide"
    action = "'close #{section}'"
  else
    raise NotImplementedError
  end
  factory1 =
    ApproximationsFactory.transpose_build(
      "//%s[contains(text(), '#{tab}')]/%s[text()[contains(., '#{section}')]]" \
        "/input[contains(@title, #{action})]",
      ['tbody/tr/td/h2',    '../../../../following-sibling::div/descendant::tbody/tr/td/div' ],
      ['td/div',            '../../following-sibling::tr/td/div' ])
  approximate_xpath = factory1
  element = kaiki.find_approximate_element(approximate_xpath)
  element.click
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
      "//h2[contains(text(), '#{tab}')]"                                       \
        "/../following-sibling::*//input[contains(@title, 'inactive')]")
  end
end

# Public: This function is to click on the show/hide button for a section
#         within a tab.
#
# Parameters:
#    option     - this is the action we want to perform 
#    section - this is the section we want to show/hide
#    table - this is the table to look into
#    row - this is the row on where the action should occur
#
# Returns nothing.
When(/^I click "(.*?)" on the "(.*?)" section under the "(.*?)" table for row "(.*?)"$/)                 \
  do |option, section, table, row|
  kaiki.pause
  kaiki.switch_default_content
  kaiki.select_frame("iframeportlet")
  if option == "Show"
    action = "'open #{section}'"
  elsif option == "Hide"
    action = "'close #{section}'"
  else
    raise NotImplementedError
  end 
  factory1 = 
    ["//tbody/tr/td/h2[contains(text(), '#{table}')]/../../../.."              \
    "/following-sibling::div/div/table/tbody/tr/th[contains(text(), '#{row}')]"\
    "/../following-sibling::tr/td/div[text()[contains(., '#{section}')]]/input"\
    "[contains(@title, #{action})]"]
  
  approximate_xpath = factory1
  element = kaiki.find_approximate_element(approximate_xpath)
  element.click
end
