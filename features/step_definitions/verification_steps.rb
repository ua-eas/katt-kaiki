# Description: This file houses the interpretation of verification steps used 
#              by Cucumber features.
#
# Original Date: August 20, 2011


# Public: Verifies the given text is present on the page
#
# label - optional matcher for given text
# text - text to be verified
# extra - placeholder variable for second regex
# stuff - placeholder varaible for last regex
#
# * the label variable is necessary for cases where the feature writer
# * may write a statement such as:
# * Then I should see "Status" set to "In Progress" in the document header
#
# Returns: nothing
Then /^I should (?:see|see the message) "([^"]*)"(?:([^"]*)| set to "([^"]*)"([^"]*))$/\
  do |label, extra, text, stuff|
  kaiki.pause
  kaiki.switch_default_content
  kaiki.select_frame "iframeportlet"

  kaiki.should have_content text || label
end

# Public: Verifies the given values from the table are present on the web page
#         in the correct text fields
# 
# line_number - line in which the text field you want filled in resides
# table_name - name of the table to be filled in
# table - table of data being read in from the feature file 
# 
# Returns: nothing
Then /^I should see the "([^"]*)" table filled out with:$/ do |table_name, table|
  kaiki.pause
  kaiki.switch_default_content
  kaiki.select_frame "iframeportlet"
  kaiki.should have_content table_name
  
  data = table.raw
  rows = data.length-1
  cols = data[0].length-1
  
    (1..rows).each do |i|
      (1..cols).each do |j|

          opt1 = "input[contains(@title, '#{data[0][j]}')]"
          opt2 = "select[contains(@title, '#{data[0][j]}')]"
          opt3 = "textarea[contains(@title, '#{data[0][j]}')]"
    
          approximate_paths = ApproximationsFactory.transpose_build(
              "//h3/span[contains(text(), '#{table_name}')]/../"             \
              "following-sibling::table/descendant::"                        \
              "tr/th[contains(text(), '#{data[i][0]}')]/"                    \
              "following-sibling::td/div/%s",       
              [opt1],
              [opt2],
              [opt3]
            )
          field_text = kaiki.get_approximate_field(approximate_paths)
          if field_text != data[i][j]
            raise Capybara::ExpectationNotMet
          end 
          
      end
    end  

end

# Public: Verifies the given values from the table are present on the web page
#         in the correct place
# 
# table_name - name of the table to be filled in
# table - table of data being read in from the feature file 
# 
# Returns: nothing
Then /^I should see Budget Totals calculated as:$/ do |table|
  kaiki.pause
  kaiki.switch_default_content
  kaiki.select_frame "iframeportlet"
  
  table.rows_hash.each do |key, value|
    kaiki.should have_content(value)
  end
end

#Puplic: Waits for the page to finish loading
#
#Parameters:
#	value- frame being loaded i e, iframeportlet
#
#Returns Nothing
When /^I wait for the document to finish being processed$/ do
  kaiki.pause(20)
  kaiki.switch_default_content
  kaiki.wait_for(:xpath, "//*[@id='iframeportlet']")
end

#Public: Verifies that the Institutional Proposal has been generated
#
#Parameters: 
#	text1- first value being checked for i e, "Institutional Proposal"
#	text2- second value being checked for ie, "has been generated"
#
#Returns Nothing
Then /^I should see a message starting with "([^"]*)" and ending with "([^"]*)"$/\
  do |text1, text2|
  kaiki.pause
  kaiki.switch_default_content
  kaiki.select_frame "iframeportlet"
  kaiki.wait_for(:xpath, "//div[@class='left-errmsg']")
  kaiki.should have_content text1
  kaiki.should have_content text2
end
