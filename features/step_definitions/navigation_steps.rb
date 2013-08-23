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
When /^I (?:click|click the) "([^"]*)" portal link$/ do |link|
  kaiki.pause
  kaiki.click link
end

# Public: Takes the name of the button and clicks on the button with that name
#
# item - name of the item to be clicked
# field - name of the field a particular button/link associated with said field
#         may have
#
# Returns: nothing
#
When /^I (?:click|click the) "([^"]*)" (?:button|on "([^"]*)")$/ do |item, field|
  kaiki.pause
  
  item = item.downcase
  if item == 'create_new'
    kaiki.click item
  elsif ['approve', 'cancel', 'disapprove', 'search', 'submit', 'close', 'save', 'reload'].include? item
     kaiki.click item
  elsif ['calculate', 'continue', 'print', 'blanket approve'].include? item  # titleize or capitalize... this remains to be seen
     kaiki.click item
  elsif ['get document'].include? item
    kaiki.find(:name, "methodToCall.#{link.gsub(/ /, '_').camelize(:lower)}").click
  elsif item == 'yes'
    kaiki.find(:name, 'methodToCall.processAnswer.button0').click
  elsif item == 'no'
    kaiki.find(:name, 'methodToCall.processAnswer.button1').click
  elsif item == 'add person'
    kaiki.find(:name, 'methodToCall.insertProposalPerson').click
  elsif item == 'employee search lookup'
    kaiki.find(
      :name,
      "methodToCall.performLookup.(!!org.kuali.kra.bo.KcPerson!!).(((personI" \
      "d:newPersonId))).((``)).((<>)).(([])).((**)).((^^)).((&&)).((//)).((~" \
      "~)).(::::;;::::).anchor").click
  elsif item == 'non-employee search lookup'
    kaiki.find(
      :name,
      "methodToCall.performLookup.(!!org.kuali.kra.bo.NonOrganizationalRolo" \
      "dex!!).(((rolodexId:newRolodexId))).((``)).((<>)).(([])).((**)).((^^" \
      ")).((&&)).((//)).((~~)).(::::;;::::).anchor").click
  elsif item == 'recalculate'
    kaiki.click_by_xpath("//input[@name = 'methodToCall."                   \
                "recalculateBudgetPeriod.anchorBudgetPeriodsTotals']", "button")
  elsif item == 'turn on validation'
    kaiki.find(:name, 'methodToCall.activate').click
  elsif item == 'submit to sponsor'
    kaiki.find(:name, 'methodToCall.submitToSponsor').click
  elsif item == 'document search'
    kaiki.find(:xpath,'/html/body/div[5]/div/div/a[3]').click
  elsif item == 'document link'
    kaiki.find(
      :xpath,
      '/html/body/form/table/tbody/tr/td[2]/table/tbody/tr/td/a').click
  elsif item == "return to proposal"
    kaiki.click item
  elsif item == 'open'
    kaiki.should have_content field
    kaiki.click_approximate_field(
      ApproximationsFactory.transpose_build(
      "//%s[contains(text()%s, '#{field}')]/following-sibling::"              \
      "td/div/%s[contains(@alt, 'open budget')]",
      ['td',    '',       'select'],
      ['th',    '[1]',    'input'],
      [nil,     '[2]',    nil]
      ),
      "button"
    )  
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
When /^I (?:click|click the) "([^"]*)" button on the "([^"]*)" tab$/ do |item, tab|
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
  end
end

# Public: Returns the chosen result from a search query
#
# Parameters:
#   column - the column to look in
#   value  - result to be returned
#
# Returns: nothing
#
 When /^I return the record with "(.*?)" of "(.*?)"$/ do |column, value|
  kaiki.pause
  kaiki.switch_default_content
  kaiki.select_frame("iframeportlet")

  link = kaiki.find(:xpath, "//thead/tr/th/a[contains(text(),'#{column}')]/." \
    "./../../following-sibling::tbody/tr/td/a[contains(text(),'#{value}')]/." \
    "./../td/a[contains(text(),'return value')]")
  link.click
end
