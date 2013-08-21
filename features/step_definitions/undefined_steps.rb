# Description: These step defs are currently specific to page 2 of text scenario
#              create_and_submit_basic_proposal
# 
# Original Date: August 16, 2013

# Public: Clicks on "Show/Hide" on the specific tab
#
# Parameters: 
#   option - "Show" or "Hide"
#   value - Which tab is being toggled
#
# Returns: nothing
When(/^I click "(.*?)" on the "(.*?)" section$/) do |option, section|
  kaiki.pause
  if option == "Show"
    kaiki.show_tab(section)
  elsif option == "Hide"
    kaiki.hide_tab(section)
  else
    raise NotImplementedError
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
 When(/^I return the record with "(.*?)" of "(.*?)"$/) do |column, value|
  kaiki.pause
  kaiki.switch_default_content
  kaiki.select_frame("iframeportlet")
    
  kaiki.set_approximate_field(
    ApproximationsFactory.transpose_build(
      "//%s[contains(text()%s, '#{column}')]/../following-sibling::td/%s",
      ['th/label',    '',       'input'],
      [nil,           '[1]',    nil],
      [nil,           '[2]',    nil]),
    value)
  kaiki.click "search"

  kaiki.pause
  kaiki.switch_default_content
  kaiki.select_frame("iframeportlet")
  link = kaiki.find('a', :text => 'return value')
  link.click
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
When(/^I fill out the Combined Credit Split for "(.*?)" with the following:$/) do |name, table|
  # table is a Cucumber::Ast::Table
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
      xpath = "//td/strong[contains(text(),'#{name}')]/../following-sibling:" \
        ":td[#{data_column}]/div/strong/input"
      element = kaiki.find(:xpath, xpath)
      element.set(value)
    end
  end
end

# Public: Fills out the fields of Combined Credit Split for the division the
#         person belongs to
#
# Parameters:
#   division   - This is the division the person belongs to.
#   name       - This is the name of the person to fill the fields for
#   table      - This is the table of fields to be filled, using the following
#               syntax:
#                | field_name | value |
#   field_name - this is the name of the field that is to be filled.
#   value      - this is the value of the field to be filled.
#
# Returns: nothing
When(/^I fill out the Combined Credit Split line item for "(.*?)" under "(.*?)" with the following:$/) do |division, name, table|
  # table is a Cucumber::Ast::Table
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
      xpath = "//tr/td/strong[contains(text(),'#{name}')]/../../following-s" \
        "ibling::tr/td[contains(text(),'#{division}')]/following-sibling::t" \
        "d[#{data_column}]/div/input"
      element = kaiki.find(:xpath, xpath)
      element.set(value)
    end
  end
end        
