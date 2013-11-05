# Description: This file houses the interpretation of verification steps used
#              by Cucumber features.
#
# Original Date: August 20, 2011


# Public: Verifies the given text is present on the page and verifies
#         the value in the text field is correct.
#
# Parameters:
#   label - optional matcher for given text
#   text  - text to be verified
#   extra - placeholder variable for second regex for extraneous text
#   stuff - placeholder varaible for last regex for extraneous text
#
#   * the label variable is necessary for cases where the feature writer
#   * may write a statement such as:
#   * Then I should see "Status" set to "In Progress" in the document header
#
# Returns nothing.
Then(/^I should (?:see|see the message) "([^"]*)"(?:([^"]*)| (?:as|(?:set|next) to)(?:| active URL) "([^"]*)"([^"]*))$/) \
  do |label, extra, text, stuff|
  kaiki.pause
  kaiki.switch_default_content
  begin
    kaiki.select_frame("iframeportlet")
  rescue Selenium::WebDriver::Error::NoSuchFrameError
  end
  success = verify_text(label, text)
end

# Public: Verifies the given text is present on the page and verifies
#         the value in the text field is correct, using a fuzzy match.
#
# Parameters:
#   label - optional matcher for given text
#   text  - text to be verified
#   extra - placeholder variable for last regex for extraneous text
#
#   * the label variable is necessary for cases where the feature writer
#   * may write a statement such as:
#   * Then I should see "Status" set to something like "Progress" in the document header
#
# Returns nothing.
Then(/^I should see "([^"]*)" set to something like "([^"]*)"([^"]*)$/) \
  do |label, text, extra|
  kaiki.pause
  kaiki.switch_default_content
  begin
    kaiki.select_frame("iframeportlet")
  rescue Selenium::WebDriver::Error::NoSuchFrameError
  end
  success = verify_text(label, text, 'fuzzy')
end

# Public: recieves the parameters provided by step definitions to verify text
#         is on the page, using a fuzzy or exact match.
#
# Parameters:
#   label - optional matcher for given text
#   text  - text to be verified
#   mode  - the valid modes are 'exact' (default) or 'fuzzy'
#
#   * the label variable is necessary for cases where the feature writer
#   * may write a statement such as:
#   * Then I should see "Status" set to "In Progress" in the document header
#
# Returns true if the text is on the page in the appropriate spot, otherwise an
#   exception is raised.
def verify_text(label, text, mode='exact')
  begin
    kaiki.should(have_content(text || label))
  rescue RSpec::Expectations::ExpectationNotMetError
    begin
      factory1 =
        ApproximationsFactory.transpose_build(
          "//%s[contains(%s, '#{label}')]%s/following-sibling::%s",
          ['div', '.',      '/../..', "tr/td/div/input[contains(@title, '#{label}')]"],
          ['th',  'text()', '',       'td/input'])
      approximate_xpath = factory1
      element = kaiki.find_approximate_element(approximate_xpath)
      @field_text = element[:value]
    rescue Selenium::WebDriver::Error::NoSuchElementError,
           Selenium::WebDriver::Error::TimeOutError,
           Selenium::WebDriver::Error::InvalidSelectorError,
           Capybara::ElementNotFound
           
      begin
        factory1 =
          ApproximationsFactory.transpose_build(
            "//%s/../../following-sibling::%s",
            ["div[text()[contains(., '#{label}')]]", "tr/td/div"],
            ["th[contains(text(), '#{label}']",      "td/select"])
        approximate_xpath = factory1
        element = kaiki.find_approximate_element(approximate_xpath)
        field_element = element.find('option[selected]')
        @field_text = field_element.text
      rescue Selenium::WebDriver::Error::NoSuchElementError,
             Selenium::WebDriver::Error::TimeOutError,
             Selenium::WebDriver::Error::InvalidSelectorError,
             Capybara::ElementNotFound
        factory1 =
          ApproximationsFactory.transpose_build(
            "//%s[contains(., '#{label}')]/../following-sibling::td/"          \
              "descendant::textarea[contains(@title, '#{label}')]",
            ["div"],
            ["th/div"])
        approximate_xpath = factory1
        element = kaiki.find_approximate_element(approximate_xpath)
        @field_text = element.text
      end
    end
    if mode == 'exact'
      if @field_text == text
        return true
      else
        raise Capybara::ExpectationNotMet
      end
    elsif mode == 'fuzzy'
      if @field_text.include? text
        return true
      else
        raise Capybara::ExpectationNotMet
      end
    else
      raise Capybara::InvalidModeInVerifyText
    end
  end
end

# Public: Verifies the given text is present on the page
#
# Parameters:
#   text  - text to be verified
#   header - header location where text is to be
#   section - tab containing table where text is varified
#
#   * Then I will see "0721" under the "Lead Unit" header in the "Funding Proposals" section
#
# Returns nothing.
Then(/^I will see "([^"]*)" under the "([^"]*)" header in the "([^"]*)" section$/)\
  do |text, header, section|
  kaiki.pause
  kaiki.switch_default_content
  kaiki.select_frame("iframeportlet")
  factory1 =
    ApproximationsFactory.transpose_build(
       "//table/tbody/tr/td/h2[contains(text(), '#{section}')]/../../../.."    \
         "/following-sibling::div/descendant::%s[contains(%s, '#{text}')]",
       ['tr/td',     '.'     ],
       ['tr/td/div', 'text()'])
  approximate_xpath = factory1
  element = kaiki.find_approximate_element(approximate_xpath)
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
Then(/^I should see the "([^"]*)" table filled out with:$/)                    \
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
      option1 = "/input[contains(@title, '#{column_name}')]"
      option2 = "/select[contains(@title, '#{column_name}')]"
      option3 = "/textarea[contains(@title, '#{column_name}')]"
      option4 = "[text()[contains(.,'#{value}')]]"
      factory1 = 
        ApproximationsFactory.transpose_build(
          "//h3/span[contains(text(), '#{table_name}')]"                       \
            "/../following-sibling::table" \
            "/descendant::tr/th[contains(text(), '#{row_name}')]"              \
            "/following-sibling::td/div%s",
          [option1],
          [option2],
          [option3],
          [option4])
      factory2 =
        ApproximationsFactory.transpose_build(
          "//div/div[text()[contains(., '#{table_name}')]]"                    \
            "/following-sibling::div/table"                                    \
            "/descendant::th[contains(text(), '#{row_name}')]"                 \
            "/following-sibling::td/div%s",
          [option4],
          [option1],
          [option2],
          [option3])
      approximate_xpath = factory1 + factory2 
      field_text = kaiki.get_approximate_field(approximate_xpath)
      if field_text != value
        raise Capybara::ExpectationNotMet
      end
    end
  end  
end

# Public: This method may need another ApproximationsFactory segment added
#         but as is, it will fill in an input/select/textarea field in a table
#         given the name of the table.
#
# Parameters:
#   table_name - name of the table
#   table      - data to be used
#
# Returns nothing.
Then(/^I should see the "([^"]*)" table row "([^"]*)" filled with:$/)          \
  do |table_name, row_number, table|
  kaiki.pause
  kaiki.switch_default_content
  kaiki.select_frame("iframeportlet")
  kaiki.should(have_content(table_name))
  data_table = table.raw
  rows = data_table.length-1
  cols = data_table[0].length-1
  (1..rows).each do |data_row_counter|
    (0..cols).each do |data_column_counter|
      column_name = data_table[0][data_column_counter]
      value = data_table[data_row_counter][data_column_counter]
      if value != ""           
        option1 = ".[contains(text(), '#{value}')]"
        option2 = "input[contains(@title, '#{column_name}')]"
        option3 = "select[contains(@title, '#{column_name}')]"
        option4 = "textarea[contains(@title, '#{column_name}')]"
        factory1 =
          ApproximationsFactory.transpose_build(
            "//h3/span[contains(text(), '#{table_name}')]/../following-sibling"\
              "::table/descendant::tr/th[contains(text(), '#{row_number}')]"   \
              "/following-sibling::td/div/%s",
            [option4],
            [option1],
            [option2],
            [option3])              
        approximate_xpath = factory1
        element = kaiki.find_approximate_element(approximate_xpath)    
        if element[:type] == "textarea"
          field_text = element.text
        else
          field_text = kaiki.get_approximate_field(approximate_xpath)
        end
        if field_text != value
          raise Capybara::ExpectationNotMet
        end
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
Then(/^I should see (?:Budget Totals|Total) calculated as:$/) do |table|
  kaiki.pause
  kaiki.switch_default_content
  kaiki.select_frame("iframeportlet")
  table.rows_hash.each do |key, value|
    kaiki.should(have_content(value))
  end
end

# Public: Waits for the page to finish loading
#
# Parameters:
#	  value - frame being loaded i e, iframeportlet
#
# Returns nothing.
When(/^I wait for the document to finish being processed$/) do
  if @element[:title] == "submit" || @element[:title] == "Blanket Approve"
    @xpath = "//input[@title = '#{@element[:title]}'"
  elsif @element[:name] == "methodToCall.processAnswer.button1"
    @xpath = "//input[@name = '#{@element[:name]}'"
  end

  if @xpath != nil
    i = 0
    while kaiki.should(have_xpath(@xpath)) do
      kaiki.pause(1)
      i += 1
      break if i > 90
    end
  end

  kaiki.switch_default_content
  kaiki.select_frame("iframeportlet")
  j = 0
  content_check = kaiki.has_content?('The document is being processed.')
  while content_check == true do
    kaiki.pause(1)
    content_check = kaiki.has_content?('The document is being processed.')
    j += 1
    break if j > 90
  end
  kaiki.log.debug "Document processing: waited #{j+i} seconds..."
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

#Public: Verifies that the search returns at least one item
#
#Returns nothing.
Then(/^I should see one or more items retrieved$/) do
  kaiki.pause
  kaiki.switch_default_content
  kaiki.select_frame("iframeportlet")
  kaiki.should(have_content('retrieved'))
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
Then(/^I should see Combined Credit Split for "(.*?)"(?:| under "(.*?)") with the following:$/) \
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
          xpath = 
            "//td/strong[contains(text(),'#{division}')]"                      \
              "/../following-sibling::td[#{data_column}]"                      \
              "/div/strong/input"
          field_text = kaiki.get_field(xpath)
        if field_text != value
          raise Capybara::ExpectationNotMet
        end
      end
    end
  end
end

# Public: Verifies a field for a given person/section contains the given value.
#
# Parameters:
#   field - name of the field
#   name  - name of the person/section
#   value - data to be used
#
# Returns nothing.
Then(/^I should see "(.*?)" for "(.*?)" as "(.*?)"$/) do |field, name, value|     #Updated for test 8
  kaiki.pause
  kaiki.switch_default_content
  kaiki.select_frame("iframeportlet")
  option1 = "th/div[text()[contains(., '#{field}')]]"                          \
              "/../../following-sibling::tr/td/div[contains(., '#{value}')]"
  option2 = "input[contains(@title, '#{field}')]"
  option3 = "[@value = #{value}]"
  option4 = "[contains(., '#{value}')]"
  option5 = "[contains(text(), '#{value}')]"
  option6 = "[text()[contains(., '#{value}')]]"
  option7 = "[text()[contains(text(), '#{value}')]]"
  factory1 = ApproximationsFactory.transpose_build(
    "//td/div[text()[contains(., '#{name}')]]"                                 \
      "/../../following-sibling::tr/descendant::%s",
    [option1],
    [option2])
  factory2 = ApproximationsFactory.transpose_build(
    "//td/h2[text()[contains(., '#{name}')]]/../../../.."                      \
      "/following-sibling::div"                                                \
      "/descendant::tr/th/div[text()[contains(.,'#{field}')]]/.."              \
      "/following-sibling::td/span/input%s",
    [option3],
    [option4],
    [option5],
    [option6],
    [option7])
  approximate_xpath = factory1 + factory2
  returned_value = kaiki.get_approximate_field(approximate_xpath)
  if value != returned_value
    raise Capybara::ExpectationNotMet
  end
end

# Public: Verifies that no messages appear at the top of the screen,
#         because if one does appear, something has gone wrong.
#
# Returns nothing.
Then(/^I should not see a message at the top of the screen$/) do
  kaiki.pause
  kaiki.switch_default_content
  kaiki.select_frame("iframeportlet")
  kaiki.wait_for(:xpath, "//div[@class='left-errmsg']")
  element = kaiki.find(:xpath, "//div[@class='left-errmsg']")
  field_text = element.text
  if not field_text == ""
    raise Capybara::ExpectationNotMet
  end
end

# Public: Checks to see if a unit administrator has been set up for a 
#         specific unit.
#
# Returns nothing.
Given(/^unit administrator has been established \(see below\)$/) do
  
  # Here are the steps that need to occur to check that a unit administrator
  # has been set up. (Check if it is there)
  steps %{
    Given I am backdoored as "sandovar"
      And I am on the "Maintenance" tab
    When I click the "Unit Administrator" link
      And I set "Unit Number" to "0721"
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
          And I set "Description" to "Grants.gov Proposal Contact - New"
          And I set "Unit Administrator Type Code" to "6"
          And I set "KC Person" to "sesham"
          And I set "Unit Number" to "0721"
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
Then(/^I do not see "(.*?)"$/) do |description|
  kaiki.should_not(have_content(description))
end

# Public: Verifies that the field is not blank.
#
# Parameters:
#   label - the name of the field to check
#
# Returns nothing.
Then(/^I should see (.*?) not null$/) do |label|
  kaiki.pause
  kaiki.switch_default_content
  kaiki.select_frame("iframeportlet")
  element = kaiki.find(:xpath, "//th/div[text()[contains(., '#{label}')]]/../following-sibling::td")
  field_text = element.text
  if field_text == ""
    raise Capybara::ExpectationNotMet
  end
end

# Public: Fills in a table on the page with a table of values.
#
# Parameters:
#   table_name - name of the table
#   table      - data to be used
#
# Returns nothing.
Then(/^I should see the questions under "([^"]*)" with:$/) do |table_name, table| #Created for test 8
  kaiki.pause
  kaiki.switch_default_content
  kaiki.select_frame("iframeportlet")
  kaiki.should(have_content(table_name))
  data_table = table.raw
  header_row = data_table[0]
  max_data_rows = data_table.size - 1
  max_data_columns = header_row.size - 1
  (1..max_data_rows).each do |data_row_counter|
    (1..max_data_columns).each do |data_column_counter|
      row_name = data_table[data_row_counter][0]
      column_name = data_table[0][data_column_counter]
      value = data_table[data_row_counter][data_column_counter]
      if value != ""
        option1="input[@title='#{column_name}']"
        option2="select[@title='#{column_name}']"
        option3="textarea[@title='#{column_name}']"
        option4="input[@title='#{column_name} - #{value}']"
        factory1 =
          ApproximationsFactory.transpose_build(
            "//table/tbody/tr/td/h2[contains(text(), '#{table_name}')]"        \
              "/../../../../following-sibling::div/div/table/tbody/tr"         \
              "/th[contains(text(), '#{row_name}')]"                           \
              "/../descendant::%s",
            [option4],
            [option3],
            [option1],
            [option2])
        approximate_xpath = factory1
        element = kaiki.find_approximate_element(approximate_xpath)
        # TODO: Leave the commented code here. This is to provide output for
        #   future development purposes
        #  ------------------------------------------------------------------
        # begin
        #   print "Xpath Selectors: #{approximate_xpath}\n\n"
        #   print "Element: #{element}\n"
        #   print "Type of Element: #{element[:type]}"
        # rescue Exception => e
        #   print "Message: #{e.message}\n"
        # end
        if element[:type] == "radio"
          if element[:checked] != "true"
            raise Capybara::ExpectationNotMet
          end
        else
          if element.text != value
            raise Capybara::ExpectationNotMet
          end
        end
      end
    end
  end
end

# Public: Check.
#
# Parameters:
#   check_name - name of the checkbox
#   value      - data to be used
#
# Returns nothing.
Then(/^I should see the "(.*?)" checkbox is "(.*?)"$/) do |check_name, value|    #Added for Test 8
  kaiki.pause
  kaiki.switch_default_content
  kaiki.select_frame("iframeportlet")
  factory1 =
    ApproximationsFactory.transpose_build(
      "//%s[@title='#{check_name}']",
      ['tr/td/div/input'],
      ['tr/td/input'])
  approximate_xpath = factory1
  element = kaiki.find_approximate_element(approximate_xpath)
  if value.downcase == "checked"
    value = "true"
  elsif value.downcase == "unchecked"
    value = nil
  end
  if element[:checked] != value
    raise Capybara::ExpectationNotMet
  end
end
