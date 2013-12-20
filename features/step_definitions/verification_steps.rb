# Description: This file houses the interpretation of verification steps used
#              by Cucumber features.
#
# Original Date: August 20, 2011


# Description: This step definition is for general purpose messages on the
#              current browser page.
#
# Parameters:
#   message - message that should appear on the screen
#
# Returns nothing.
Then (/^I should see the message "(.*?)"$/) do |message|
  kaiki.get_ready
  kaiki.should(have_content(message))
end
# Description: This step definition is to verify text that shows up in the
#              document header.
#
# Parameters:
#   label - label for the text in the document header
#   text  - text to be verified on the page
#
# Returns nothing.
Then (/^I should see (?:|the )"(.*?)" text set to "(.*?)" in the document header$/)\
  do |label, text|

  kaiki.get_ready
  current_page.verify_document_header(label, text)
end

# Public: Verifies the expected value shows up in the specified field, and if
#         necessary, in the specified subsection of the page.
#
# Parameters:
#   label      - optional matcher for given text
#   text       - text to be verified
#   subsection - area of the page the text should be located in
#   person     - a subsection that is a person's name under which the field appears
#
# Returns nothing.
Then(/^I should see "(.*?)" set to(?:| active URL) "(.*?)"(?:| (?:under|in) the "([^"]*)" subsection)(?:| for "([^"]*)")$/)\
  do |field, value, subsection, person|

  kaiki.get_ready
  current_page.verify_field(field, value, 'exact')
end

