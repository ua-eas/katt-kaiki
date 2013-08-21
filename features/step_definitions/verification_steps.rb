# Description: This file houses the interpretation of verification steps used 
#              by Cucumber features.
#
# Original Date: August 20, 2011


# Public: The following Webdriver code tells kaikifs to check for the specified 
#         message at the top of the page.
#
# Parameters:
#   text - the user's specified text.
#
# Returns nothing.
Then /^I should see the message "([^"]*)"$/ do |text|
  kaiki.pause
  kaiki.switch_default_content
  kaiki.select_frame "iframeportlet"
  kaiki.wait_for(:xpath, "//div[@class='msg-excol']")
  kaiki.should have_content text
end

# Public: Verifies given text is present in the document header
#
# where  -  loction of the text to be verified
# text  -  text to be verified
#
# Returns: nothing 
Then /^I should see "([^"]*)" set to "([^"]*)" in the document header$/\
  do |where, text|
  kaiki.pause
  kaiki.switch_default_content
  kaiki.select_frame "iframeportlet"
  kaiki.wait_for(:xpath, "//div[@class='headerbox']")
  kaiki.should have_content text
end

# Public: Verifies given text is present under the sponsor code
#
# Parameters:
#   text  -  text to be verified
#
# Returns: nothing  
Then /^I should see "([^"]*)" under the sponsor code$/ do |text|
  kaiki.pause
  kaiki.switch_default_content
  kaiki.select_frame "iframeportlet"
  kaiki.wait_for(:xpath, "//*[@id='sponsorName.div']")
  kaiki.should have_content text
end

# Public: Verifies the given values from the table are present on the web page
#         in the correct text fields
# 
# line_number - line in which the text field you want filled in resides
# table_name - name of the table to be filled in
# table - table of data being read in from the feature file 
# 
# Returns: nothing
Then /^I should see line "([^"]*)" of the "([^"]*)" table filled out with:$/ \
                                            do |line_number, table_name, table|
  kaiki.pause
  kaiki.switch_default_content
  kaiki.select_frame "iframeportlet"
  kaiki.should have_content table_name
  
  table.rows_hash.each do |key, value|
    field_text = kaiki.get_approximate_field(
      ApproximationsFactory.transpose_build(
        "//%s[contains(text()%s, '#{key}')]/../../following-sibling::"         \
        "tr/th[contains(text(), '#{line_number}')]/following-sibling::"        \
        "td/div/%s[contains(@title, '#{key}')]",
        ['th/label',    '',       'select[1]'],
        ['th/div',      '[1]',    'input[1]'],
        [nil,           '[2]',    nil]
      )
    )
    if field_text != value
      raise Capybara::ExpectationNotMet
    end
  end
end
