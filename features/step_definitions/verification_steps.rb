# Description: This file houses the interpretation of verification steps used 
#              by Cucumber features.
#
# Original Date: August 20, 2011


# Public: Verifies the given text is present on the page
#
# Parameters:
#   label - optional matcher for given text
#   text  - text to be verified
#   extra - placeholder variable for second regex
#   stuff - placeholder varaible for last regex
#
#   * the label variable is necessary for cases where the feature writer
#   * may write a statement such as:
#   * Then I should see "Status" set to "In Progress" in the document header
#
# Returns nothing.
Then(/^I should (?:see|see the message) "([^"]*)"(?:([^"]*)| set to "([^"]*)"([^"]*))$/) \
  do |label, extra, text, stuff|
  kaiki.pause
  kaiki.switch_default_content
  kaiki.select_frame("iframeportlet")
  kaiki.should(have_content(text || label))
end

# Public: Verifies the given values from the table are present on the web page
#         in the correct text fields
# 
# Parameters:
#   line_number - line in which the text field you want filled in resides
#   table_name  - name of the table to be filled in
#   table       - table of data being read in from the feature file 
# 
# Returns nothing.
Then(/^I should see the "([^"]*)" table filled out with:$/)                   \
  do |table_name, table|
  kaiki.pause
  kaiki.switch_default_content
  kaiki.select_frame("iframeportlet")
  kaiki.should(have_content(table_name))
  
  data_table = table.raw
  rows = data_table.length-1
  cols = data_table[0].length-1
  
  (1..rows).each do |data_row_counter|
    (1..cols).each do |data_column_counter|
      row_name = data_table[data_row_counter][0]
      column_name = data_table[0][data_column_counter]
      value = data_table[data_row_counter][data_column_counter]
      option1 = "input[contains(@title, '#{column_name}')]"
      option2 = "select[contains(@title, '#{column_name}')]"
      option3 = "textarea[contains(@title, '#{column_name}')]"
      approximate_xpath = 
        ApproximationsFactory.transpose_build(
          "//h3/span[contains(text(), '#{table_name}')]"                      \
          "/../following-sibling::table"                                      \
          "/descendant::tr/th[contains(text(), '#{row_name}')]"               \
          "/following-sibling::td/div/%s",       
          [option1],
          [option2],
          [option3])
      field_text = kaiki.get_approximate_field(approximate_xpath)
      if field_text != value
        raise Capybara::ExpectationNotMet
      end 
    end
  end  
end

# Public: Verifies the given values from the table are present on the web page
#         in the correct place
# 
# table_name - name of the table to be filled in
# table      - table of data being read in from the feature file 
# 
# Returns nothing.
Then(/^I should see Budget Totals calculated as:$/) do |table|
  kaiki.pause
  kaiki.switch_default_content
  kaiki.select_frame("iframeportlet")
  table.rows_hash.each do |key, value|
    kaiki.should(have_content(value))
  end
end

#Puplic: Waits for the page to finish loading
#
#Parameters:
#	value - frame being loaded i e, iframeportlet
#
# Returns nothing.
When(/^I wait for the document to finish being processed$/) do
  kaiki.pause(20)
  kaiki.switch_default_content
  kaiki.wait_for(:xpath, "//*[@id='iframeportlet']")
end

#Public: Verifies that the Institutional Proposal has been generated
#
#Parameters: 
#	text1 - first value being checked for i e, "Institutional Proposal"
#	text2 - second value being checked for ie, "has been generated"
#
# Returns nothing.
Then(/^I should see a message starting with "([^"]*)" and ending with "([^"]*)"$/) \
  do |text1, text2|
  kaiki.pause
  kaiki.switch_default_content
  kaiki.select_frame("iframeportlet")
  kaiki.wait_for(:xpath, "//div[@class='left-errmsg']")
  kaiki.should(have_content(text1))
  kaiki.should(have_content(text2))
end
