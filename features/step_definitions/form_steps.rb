# Description: Step methods for feature files for filling in forms and tables
# 
# Original Date: August 20, 2011

# Public: Defines what is to be printed into a given field
#
# Parameters:
#   field - name of text field
#   value - a text or numeral value
#
# Example:
#   And I set the "Description" to "testing: KFSI-4479"
#
# Returns nothing
#
When /^I (?:set the|set) "([^"]*)" to "([^"]*)"$/ do |field, value|
  kaiki.pause
  kaiki.switch_default_content
  kaiki.select_frame "iframeportlet"
  kaiki.set_approximate_field(
    ApproximationsFactory.transpose_build(
      "//%s[contains(text()%s, '#{field}')]/../following-sibling::td/%s",
      ['th/label',    '',       'select[1]'],
      ['th/div',      '[1]',    'input[1]'],
      [nil,           '[2]',    nil]
    ) +
    ApproximationsFactory.transpose_build(
      "//%s[contains(text()%s, '#{field}')]/following-sibling::td/%s",
      ['th',    '',       'select[1]'],
      [nil,     '[1]',    'input[1]'],
      [nil,     '[2]',    nil]
    ) +
    ApproximationsFactory.transpose_build(
      "//%s[contains(text()%s, '#{field}')]/../../following-sibling::tr/td/"  \
      "label/%s",
      ['th/label',    '',       'select[1]'],
      ['th/div',      '[1]',    'input[1]'],
      [nil,           '[2]',    nil]
    ) +
    ApproximationsFactory.transpose_build(
      "//%s[contains(text()%s, '#{field}')]/../../following-sibling::tr/td/"  \
      "div/%s[contains(@title, '#{field}')]",
      ['th/label',    '',       'select[1]'],
      ['th/div',      '[1]',    'input[1]'],
      [nil,           '[2]',    nil]
    ) +
    ApproximationsFactory.transpose_build(
      "//th/div[contains(text()%s, '#{field}')]/../following-sibling::td/span"\
        "/%s[contains(@title, '#{field}')]",
      ['',       'input'],
      ['[1]',    nil],
      ['[2]',    nil]
    ) +      
    ApproximationsFactory.transpose_build(
      "//th[contains(text()%s, '#{field}')]/../following-sibling::tr/td/div/" \
        "%s[contains(@title, '#{field}')]",
      ['',       'select'],
      ['[1]',    'input'],
      ['[2]',    nil]),
    value
  )
end
  
# Public: Defines what is to be printed into a given field
#
# Parameters:
#   field- name of text field
#   value-a text or numeral value
#
# Example:
# And I set the "Description" to something like "testing: KFSI-4479"  
#
# Returns nothing  
#
When /^I (?:set the|set) the "([^"]*)" to something like "([^"]*)"$/ do |field, value|
  kaiki.pause
  kaiki.switch_default_content
  kaiki.select_frame "iframeportlet"
  # value = value + ' ' + Time.now.strftime("%Y%m%d%H%M%S") # If these 2 lines are commented out, the program works and doesn't skip.
  # puts value
  kaiki.set_approximate_field(
    ApproximationsFactory.transpose_build(
      "//%s[contains(text()%s, '#{field}')]/../following-sibling::td/%s",
      ['th/label',    '',       'select[1]'],
      ['th/div',      '[1]',    'textarea[1]'],
      ['th/div',      '[2]',    'input[1]']
    ),
    value
  )
end

# Public: Sets the dropdown to the given value in the found in the 
#         cucumber file
#
# Parameters:
#   field - name of the dropdown
#   name  - name of the person 
#   value - data to be used
#
# Returns: nothing    
#
When /^I (?:set the|set) "(.*?)" for "(.*?)" as "(.*?)"$/ do |field, name, value|
  kaiki.pause
  kaiki.switch_default_content
  kaiki.select_frame "iframeportlet"
  if field == "Percentage Effort" && name == "Linda L Garland"
    kaiki.set_field('//*[@id="document.developmentProposalList[0].proposalPersons[0].percentageEffort"]', value)
  elsif field == "Percentage Effort" && name == "Amanda F Baker"
    kaiki.set_field('//*[@id="document.developmentProposalList[0].proposalPersons[1].percentageEffort"]', value)
  end
end

# Public: This method may need another ApproximationsFactory segment added
#         but as is, it will fill in an input/select field given the line number
#         the field is on, and the name of the table.
#
# line_number - line number the field is on
# table_name - name of the table
# table - data to be used
#
# Returns: nothing
When /^I fill out line "([^"]*)" of the "([^"]*)" table with:$/              \
                                            do |line_number, table_name, table|
  table.rows_hash
  kaiki.pause
  kaiki.switch_default_content
  kaiki.select_frame "iframeportlet"
  kaiki.should have_content table_name
  
  table.rows_hash.each do |key, value|
    kaiki.set_approximate_field(
    ApproximationsFactory.transpose_build(
      "//%s[contains(text()%s, '#{key}')]/../../following-sibling::"         \
      "tr/th[contains(text(), '#{line_number}')]/following-sibling::"        \
      "td/div/%s[contains(@title, '#{key}')]",
      ['th/label',    '',       'select[1]'],
      ['th/div',      '[1]',    'input[1]'],
      [nil,           '[2]',    nil]
    ),
    value
  )
  end
end

# Public: Checks a checkbox given the name by utlizing the ApproximationFactory
#         to find the xpath of the checkbox.
#
# check_name - name of the checkbox
#
# Returns: nothing

When /^I check the "([^"]*)" checkbox$/ do |check_name|
  kaiki.pause
  kaiki.switch_default_content
  kaiki.select_frame "iframeportlet"

  kaiki.check_approximate_field(
    ApproximationsFactory.transpose_build(
      "//%s[contains(text()%s, '#{check_name}')]/../following-sibling::"     \
      "td/%s[@title = '#{check_name}']",
      ['th/div',      '',       'input[1]'],
      ['th/label',    '[1]',    'select[1]'],
      [nil,           '[2]',    nil]
    )
  )
end
