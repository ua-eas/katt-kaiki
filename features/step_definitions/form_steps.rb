# Description: Step methods for feature files for filling in forms and tables
#
# Original Date: August 20, 2011


# Public: Defines what is to be put into a given field
#
# Parameters:
#   field       - name of text field
#   value       - a text or numeral value
#   line_number - possible line number the field may show up on
#   subsection  - subsection of the page the field may appear in
#
# Example:
#   And I set the "Description" to "testing: KFSI-4479"
#
# Returns nothing.
When(/^I set "([^"]*)" to "([^"]*)"(?:| on line "(.*?)")(?:| (?:under|in) the "([^"]*)" subsection)$/)\
  do |field, value, line_number, subsection|

  kaiki.get_ready
  current_page.fill_in_field(field, value, line_number, subsection)
end

# Public: Fills out a row of data for the Combined Credit Split table.
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
When(/^I fill out the Combined Credit Split for "(.*?)"(?:| under "(.*?)") with the following:$/) \
  do |division, name, table|

  kaiki.get_ready
  current_page.credit_split(division, name, table)
end

# Public: Checks a checkbox given the name by utlizing the ApproximationFactory
#         to find the xpath of the checkbox.
#
# Parameters:
#   option      - check or uncheck
#   check_name  - name of the checkbox
#   field       - name of the field the checkbox may be associated withe
#   line_number - possible line number the field may show up on
#   subsection  - subsection of the page the checkbox may appear in
#
# Returns nothing.
When(/^I ([^"]*) the "([^"]*)" checkbox(?:| on "(.*?)")(?:| on line "(.*?)")(?:| (?:under|in) the "(.*?)" subsection)$/)\
  do |option, check_name, field, line_number, subsection|
  kaiki.get_ready
  current_page.check_uncheck_box(option, check_name, field, line_number, subsection)
end

# Public: This method will fill in a specific field in a specific row
#         in a specific table on the page.
#
# Parameters:
#   label      - the name of the field to be filled in
#   row_number - this is the number of the specific row to be edited
#   value      - the value to be filled into the field
#   table_name - name of the table to be filled in
#
# Returns nothing.
When (/^I set "([^"]*)" in row "([^"]*)" to "([^"]*)" under the "([^"]*)" table$/)\
  do |label, row_number, value, table_name|

  kaiki.get_ready
  factory1 =
    ApproximationsFactory.transpose_build(
      "//%s[contains(text(),'#{table_name}')]"                                 \
        "/../../../../following-sibling::%s[contains(text(),'#{row_number}')]" \
        "/following-sibling::%s[contains(@title,'#{label}')]",
      ['table/tbody/tr/td/h2', 'div/div/table/tbody/tr/th', 'td/div/input' ])
  approximate_xpath = factory1
  kaiki.set_approximate_field(approximate_xpath, value)
end

# Description: Will open the calendar popup adjacent to the specified field
#              and select the appropriate date from within it by calling
#              the approporiate method in the CapybaraDriver.
#
#              **If a date other than 'Today' is to be selected, the format
#                for said date needs to be 'November 19, 2013' for example.
#
# Example:
#   When I click the "Date Required" calendar and set the date to "Today"
#   When I click the "Date Required" calendar and set the date to "November 19, 2013"
#
# Parameters:
#   label         - name of the field the calendar is adjacent to
#   date_option   - option inside the calender to be selected
#
# Returns nothing.
When(/^I click the "(.*?)" calendar and set the date to "(.*?)"$/)\
  do |label, date_option|

  kaiki.get_ready
  kaiki.click_calendar(label, date_option)
end