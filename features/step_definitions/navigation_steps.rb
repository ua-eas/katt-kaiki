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
  begin
    kaiki.select_frame("iframeportlet")
  rescue Selenium::WebDriver::Error::NoSuchFrameError
  end
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
  element = kaiki.find(
              :xpath,
              "//td[contains(text(), '#{link}')]/following-sibling::td/a[1]")
  element.click
end

# Public: Takes the name of the button and clicks on the button with that name
#
# Parameters:
#   link  - name of the item to be clicked
#
# Returns nothing.
When(/^I click the "(.*?)" search link$/) do |link|
  kaiki.pause
  element = kaiki.find(:xpath, "//td[contains(text(), '#{link}')]"             \
                               "/following-sibling::td/a[2]")
  element.click
end

# Public: Takes the name of the button and clicks on the button with that name
#
# Parameters:
#   item  - name of the item to be clicked
#   field - name of the field a particular button/link associated with said
#           field may have
#   extra - placeholder variable for any unecessary text that may appear at the
#           end of the sentence
#
# Returns nothing.
When(/^I (?:click|click the) "([^"]*)" (?:button|(?:on|to) "([^"]*)")([^"]*)$/)\
  do |button, field, extra|
  kaiki.pause
  item = button.downcase
  downcase_title_buttons =
    [
      "create_new",
      "approve",
      "cancel",
      "disapprove",
      "search",
      "submit",
      "close",
      "reload",
      "calculate",
      "continue",
      "print",
      "blanket approve",
      "save"
    ]
  downcase_alt_buttons =
    [
      "return to proposal"
    ]
  exact_match_buttons =
    [
      "Submit To Sponsor"
    ]
  if downcase_title_buttons.include? item
    element = kaiki.find(:xpath, "//input[@title='#{item}']")
  elsif downcase_alt_buttons.include? item
    element = kaiki.find(:xpath, "//input[@alt='#{item}']")
  elsif exact_match_buttons.include? button
    element = kaiki.find(:xpath, "//input[@title='#{button}']")
  elsif item == 'get document'
    element = kaiki.find(
      :name,
      "methodToCall.#{item.gsub(/ /, '_').camelize(:lower)}")
  elsif item == 'yes'
    element = kaiki.find(:name, 'methodToCall.processAnswer.button0')
  elsif item == 'no'
    element = kaiki.find(:name, 'methodToCall.processAnswer.button1')
  elsif item == 'add person'
    element = kaiki.find(:name, 'methodToCall.insertProposalPerson')
  elsif item == 'recalculate'
    element = kaiki.find(
      :xpath,
      "//input[contains(@name, 'methodToCall.recalculate')]")
  elsif item == 'turn on validation'
    element = kaiki.find(:name, 'methodToCall.activate')
  elsif item == 'document search'
    element = kaiki.find(:xpath,'/html/body/div[5]/div/div/a[3]')
  elsif item == 'document link'
    element = kaiki.find(
      :xpath,
      '/html/body/form/table/tbody/tr/td[2]/table/tbody/tr/td/a')
  elsif item == 'open'
    kaiki.should(have_content(field))
    approximate_xpath =
      ApproximationsFactory.transpose_build(
        "//%s[contains(text(), '#{field}')]"                                   \
          "/following-sibling::td/div/%s[contains(@alt, 'open budget')]",
        ['td',    'select' ],
        ['th',    'input'  ])
    element = kaiki.find_approximate_element(approximate_xpath)
  elsif item == 'apply'
    if field != nil
      field = field.gsub(/\s/,'')
    end
    element = kaiki.find(
      :xpath,
      "//input[contains(@name, 'methodToCall.apply#{field}')]")
  elsif item == 'add'
    if field != nil
      field = field.gsub(/\s/,'')
      field = field.chop
    end
    element = kaiki.find(
      :xpath,
      "//input[contains(@name, 'methodToCall.add#{field}')]")
  elsif item == 'time & money'
    element = kaiki.find(:name, 'methodToCall.timeAndMoney')
  elsif item == 'return to award'
    element = kaiki.find(:name, 'methodToCall.returnToAward')
  elsif item == 'open proposal'
    xpath = "//img[@title = '#{button}']"
    element = kaiki.find(:xpath, xpath)
  elsif item == 'edit'
	  element = kaiki.find(:name, 'methodToCall.editOrVersion')
  else
    raise NotImplementedError
  end
  element.click
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
      "//%s[contains(text(),'#{column}')]"                                     \
        "/%s[contains(text(),'#{value}')]"                                     \
        "/%s[contains(text(),'return value')]",
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
    element = kaiki.find(
      :name,
      "methodToCall.performLookup.(!!org.kuali.kra.bo.KcPerson!!).(((personId" \
        ":newPersonId))).((``)).((<>)).(([])).((**)).((^^)).((&&)).((//)).((~" \
        "~)).(::::;;::::).anchor")
    element.click
  when 'non-employee'
    element = kaiki.find(
      :name,
      "methodToCall.performLookup.(!!org.kuali.kra.bo.NonOrganizationalRolode" \
        "x!!).(((rolodexId:newRolodexId))).((``)).((<>)).(([])).((**)).((^^))" \
        ".((&&)).((//)).((~~)).(::::;;::::).anchor")
    element.click
  when 'institutional proposal id'
    element = kaiki.find(
      :name,
      "methodToCall.performLookup.(!!org.kuali.kra.institutionalproposal.home" \
        ".InstitutionalProposal!!).(((proposalId:fundingProposalBean.newFundi" \
        "ngProposal.proposalId))).((`fundingProposalBean.newFundingProposal.p" \
        "roposalNumber:proposalNumber`)).((<>)).(([])).((**)).((^^)).((&&)).(" \
        "(//)).((~~)).(::::;;::::).anchorFundingProposals")
    element.click
  when 'sponsor template code'
    element = kaiki.find(
      :name,
      "methodToCall.performLookup.(!!org.kuali.kra.award.home.AwardTemplate!!" \
        ").(((templateCode:document.award.templateCode,description:document.a" \
        "ward.awardTemplate.description))).((``)).((<>)).(([])).((**)).((^^))" \
        ".((&&)).((//)).((~~)).(::::;;::::).anchor61")
    element.click
  when 'award id'
    element = kaiki.find(
      :name,
      "methodToCall.performLookup.(!!org.kuali.kra.award.home.Award!!).(((awa" \
        "rdNumber:document.developmentProposalList[0].currentAwardNumber))).(" \
        "(``)).((<>)).(([])).((**)).((^^)).((&&)).((//)).((~~)).(::::;;::::)." \
        "anchorRequiredFieldsforSavingDocument")
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

# Public: Changes focus to the new browser window that is opened
#
# Returns nothing.
Then(/^a new browser window appears$/) do
	kaiki.pause
	kaiki.last_window_focus
end

# Public: This method resets the pause time between each cucumber step back to
#         0.5 seconds.
#
# Returns nothing.
When (/^I am fast$/) do
  kaiki.log.debug "Speeding up... (pause_time = 0)"
  kaiki.pause_time = 0.5
end

# Public: The method increases the pause time between each cucumber step by
#         2 seconds.
#
# Returns nothing.
When (/^I slow down$/) do
  kaiki.log.debug "Slowing down... (pause_time = #{kaiki.pause_time + 2})"
  kaiki.pause_time += 2
end

# Public: Due to the order of the tests we are running, we need this method to
#         sort the award search list so that the most recent "fresh" copy
#         appears at the top of the list.
#
# Returns nothing.
When (/^I sort by Award ID$/) do
  kaiki.pause
  kaiki.find(:xpath, "/html/body/form/table/tbody/tr/td[2]/table/thead/tr/th[2]/a").click
  kaiki.wait_for(:xpath, "/html/body/form/table/tbody/tr/td[2]/table/thead/tr/th[2]/a")
  kaiki.find(:xpath, "/html/body/form/table/tbody/tr/td[2]/table/thead/tr/th[2]/a").click
end