# Public: Verifies the expected value shows up in the specified field, and if
#         necessary, in the specified subsection of the page, using a fuzzy
#         match.
#
# Parameters:
#   label      - optional matcher for given text
#   text       - text to be verified
#   subsection - area of the page the text should be located in
#   person     - a subsection that is a person's name under which the field appears
#
# Returns nothing.
Then(/^I should see "([^"]*)" set to something like "([^"]*)"(?:| (?:under|in) the "([^"]*)" subsection)(?:| for "([^"]*)")$/)\
  do |field, value, subsection, person|

  kaiki.get_ready
  current_page.verify_field(field, value, 'fuzzy')
end

# Description: Verifies the expected test shows up in the specified field, and
#              if necessary, in the specified subsection of the page, using a
#              fuzzy match.
#
# Parameters:
#   label      - label in which the text will appear next to
#   text       - text to be verified
#   subsection - area of the page it may appear in
#
# Returns nothing.
Then (/^I should see (?:|the )"([^"]*)" text set to something like "([^"]*)"(?:| (?:under|in) the "([^"]*)" subsection)$/)\
  do |label, text, subsection|

  kaiki.get_ready
  current_page.verify_text(label, text, 'fuzzy', subsection)
end

# Description: Verifies the expected test shows up in the specified field, and
#              if necessary, in the specified subsection of the page.
#
# Parameters:
#   label      - label in which the text will appear next to
#   text       - text to be verified
#   subsection - area of the page it may appear in
#
# Returns nothing.
Then (/^I should see (?:|the )"([^"]*)" text set to "([^"]*)"(?:| (?:under|in) the "([^"]*)" subsection)$/)\
  do |label, text, subsection|

  kaiki.get_ready
  current_page.verify_text(label, text, 'exact', subsection)
end

# Public: Verifies a row of data for the Combined Credit Split table contains
#         the correct value.
#
# Parameters:
#   division   - This field is used in two possible ways:
#                1) If the "under ____" is used, division is the division
#                   the person belongs to.
#                2) If the "under ____" is not used, division is the name of
#                   the person.
#   name       - This is the name of the person to fill the fields for
#   table      - This is the table of fields to be filled, using the following
#                  syntax:
#                    | field_name | value |
#   field_name - this is the name of the field that is to be filled.
#   value      - this is the value of the field to be filled.
#
# Returns nothing.
Then(/^I should see Combined Credit Split for "(.*?)"(?:| under "(.*?)") with the following:$/)\
  do |division, name, table|

  kaiki.get_ready
  current_page.credit_split(division, name, table)
end

# Description: Verifies the given values in the table are present
#
# table_name - name of the table to be filled in
# table      - table of data being read in from the feature file
#
# Returns nothing.
Then(/^I should see "(.*?)" calculated as:$/) do |table_name, table|
  kaiki.get_ready
  current_page.table_verify(table_name, table)
end

# Public: Waits for the processing page to finish loading
#
# Parameters:
#	  value - frame being loaded i e, iframeportlet
#
# Returns nothing.
When(/^I wait for the document to finish being processed$/) do
  i = 0
  unless current_page.button_xpath.nil?
    content_check = kaiki.has_xpath?(current_page.button_xpath)
    while content_check.eql?(true) do
      kaiki.pause(1)
      i += 1
      break if i > 90
    end
  end

  kaiki.switch_default_content
  kaiki.select_frame("iframeportlet")
  j = 0
  content_check = kaiki.has_content?('The document is being processed.')
  while content_check.eql?(true) do
    kaiki.pause(1)
    content_check = kaiki.has_content?('The document is being processed.')
    j += 1
    break if j > 90
  end
  kaiki.log.debug "Document processing: waited #{j+i} seconds..."
end

# Public: Verifies that the Institutional Proposal has been generated
#
# Parameters:
#	  text1 - first value being checked for i e, "Institutional Proposal"
#	  text2 - second value being checked for ie, "has been generated"
#
# Returns nothing.
Then(/^I should see a message starting with "([^"]*)" and ending with "([^"]*)"$/)\
  do |text1, text2|
  kaiki.get_ready
  kaiki.wait_for(:xpath, "//div[@class='left-errmsg']")
  kaiki.should(have_content(text1))
  kaiki.should(have_content(text2))
end

# Description: Verifies that no messages appear at the top of the screen,
#         because if one does appear, something has gone wrong.
#
# Returns nothing.
Then(/^I should not see a message at the top of the screen$/) do
  kaiki.get_ready
  kaiki.wait_for(:xpath, "//div[@class='left-errmsg']")
  element = kaiki.find(:xpath, "//div[@class='left-errmsg']")
  raise Capybara::ExpectationNotMet unless element.text.eql?("")
end

# Public: Checks to see if a unit administrator has been set up for a
#         specific unit.
#
# Returns nothing.
Given(/^unit administrator has been established$/) do

  # Here are the steps that need to occur to check that a unit administrator
  # has been set up. (Check if it is there)
  steps %{
    Given I am backdoored as "sandovar"
      And I am on the "Maintenance" system tab
    When I click the "Unit Administrator" link
      And I set "Unit Number" to "0721" on the search page
      And I click the "Search" button
    Then I should see a description of "Grants.Gov Proposal Contact"
  }
end

# Public: If no unit administrator has been set up, these are the steps
#         used to set up the unit administrator.
#
# Parameters:
#   description - holds the description of the unit administrator
#
# Returns nothing.
Then(/^I should see a description of "(.*?)"$/) do |description|
   begin
   element = kaiki.find(:xpath, "//td/a[contains(text(), '#{description}')]")

   rescue Selenium::WebDriver::Error::NoSuchElementError,
          Selenium::WebDriver::Error::TimeOutError,
          Selenium::WebDriver::Error::InvalidSelectorError,
          Capybara::ElementNotFound
     # if no, Steps to create the unit administrator:
      steps %{
        When I do not see "Grants.gov Proposal Contact"
          And I click the "Create New" button
          And I am in the "Document Overview" tab
          And I set "Description" to "Grants.gov Proposal Contact - New"
          And I am in the "Edit UnitAdministrator" tab
          And I set "Unit Administrator Type Code" to "6" in the "New" subsection
          And I set "KC Person" to "sesham" in the "New" subsection
          And I set "Unit Number" to "0721" in the "New" subsection
          And I click the "Submit" button
        Then I should see the message "Document was successfully submitted."
      }
    end
end

# Public: Verifies that the description for the unit administrator is
#         NOT present on the screen.
#
# Parameters:
#   description - holds the description of the unit administrator
#
# Returns nothing.
When(/^I do not see "(.*?)"$/) do |description|
  kaiki.get_ready
  kaiki.should_not(have_content(description))
end

# Public: Verifies the text "No Accounts" doesn't show up under the
#         Accounts Summary tab for KFS test PA004-01. If it does show up,
#         the "refresh accounts summary" button needs to be clicked.
#
# Parameters:
#   message - message that should not appear on the page
#
# Returns nothing.
Then (/^I should not see the message "(.*?)"$/) do |message|
  kaiki.within(:xpath, "//h2[contains(text(), '#{@tab}')]") do
    @tf = kaiki.should_not(have_content(message))
  end
  unless @tf
    steps %{
      And I click the "Refresh Account Summary" button
    }
  end
end

# Description: Verifies that the field is not blank.
#
# Parameters:
#   label - the name of the field to check
#
# Returns nothing.
Then(/^I should see (.*?) not null$/) do |label|
  kaiki.get_ready
  element = kaiki.find(:xpath, "//div[text()[contains(., '#{label}')]]/../"    \
                               "following-sibling::td")
  raise Capybara::ExpectationNotMet if element.text.eql?("")
end

# Public: Verifies if the specified checkbox is either checked or unchecked.
#
# Parameters:
#   check_name - name of the checkbox
#   value      - data to be used
#
# Returns nothing.
Then(/^I should see the "(.*?)" checkbox is "(.*?)"$/) do |check_name, value|
  kaiki.get_ready
  factory1 =
    ApproximationsFactory.transpose_build(
      "//h2[contains(., '#{@tab}')]/../../../../following-sibling::div/"       \
      "descendant::h3[contains(., '#{@section}')]/following-sibling::"         \
      "table/descendant::%s[contains(@title,'#{check_name}')]",
      ['input'])
  approximate_xpath = factory1
  element = kaiki.find_approximate_element(approximate_xpath)
  if value.downcase == "checked"
    value = "true"
  elsif value.downcase == "unchecked"
    value = nil
  end

  raise Capybara::ExpectationNotMet unless element[:checked].eql?(value)
end

# Description: Performs an verification of links found within the page.
#
# Parameters:
#   link  - This is the value/link to be verified on the page.
#   stuff - placeholder for extraneous text that may be after the link name
#
# Returns nothing.
Then(/^I should see the link for "(.*?)"(.*?)$/) do |link, stuff|
  kaiki.get_ready
  element = kaiki.find_approximate_element(["//a[contains(text(), '#{link}')]"])
end

# Description: Verifies if the specified checkbox is either checked or unchecked.
#
# Parameters:
#   label      - name for the radio button
#   option     - selected or unselected, or name of a specific button to be selected
#   subsection - area of the page the text should be located in
#
# Example:
#   Then I should see "Shipping Address Presented to Vendor (use Receiving Address?)" radio button set to "Final Delivery Address"
#
# Returns nothing.
Then(/^I should see (?:|the )"([^"]*)" radio button set to "([^"]*)"(?:| (?:under|in) the "([^"]*)" subsection)$/)\
  do |label, option, subsection|

  kaiki.get_ready
  factory0 =
    ApproximationsFactory.transpose_build(
      "//h2[contains(., '#{@tab}')]/../../../../following-sibling::div/"       \
      "descendant::h3[contains(., '#{@section}')]/following-sibling::"         \
      "table/descendant::%s[contains(@title, '#{option}')]",
      ['input'])
  approximate_xpath = factory0
  element = kaiki.find_approximate_element(approximate_xpath)

  raise Capybara::ExpectationNotMet unless element[:checked].eql?("true")
end

# Description: Verifies that the recorded requisiton number appears within the table
#         on the page.
#
# Parameters:
#   value - requisition number
#
# Returns nothing.
Then(/^I should see a table row with a Requisition Number of "(.*?)"$/) do |value|
  kaiki.get_ready
  value = kaiki.record[:requisition_number] if value == "the recorded requisition number"
  element = kaiki.find_approximate_element(["//h2[contains(., '#{@tab}')]"     \
    "/../../../../following-sibling::div/descendant::h3[contains(., '#{@section}')]"\
    "/following-sibling::table/descendant::tr/td[2]/a[contains(text(), '#{value}')]"])
  raise Capybara::ExpectationNotMet unless element.text.eql?(value)
end