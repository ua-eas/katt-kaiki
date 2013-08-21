# Description: This file holds all of the step_definitions pertaining
#              to navigating the browser webpage; i.e. clicking buttons and
#              links, moving to different parent tabs and toggling Show/Hide
#              tabs.
#              * Everything marked as '# WD' is from the old WebDriver Base
#              * file, and is not currently in use
#
# Original Date: August 20th, 2011


# Public: Switches to the outermost content on the page
#
# Returns: nothing
#
Given /^I am up top$/ do
  kaiki.switch_default_content
end

# Public: Changes to the given parent tab at the top of the page
#
# Parameters: 
#   tab - Name of tab to be switched to
#
# Returns: nothing
#
Given /^I am on the "([^"]*)" tab$/ do |tab|
  kaiki.pause
  kaiki.switch_default_content
  kaiki.click tab
end

# Public: Changes to the given child tab at the top of the document
#
# Parameters:
#   tab - Name of tab to be switched to
#
# Returns: nothing
#
When(/^I am on the "([^"]*)" document tab$/) do |tab|
  kaiki.pause
  kaiki.switch_default_content
  kaiki.select_frame "iframeportlet"
  kaiki.click tab
end

# Public: Clicks the appropriate portal link on the page
#
# Parameters:
#   link - Portal link to be clicked
#
# Returns: nothing
#
When /^I click the "([^"]*)" portal link$/ do |link|
  kaiki.pause
  kaiki.click link
end

# Public: Takes the name of the button and clicks on the button with that name
#
# Parameters:
#   item - name of the item to be clicked
#
# Returns: nothing
#
When /^I click the "([^"]*)" button$/ do |item|
  kaiki.pause
  # kaiki.switch_default_content
  # kaiki.select_frame "iframeportlet"
  item = item.downcase
  if item == 'create_new'
    kaiki.click item
  elsif ['approve', 'cancel', 'disapprove', 'search', 'submit', 'close', 'save', 'reload'].include? item
     kaiki.click item
  elsif ['calculate', 'continue', 'print'].include? item  # titleize or capitalize... this remains to be seen
     kaiki.click item
  elsif ['get document'].include? item
    button = kaiki.find(:name, "methodToCall.#{link.gsub(/ /, '_').camelize(:lower)}")
    button.click
  elsif item == 'yes'
    button = kaiki.find(:name, 'methodToCall.processAnswer.button0')
    button.click
  elsif item == 'no'
    button = kaiki.find(:name, 'methodToCall.processAnswer.button1')
    button.click
  elsif item == 'add person'
    button = kaiki.find(:name, 'methodToCall.insertProposalPerson')
    button.click
  elsif item == 'employee search lookup'
    button = kaiki.find(
      :name,
      "methodToCall.performLookup.(!!org.kuali.kra.bo.KcPerson!!).(((personI" \
      "d:newPersonId))).((``)).((<>)).(([])).((**)).((^^)).((&&)).((//)).((~" \
      "~)).(::::;;::::).anchor")
    button.click
  elsif item == 'non-employee search lookup'
    button = kaiki.find(
      :name,
      "methodToCall.performLookup.(!!org.kuali.kra.bo.NonOrganizationalRolo" \
      "dex!!).(((rolodexId:newRolodexId))).((``)).((<>)).(([])).((**)).((^^" \
      ")).((&&)).((//)).((~~)).(::::;;::::).anchor")
    button.click
  elsif item == 'turn on validation'
    button = kaiki.find(:name, 'methodToCall.activate')
    button.click
  elsif item == 'document search'
    button = kaiki.find(:xpath,'/html/body/div[5]/div/div/a[3]')
    button.click
  elsif item == 'document link'
    button = kaiki.find(
      :xpath,
      '/html/body/form/table/tbody/tr/td[2]/table/tbody/tr/td/a')
    button.click
  else
    raise NotImplementedError
  end
end

# Public: Specific to buttons that may appear multiple times on a document page
#         or have a different name, id or title on different pages
#
# item - name of the button
# tab - tab on the document page
#
# Returns: nothing
When /^I click the "([^"]*)" button on the "([^"]*)" tab$/ do |item, tab|
  kaiki.pause
  item = item.downcase
  if item == 'add'
    case tab
    when "Budget Versions"
      kaiki.click_by_xpath("//input[@name = 'methodToCall."                 \
                           "addBudgetVersion']", "button")
    when "Special Review"
      kaiki.click_by_xpath("//input[@name = 'methodToCall.addSpecialReview."\
                           "anchorSpecialReview']", "button")
    end
  elsif item == 'recalculate'
    kaiki.click_by_xpath("//input[@name = 'methodToCall."                   \
                "recalculateBudgetPeriod.anchorBudgetPeriodsTotals']", "button")
  end
end

# Public: Clicks the appropriate button or link, given by name, id or title,
#         which appears under a certain field
#
# name - name, id or title of button or link
# field - field in which the button should be
#
# Return: nothing
When /^I click "([^"]*)" on "([^"]*)"$/ do |name, field|
  kaiki.pause
  kaiki.should have_content field
  kaiki.click "open budget"
end
