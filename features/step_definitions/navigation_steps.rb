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
# Returns nothing.
Given(/^I am up top$/) do
  kaiki.switch_default_content
end

# Public: Changes to the given parent tab at the top of the page
#
# Parameters:
#   tab - Name of tab to be switched to
#
# Returns nothing.
Given(/^I am on the "([^"]*)" tab$/) do |tab|
  kaiki.pause
  kaiki.switch_default_content
  kaiki.click(tab)
end

# Public: Changes to the given child tab at the top of the document
#
# Parameters:
#   tab - Name of tab to be switched to
#
# Returns nothing.
When(/^I am on the "([^"]*)" document tab$/) do |tab|
  kaiki.pause
  kaiki.switch_default_content
  kaiki.select_frame("iframeportlet")
  kaiki.click(tab)
end

# Public: Clicks the appropriate portal link on the page
#
# Parameters:
#   link - Portal link to be clicked
#
# Returns nothing.
When(/^I (?:click|click the) "([^"]*)" portal link$/) do |link|
  kaiki.pause
  element = kaiki.find(:xpath, "//td[contains(text(), '#{link}')]"            \
                               "/following-sibling::td/a[1]")
  element.click
end

# Public: Takes the name of the button and clicks on the button with that name
#
# Parameters:
#   item  - name of the item to be clicked
#   field - name of the field a particular button/link associated with said
#           field may have
#
# Returns nothing.
When(/^I (?:click|click the) "([^"]*)" (?:button|(?:on|to) "([^"]*)")$/)      \
  do |item, field|
  kaiki.pause
  item = item.downcase
  if item == 'create_new'
    kaiki.click item
  elsif ['approve', 'cancel', 'disapprove', 'search', 'submit', 'close',      \
    'save', 'reload'].include? item
    kaiki.click item
  elsif ['calculate', 'continue', 'print', 'blanket approve'].include? item
    kaiki.click item
  elsif ['get document'].include? item
    kaiki.find(:name, "methodToCall.#{link.gsub(/ /, '_').camelize(:lower)}") \
      .click
  elsif item == 'yes'
    kaiki.find(:name, 'methodToCall.processAnswer.button0').click
  elsif item == 'no'
    kaiki.find(:name, 'methodToCall.processAnswer.button1').click
  elsif item == 'add person'
    kaiki.find(:name, 'methodToCall.insertProposalPerson').click
  elsif item == 'recalculate'
    kaiki.find(
      :xpath,
      "//input[contains(@name, 'methodToCall.recalculate')]")
        .click
  elsif item == 'turn on validation'
    kaiki.find(:name, 'methodToCall.activate').click
  elsif item == 'submit to sponsor'
    kaiki.find(:name, 'methodToCall.submitToSponsor').click
  elsif item == 'document search'
    kaiki.find(:xpath,'/html/body/div[5]/div/div/a[3]').click
  elsif item == 'document link'
    kaiki.find(
      :xpath,
      '/html/body/form/table/tbody/tr/td[2]/table/tbody/tr/td/a')
        .click
  elsif item == 'return to proposal'
    kaiki.click item
  elsif item == 'open'
    kaiki.should(have_content(field))
    approximate_xpath =
      ApproximationsFactory.transpose_build(
        "//%s[contains(text(), '#{field}')]/following-sibling::"              \
        "td/div/%s[contains(@alt, 'open budget')]",
        ['td',    'select' ],
        ['th',    'input'  ])
    kaiki.click_approximate_field(approximate_xpath, "button")
  elsif item == 'apply'
    if field != nil
      field = field.gsub(/\s/,'')
    end
    kaiki.find(
      :xpath,
      "//input[contains(@name, 'methodToCall.apply#{field}')]")
        .click
  elsif item == 'add'
    if field != nil
      field = field.gsub(/\s/,'')
      field = field.chop
    end
    kaiki.find(
      :xpath,
      "//input[contains(@name, 'methodToCall.add#{field}')]")
        .click
  elsif item == 'time & money'
    kaiki.find(:name, 'methodToCall.timeAndMoney').click
  elsif item == 'return to award'
    kaiki.find(:name, 'methodToCall.returnToAward').click
  else
    raise NotImplementedError
  end
