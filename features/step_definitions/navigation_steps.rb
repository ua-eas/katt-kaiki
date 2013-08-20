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
  # if name == "Open"
    # kaiki.click_approximate_field(
      # ApproximationsFactory.transpose_build(
        # "//%s[contains(text()%s, '#{field}')]/following-sibling::"        \
        # "td/div/%s[@name = 'open budget')]",
        # ['td',    '',       'select[1]'],
        # ['td',    '[1]',    'input[1]'],
        # [nil,     '[2]',    nil]
      # ),
    # "button"
    # )
  # end
end







# WD
# Public: Opens the user's Action List
#
# Returns: nothing
# When /^I open my Action List$/i do
  # kaiki.click_and_wait(:xpath, "//a[@class='portal_link' and @title='Action List']")
  # kaiki.select_frame "iframeportlet"
# end


# WD
#
# Public: Opens the user's Action List to the last page
#
# Returns: nothing
# When /^I open my Action List to the last page$/i do
  # kaiki.click_and_wait(:xpath, "//a[@class='portal_link' and @title='Action List']")
  # kaiki.select_frame "iframeportlet"
  # begin
    # last_link = kaiki.find_element(:link_text, 'Last')
    # last_link.click
  # rescue Selenium::WebDriver::Error::NoSuchElementError, Selenium::WebDriver::Error::TimeOutError
  # end
# end


# WD
#
# Public: Opens the user's Action List and refreshes it
#
# Returns: nothing
# When /^I open my Action List, refreshing until that document appears$/i do
  # steps %{
    # When I open my Action List
    # And  I wait for that document to appear in my Action List
  # }
# end


# WD
#
# Public: Waits for the document to appear in the user's Action List
#
# Returns: nothing
# When /^I wait for that document to appear in my Action List$/i do
  # doc_nbr = kaiki.record[:document_number]
  # attempts  = 8
  # wait_time = 2
# 
  # loop do
    # break if kaiki.has_selector?(:xpath, "//a[contains(text(), '#{doc_nbr}')]")
# 
    # raise Capybara::ElementNotFound if attempts <= 0
    # attempts -= 1
    # puts "#{attempts} retries left... #{Time.now}"
    # kaiki.click_and_wait :name, "methodToCall.start"  # 'refresh'
    # kaiki.pause wait_time
  # end
# end


# WD
#
# Public: Opens a document search
#
# Returns: nothing
# When /^I open a doc search$/ do
  # kaiki.switch_to.default_content
  # kaiki.click_and_wait(:xpath, "//a[@class='portal_link' and @title='Document Search']")
  # kaiki.select_frame "iframeportlet"
# end


# WD
#
# Public: Clicks a portal link under a given header
#
# Parameters:
#   link - portal link to click
#   header - header the portal link is under
#
# Returns: nothing
# When /^I click the "([^"]*)" portal link under "([^"]*)"$/ do |link, header|
  # kaiki.click_and_wait(:xpath, "//h2[contains(text(), '#{header}')]/../../following-sibling::div//a[@class='portal_link' and @title='#{link}']")
  # kaiki.select_frame "iframeportlet"
# end




# WD
#
# Public: Clicks a link based on its text
#
# Parameters:
#   text - name of the link
#
# Returns: nothing
# When /^I click the "([^"]*)" link$/ do |text|
    # kaiki.click_and_wait :link, text
# end


# WD
#
# Public: Clicks a button based on its name
#
# Parameters:
#   action - which submit button is being pressed
#
# Returns: nothing
# When /^I click the "([^"]*)" submit button$/ do |action|
    # kaiki.click_and_wait :name, "methodToCall.#{action.gsub(/ /, '').camelize(:lower)}"
# end


# WD
#
# Public: clicks a link and performs and action
#
# Parameters:
#   link - name of the link
#   reason - what is entered into the expanded field
#
# Returns: nothing
# When /^I click "([^"]*)" with reason "([^"]*)"$/ do |link, reason|
  # if ['disapprove'].include? link
    # kaiki.click_and_wait :xpath, "//input[@title='#{link}']"
  # end
  # kaiki.set_field("//*[@name='reason']", reason)
  # sleep 5
  # kaiki.click_and_wait :name, 'methodToCall.processAnswer.button0'  # The 'yes' button
# end


# WD
#
# Public: Looks up about a given item
#
# Parameters:
#   field - item wanting to be looked up
#
# Returns: nothing
# When /^I start a lookup for "([^"]*)"$/ do |field|
  # kaiki.click_approximate_and_wait(
    # [
      # "//div[contains(text(), '#{field}')]/../following-sibling::*/input[@title='Search ']",
      # "//div[contains(text()[1], '#{field}')]/../following-sibling::*/input[@title='Search ']",
      # "//div[contains(text()[2], '#{field}')]/../following-sibling::*/input[@title='Search ']",
      # "//div[contains(text()[3], '#{field}')]/../following-sibling::*/input[@title='Search ']",
      # The following appear on lookups like the Person Lookup. Like doc search > Initiator Lookup
      # "//th/label[contains(text(), '#{field}')]/../following-sibling::td/input[contains(@title, 'Search ')]"
    # ]
  # )
