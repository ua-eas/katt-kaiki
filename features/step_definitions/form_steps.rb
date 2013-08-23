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
      ['th',    '',       'input[1]'],
      [nil,     '[1]',    'select[1]'],
      [nil,     '[2]',    nil]
    ) +
    ApproximationsFactory.transpose_build(
      "//%s[contains(text()%s, '#{field}')]/../../following-sibling::tr/td/"  \
      "label/%s",
      ['th/label',    '',       'input[1]'],
      ['th/div',      '[1]',    'select[1]'],
      [nil,           '[2]',    nil]
    ) +
    ApproximationsFactory.transpose_build(
      "//%s[contains(text()%s, '#{field}')]/../../following-sibling::tr/td/"  \
      "div/%s[contains(@title, '#{field}')]",
      ['th/label',    '',       'input[1]'],
      ['th/div',      '[1]',    'select[1]'],
      [nil,           '[2]',    nil]
    ) +
    ApproximationsFactory.transpose_build(
      "//th/div[contains(text()%s, '#{field}')]/../following-sibling::td/span"\
      "/%s[contains(@title, '#{field}')]",
      ['',       'input[1]'],
      ['[1]',    nil],
      ['[2]',    nil]
    ) +      
    ApproximationsFactory.transpose_build(
      "//th[contains(text()%s, '#{field}')]/../following-sibling::tr/td/div/" \
      "%s[contains(@title, '#{field}')]",
      ['',       'input[1]'],
      ['[1]',    'select[1]'],
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
When /^I (?:set the|set) "([^"]*)" to something like "([^"]*)"$/ do |field, value|
  kaiki.pause
  kaiki.switch_default_content
  kaiki.select_frame "iframeportlet"
  # value = value + ' ' + Time.now.strftime("%Y%m%d%H%M%S") # If these 2 lines are commented out, the program works and doesn't skip.
  # puts value
  kaiki.set_approximate_field(
    ApproximationsFactory.transpose_build(
      "//%s[contains(text()%s, '#{field}')]/../following-sibling::td/%s",
      ['th/label',    '',       'textarea[1]'],
      ['th/div',      '[1]',    'input[1]'],
      ['th/div',      '[2]',    'select[1]']
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

# Public: Fills out the fields of Combined Credit Split for a person.
#
# Parameters:
#   name       - This is the name of the person to fill the fields for
#   table      - This is the table of fields to be filled, using the following
#               syntax:
#               | field_name | value |
#   field_name - this is the name of the field that is to be filled.
#   value      - this is the value of the field to be filled.
#
# Returns: nothing
When /^I fill out the Combined Credit Split for "(.*?)"(?:| under "(.*?)") with the following:$/\
  do |division, name, table|

  kaiki.pause
  kaiki.switch_default_content
  kaiki.select_frame("iframeportlet")
  data = table.raw  
  data.each do |key, value|
    if key == "Credit for Award"
      data_column = 1
    elsif key == "F&A Revenue"
      data_column = 2
    else
      data_column = nil
      raise NotImplementedError
    end

    if data_column != nil
      if division == name || name == nil
          xpath = "//td/strong[contains(text(),'#{division}')]/../following-sibling:"\
            ":td[#{data_column}]/div/strong/input"
          element = kaiki.find(:xpath, xpath)
          element.set(value)
      else
        xpath = "//tr/td/strong[contains(text(),'#{name}')]/../../"           \
          "following-sibling::tr/td[contains(text(),'#{division}')]/"         \
          "following-sibling::td[#{data_column}]/div/input"
        element = kaiki.find(:xpath, xpath)
        element.set(value)
      end
    end
    
  end
end

# Public: Selects either a Yes, No, or N/A radio button given the name of the
#         table
#
# table_name - name of the table
# table - data to be used
#
# Returns: nothing

When(/^I answer the questions under "(.*?)" with:$/) do |table_name, table|

  kaiki.pause
  kaiki.switch_default_content
  kaiki.select_frame("iframeportlet")
  kaiki.should(have_content(table_name))
  
  data_table = table.raw
  header_row = data_table[0]
  max_data_rows = data_table.size - 1
  max_data_columns = header_row.size - 1
    
  (1..max_data_rows).each do |data_row|
    (1..max_data_columns).each do |data_column|
      row_name = data_table[data_row][0]
      column_name = data_table[0][data_column]
      value = data_table[data_row][data_column]

      if value != ""
        option1="input[@title='#{column_name}']"
        option2="select[@title='#{column_name}']"
        option3="textarea[@title='#{column_name}']"
        option4="input[@title='#{column_name} - #{value}']"
        approximate_xpath = ApproximationsFactory.transpose_build(
          "//table/tbody/tr/td/h2[contains(text(), '#{table_name}')]/../../." \
          "./../following-sibling::div/div/table/tbody/tr/th[contains(text()" \
          ", '#{row_name}')]/../descendant::%s",
          [option4],
          [option3],
          [option1],
          [option2],

          [nil]) 
        # TODO: Leave the commented code here. This is to provide output for 
        #   future development purposes
#       begin
#         print "Xpath Selectors: #{approximate_xpath}\n\n"
        element = kaiki.find_approximate_element(approximate_xpath)
#         print "Element: #{element}\n"
#         print "Type of Element: #{element[:type]}"
#       rescue Exception => e
#         print "Message: #{e.message}\n"
#       end
          
        if element[:type] == "radio"
          kaiki.click_approximate_field(approximate_xpath, "radio")
        else
          kaiki.set_approximate_field(approximate_xpath, value)
        end
      end
    end
  end
end

# Public: This method may need another ApproximationsFactory segment added
#         but as is, it will fill in an input/select/textarea field in a table
#         given the name of the table.
#
# table_name - name of the table
# table - data to be used
#
# Returns: nothing
When /^I fill out the "([^"]*)" table with:$/ do |table_name, table|
  kaiki.pause
  kaiki.switch_default_content
  kaiki.select_frame "iframeportlet"
  kaiki.should have_content table_name
  
  data = table.raw
  rows = data.length-1
  cols = data[0].length-1
  
    (1..rows).each do |i|
      (1..cols).each do |j|

        if data[i][j] != ""
          opt1 = "input[contains(@title, '#{data[0][j]}')]"
          opt2 = "select[contains(@title, '#{data[0][j]}')]"
          opt3 = "textarea[contains(@title, '#{data[0][j]}')]"
    
          approximate_paths = ApproximationsFactory.transpose_build(
              "//h3/span[contains(text(), '#{table_name}')]/../"             \
              "following-sibling::table/descendant::"                        \
              "tr/th[contains(text(), '#{data[i][0]}')]/"                   \
              "following-sibling::td/div/%s",       
              [opt1],
              [opt2],
              [opt3]
            )
          kaiki.set_approximate_field(approximate_paths, data[i][j])
        end
      end
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
