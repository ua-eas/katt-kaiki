# Description:  Step methods for feature files for filling in fields on a search
#               page
#
# Original Date: 11 November 2013

# Public: Clicks the link with the specified name
#
# Parameters:
#   link  - name of the item to be clicked
#
# Returns nothing.
When(/^I click the "(.*?)" search link$/) do |link|
  kaiki.pause
  kaiki.click_approximate_field(
    ["//td[contains(text(), '#{link}')]/following-sibling::td/a[2]"])
end

# Public: Takes the name of the button and clicks on the button with that name
#
# Parameters:
#   button     - name of the button to be clicked
#   field      - name of the field the search button may be associated with
#   subsection - subsection of the page the radio should be in
#
# Returns nothing.
When(/^I start a lookup for "(.*?)"(?:| for "(.*?)")(?:| on line "(.*?)")(?:| (?:under|in) the "(.*?)" subsection)$/)\
  do |button, field, line_number, subsection|

  kaiki.get_ready
  current_page.click_search_button(button, field, line_number, subsection)
end

# Public: Defines what is to be put into a given field
#
# Parameters:
#   field - name of text field
#   value - a text or numeral value
#
# Example:
#    And I set "Award Status" to "Active" on the search page
#
# Returns nothing.
When (/^I set "(.*?)" to "(.*?)" on the search page$/) do |field, value|
  kaiki.get_ready

  value_hash = Hash[
    "the recorded document number"                    => kaiki.record[:document_number],
    "the recorded requisition number"                 => kaiki.record[:requisition_number],
    "the recorded purchase order number"              => kaiki.record[:purchase_order_number],
    "the recorded requisition document number"        => kaiki.record[:requisition_document_number],
    "the recorded purchase order document number"     => kaiki.record[:purchase_order_document_number],
    "the recorded payment request document number"    => kaiki.record[:payment_request_document_number],
    "the recorded vendor credit memo document number" => kaiki.record[:vendor_credit_memo_document]
  ]
  value = value_hash[value] if value_hash.key?(value)

  search_page.fill_in_field(field, value)
end

# Public: Verifies that the search returns at least one item
#
# Returns nothing.
Then(/^I should see one or more items retrieved$/) do
  kaiki.get_ready
  kaiki.should(have_content('retrieved'))
end

# Description: Orders records in descending order for the selected column
#
# Returns nothing.
When (/^I sort by ([^"]*) on the search page$/) do |column|
  kaiki.get_ready
  kaiki.find(
    :xpath,
    "//a[contains(text(), '#{column}')]").click
  kaiki.wait_for(
    :xpath,
    "//a[contains(text(), '#{column}')]")
  kaiki.find(
    :xpath,
    "//a[contains(text(), '#{column}')]").click
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
When(/^I return the record with "(.*?)" of "(.*?)" on the search page$/) do |column, value|
  kaiki.get_ready
  search_page.click_link_on_record(column, value)
end

# Public: Performs an action on the first record in the table.
#
# Parameters:
#   action - This is the action to be performed on the first record.
#
# Returns nothing.
When(/^I "(.*?)" the first record on the search page$/) do |action|
  kaiki.get_ready
  search_page.click_link_on_record(action, :first)
end

# Public: Performs an action on the returned record in the table.
#
# Parameters:
#   action - This is the action to be performed on the first record.
#
# Returns nothing.
When(/^I select the first document on the search page$/) do
  kaiki.get_ready
  search_page.click_link_on_record('none', :first)
end

# Public: Used to open a saved document that has a given descriptive number,
#         i.e. document number, requisition number, etc.
#
# Parameters:
#   column - name of the field the value corresponds to
#   value  - number on the page to look for
#
# Returns nothing.
When(/^I open the saved document with "(.*?)" of "(.*?)" on the search page$/) do |column, value|
  kaiki.get_ready

  special_case_hash = {
    "the recorded document number" => kaiki.record[:document_number],
    "the recorded requisition number" => kaiki.record[:requisition_number],
    "the recorded purchase order number" => kaiki.record[:purchase_order_number]
  }

  value = special_case_hash[value]
  kaiki.click_approximate_field(
    ["//th/a[contains(text(),'#{column}')]/../../../"                          \
    "following-sibling::tbody/tr/td/a[contains(text(),'#{value}')]"])
end

# Publid: Clicks the specified button on a search page
#
# Returns nothing.
When(/^I click the "(.*?)" button on the search page$/) do |button_name|
  kaiki.get_ready
  search_page.click_button(button_name)
end

# Public: Clicks a search button for the specified field on a search page
#
# Returns nothing.
When (/^I start a lookup for "(.*?)" on the search page$/) do |button_name|
  kaiki.get_ready
  search_page.click_button(button_name)
end