# end


# WD
#
# Public: Looks up about a given item in a certain tab
#
# Parameters:
#   tab - tab for the search
#   field - item wanting to be looked up
#
# Returns: nothin
# When /^I start a lookup for the new ([^']*)'s "([^"]*)"$/ do |tab, field|
  # #kaiki.click_and_wait("xpath=//*[@id='tab-#{object}-div']//div[contains(text(), '#{field}')]/../following-sibling::*/input[@title='Search ']")
  # div = "tab-#{tab.pluralize}-div"
  # kaiki.click_approximate_and_wait(
    # [
      # "//*[@id='#{div}']//div[contains(text(), '#{field}:')]/../following-sibling::*/input[@title='Search ']",
      # "//*[@id='#{div}']//th[contains(text(), '#{field}')]/../following-sibling::tr//input[@title='Search ']",
      # "//*[@id='#{div}']//th[contains(text()[1], '#{field}')]/../following-sibling::tr//input[@title='Search ']",
      # "//*[@id='#{div}']//th[contains(text()[2], '#{field}')]/../following-sibling::tr//input[@title='Search ']", # Group > create new > set Group Namespace > Assignees
      # "//*[@id='#{div}']//th[contains(text()[3], '#{field}')]/../following-sibling::tr//input[@title='Search ']"
    # ])
# end


# WD
#
# Public: Returns the first result from a search query
#
# Returns: nothing
# When /^I (?:return(?: with)?|open) the first (?:result|one)$/ do
  # kaiki.highlight(:xpath, "//table[@id='row']/tbody/tr/td/a", 4)
  # sleep 0.1
  # kaiki.click_and_wait(:xpath, "//table[@id='row']/tbody/tr/td/a[1]")
# end


# WD
#
# Public: Returns the chosen result from a search query
#
# Parameters:
#   key - result to be returned
#
# Returns: nothing
# Matches  I return the..
#          I return with the ...
#          I open the...
# When /^I (?:return(?: with)?|open) the "([^"]*)" (?:result|one)$/ do |key|
  # kaiki.click_and_wait(:xpath, "//a[contains(text(), '#{key}')]/ancestor::tr/td[1]/a")
# end


# WD
#
# Public: Edits the given item in a table on the page
#
# Parameters:
#   key - given table item
#
# Returns: nothing
# When /^I edit the "([^"]*)" one$/ do |key|
  # kaiki.click_and_wait(:xpath, "//a[contains(text(), '#{key}')]/ancestor::tr/td[1]/a[contains(@title,'edit')]")
# end


# WD
#
# Public: Edits the first item in a table on the page
#
# Returns: nothing
# When /^I edit the first one$/ do
  # kaiki.click_and_wait(:xpath, "//table[@id='row']/tbody/tr/td[1]/a[contains(@title,'edit')]")
# end


# WD
#
# Public: Opens a document
#
# Returns: nothing
# When /^I open that document$/ do
  # doc_nbr = kaiki.record[:document_number]
  # sleep 0.1
  # kaiki.click_and_wait(:xpath, "//a[contains(text(), '#{doc_nbr}')]")
# end


# WD
#
# Public: Switches to a new window
#
# Returns: nothing
# When /^I switch to the new window$/ do
  # kaiki.pause
  # new_handles = kaiki.window_handles - [kaiki.window_handle]
  # raise StandardError if new_handles.size != 1  # TODO better error
  # kaiki.switch_to.window(new_handles[0])
  # kaiki.pause
# end


# WD
#
# Public: Closes all blank windows
#
# Returns: nothing
# When /^I close that window$/ do
  # kaiki.close
  # kaiki.close_blank_windows
  # kaiki.switch_to.window(kaiki.window_handles[0])
  # kaiki.pause
# end


# WD
#
# Public: Resets the browser speed to default
#
# Returns: nothing
# Given /^I am fast$/ do
  # kaiki.log.debug "I am fast (pause_time = 0)"
  # kaiki.pause_time = 0
# end


# WD
#
# Public: Slows down the browser by 2 seconds
#
# Returns: nothing
# When /^I slow down$/ do
  # kaiki.log.debug "I slow down (pause_time = #{kaiki.pause_time + 2})"
  # kaiki.pause_time += 2
# end


# WD
#
# Public: Pauses the browser for the given amount of time
#
# Parameters:
#   seconds - amount of time
#
# Returns: nothing
# When /^I sleep for "?([^"]*)"? seconds$/ do |seconds|
  # kaiki.log.debug "I sleep for #{seconds} seconds"
  # sleep seconds.to_i
# end


# WD
#
# Public: Pauses the browser for 30 seconds
#
# Returns: nothing
# When /^I pause$/ do
  # kaiki.log.debug "I pause (for 30 seconds)"
  # sleep 30
# end
