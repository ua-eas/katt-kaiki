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
When(/^I click "([^"]*)" (?:on the "([^"]*)" (?:tab|for "([^"]*)"))$/)        \
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
When(/^I click "(.*?)" on the "(.*?)" section under "(.*?)"$/)                \
  do |option, section, tab|
  kaiki.pause
  kaiki.switch_default_content
  kaiki.select_frame("iframeportlet")

  if option == "Show"
    approximate_xpath =
      ApproximationsFactory.transpose_build(
        "//%s[contains(text(), '#{tab}')]/%s[text()[contains(., '#{section}')]]/input[@title='open #{section}']",
        ['tbody/tr/td/h2',    '../../../../following-sibling::div/descendant::tbody/tr/td/div' ],
        ['td/div',            '../../following-sibling::tr/td/div' ])
    element = kaiki.find_approximate_element(approximate_xpath)
    element.click
  elsif option == "Hide"
    approximate_xpath =
      ApproximationsFactory.transpose_build(
        "//%s[contains(text(), '#{tab}')]/%s[contains(., '#{section}')]/input[@title='close #{section}']",
        ['tbody/tr/td/h2',    '../../../../following-sibling::div/descendant::tbody/tr/td/div' ],
        ['td/div',            '../../following-sibling::tr/td/div' ])
    element = kaiki.find_approximate_element(approximate_xpath)
    element.click
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