end

# Public: Returns the chosen result from a search query
#
# Known Issue: This function will click the 'return value' link on the first
#              row that contains the value anywhere on the data row. Capybara
#              version 2+ has a method to extract the xpath from a Capybara
#              element to do string manipulation and find the correct column to
#              look in. If there is a way to do this in Capybara v1.1.4 which
#              is currently in use, this is remains elusive.
#
# Parameters:
#   column - the column to look in
#   value  - result to be returned
#
# Returns nothing.
When(/^I return the record with "(.*?)" of "(.*?)"$/) do |column, value|
  kaiki.pause
  kaiki.switch_default_content
  kaiki.select_frame("iframeportlet")
  approximate_xpath =
    ApproximationsFactory.transpose_build(
      "//%s[contains(text(),'#{column}')]/%s[contains(text(),'#{value}')]/"   \
      "%s[contains(text(),'return value')]",
      ['th/a', '../../../following-sibling::tbody/tr/td/a', '../../td/a'],
      [nil,    nil,                                         nil         ])
  element = kaiki.find_approximate_element(approximate_xpath)
  element.click
end

# Public: Takes the name of the button and clicks on the button with that name
#
# Parameters:
#   item  - name of the item to be clicked
#
# Returns nothing.
When(/^I start a lookup for "(.*?)"$/) do |item|
  kaiki.pause
  item = item.downcase
  case item
  when 'employee'
    element = kaiki.find(:name, "methodToCall.performLookup.(!!org.kuali.kra.bo.KcPerson!!).(((personId:newPersonId))).((``)).((<>)).(([])).((**)).((^^)).((&&)).((//)).((~~)).(::::;;::::).anchor")
    element.click
  when 'non-employee'
    element = kaiki.find(:name, "methodToCall.performLookup.(!!org.kuali.kra.bo.NonOrganizationalRolodex!!).(((rolodexId:newRolodexId))).((``)).((<>)).(([])).((**)).((^^)).((&&)).((//)).((~~)).(::::;;::::).anchor")
    element.click
  when 'institutional proposal id'
    element = kaiki.find(:name, "methodToCall.performLookup.(!!org.kuali.kra.institutionalproposal.home.InstitutionalProposal!!).(((proposalId:fundingProposalBean.newFundingProposal.proposalId))).((`fundingProposalBean.newFundingProposal.proposalNumber:proposalNumber`)).((<>)).(([])).((**)).((^^)).((&&)).((//)).((~~)).(::::;;::::).anchorFundingProposals")
    element.click
  when 'sponsor template code'
    element = kaiki.find(:name, "methodToCall.performLookup.(!!org.kuali.kra.award.home.AwardTemplate!!).(((templateCode:document.award.templateCode,description:document.award.awardTemplate.description))).((``)).((<>)).(([])).((**)).((^^)).((&&)).((//)).((~~)).(::::;;::::).anchor61")
    element.click
  when 'award id'
    element = kaiki.find(:name, "methodToCall.performLookup.(!!org.kuali.kra.award.home.Award!!).(((awardNumber:document.developmentProposalList[0].currentAwardNumber))).((``)).((<>)).(([])).((**)).((^^)).((&&)).((//)).((~~)).(::::;;::::).anchorRequiredFieldsforSavingDocument")
    element.click
  else
    raise NotImplementedError
  end
end

# Public: Performs an action on the first record in the table.
#
# Parameters:
#   action - This is the action to be performed on the first record.
#
# Returns nothing.
When(/^I "(.*?)" the first record$/) do |action|
  kaiki.pause
  kaiki.switch_default_content
  kaiki.select_frame("iframeportlet")
  element = kaiki.find(:xpath, "//a[contains(text(), '#{action}')]")
  element.click
end
