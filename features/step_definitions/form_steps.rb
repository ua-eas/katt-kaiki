# Description: Step methods for feature files for filling in forms and tables
#
# Original Date: August 20, 2011

# Public: Defines what is to be put into a given field
#
# Parameters:
#   field - name of text field
#   value - a text or numeral value
#
# Example:
#   And I set the "Description" to "testing: KFSI-4479"
#
# Returns nothing.
When(/^I (?:set the|set) "([^"]*)" to "([^"]*)"$/) do |field, value|
  kaiki.pause
  kaiki.switch_default_content
  kaiki.select_frame("iframeportlet")

  if field == "Oblg. Start"
    name = "awardHierarchyNodeItems[1].currentFundEffectiveDate"
  elsif field == "Oblg. End"
    name = "awardHierarchyNodeItems[1].obligationExpirationDate"
  elsif field == "Obligated"
    name = "awardHierarchyNodeItems[1].amountObligatedToDate"
  elsif field == "Anticipated"
    name = "awardHierarchyNodeItems[1].anticipatedTotalAmount"
  end

    factory1 =
      ApproximationsFactory.transpose_build(
        "//%s[contains(., '#{field}')]/../following-sibling::td/%s",
        ['th/label',   'select[1]'    ],
        ['th/div',     'input[1]'     ])
    factory2 =
      ApproximationsFactory.transpose_build(
        "//%s[contains(., '#{field}')]/following-sibling::td/%s",
        ['th',          'input[1]'     ],
        [nil,           'select[1]'    ])
    factory3 =
      ApproximationsFactory.transpose_build(
        "//%s[contains(., '#{field}')]"                                        \
        "/../../following-sibling::tr/td/label/%s",
        ['th/label',    'input[1]'     ],
        ['th/div',      'select[1]'    ])
    factory4 =
      ApproximationsFactory.transpose_build(
        "//%s[contains(., '#{field}')]"                                        \
          "%s/following-sibling::tr/td/div/%s[contains(@title, '#{field}')]",
        ['th/label',  '/../..',  'input[1]'     ],
        ['th/div',    '/..',     'select[1]'    ])
    factory5 =
      ApproximationsFactory.transpose_build(
        "//th/div[contains(., '#{field}')]"                                    \
          "/../following-sibling::td/span/%s[contains(@title, '#{field}')]",
        ['input[1]'               ])
    factory6 =
      ApproximationsFactory.transpose_build(
      "//%s[contains(., '#{field}')]/../../../../../following-sibling::"       \
        "ul/descendant::td/%s[contains(@name, '#{name}')]",
      ['td',     'input' ],
      [nil,      'select'])
    factory7 =
      ApproximationsFactory.transpose_build(
        "//th[contains(., '#{field}')]"                                        \
          "/../following-sibling::tr/td/div/%s[contains(@title, '#{field}')]",
        ['input[1]'               ],
        ['select[1]'              ])

    approximate_xpath = factory1 + factory2 + factory3 + factory4 + factory5   \
      + factory6 + factory7
    kaiki.set_approximate_field(approximate_xpath, value)
end

# Public: Defines what is to be put into a given field
#
# Parameters:
#   field - name of text field
#   value - a text or numeral value
#
# Example:
#   And I set the "Description" to something like "testing: KFSI-4479"
#
# Returns nothing.
When(/^I (?:set the|set) "([^"]*)" text area to "([^"]*)"$/)                   \
  do |field, value|
  kaiki.pause
  kaiki.switch_default_content
  kaiki.select_frame("iframeportlet")
  approximate_xpath =
    ApproximationsFactory.transpose_build(
      "//%s[contains(text(), '#{field}')]/../following-sibling::td/%s",
      ['th/label',    'textarea[1]'  ],
      ['th/div',      'input[1]'     ],
      [nil,           'select[1]'    ]) +
      ApproximationsFactory.transpose_build(
      "//%s[contains(text(), '#{field}')]"                                     \
        "/../../following-sibling::tr/td/div/%s",
      ['th/div',      'textarea[1]'  ],
      ['th/label',    'input[1]'     ],
      [nil,           'select[1]'    ])
  kaiki.set_approximate_field(approximate_xpath, value)
end

# Public: Sets a dropdown using a fuzzy match
#
# Parameters:
#   field - name of dropdown
#   value - a text or numeral value
#
# Example:
#   And I set the "Destination Award" to something like "-00001"
#
# Returns nothing.
When(/^I (?:set the|set) "([^"]*)" to something like "([^"]*)"$/)             \
  do |field, value|
  kaiki.pause
  kaiki.switch_default_content
  kaiki.select_frame("iframeportlet")
  approximate_xpath =
    ApproximationsFactory.transpose_build(
      "//th[contains(., '#{field}')]"                                  \
        "/../following-sibling::tr/td/div/%s[contains(@title, '#{field}')]",
      ['select[1]'              ])

    element = kaiki.find_approximate_element(approximate_xpath)
    element_option = element.find(:xpath, "option[contains(text(), '#{value}')]")
    element_option.click
end

# Public: Sets a field for a given person/section to the given value
#
# Parameters:
#   field - name of the field
#   name  - name of the person/section
#   value - data to be used
#
# Returns nothing.
When(/^I set "(.*?)" (?:under|for) "(.*?)" as "(.*?)"$/)                       \
  do |field, name, value|
  kaiki.pause
  kaiki.switch_default_content
  kaiki.select_frame("iframeportlet")
  #~ xpath =
    #~ "//table/tbody/tr/td/h2[contains(text(),'#{name}')]"                      \
      #~ "/../../../../following-sibling::div"                                   \
      #~ "/descendant::input[@title='#{field}']"
  #~ element = kaiki.find(:xpath, xpath)
  #~ element.set(value)

  approximate_xpath =
    [
      "//table/tbody/tr/td/h2[contains(text(),'#{name}')]/../../../../"        \
      "following-sibling::div/descendant::input[@title='#{field}']",
      "//th[contains(., '#{field}')]/../following-sibling::tr/td/div/input",
      nil
    ]
  element = kaiki.find_approximate_element(approximate_xpath)
  element.set(value)
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
          element = kaiki.find(:xpath, xpath)
          element.set(value)
      else
        xpath =
          "//tr/td/strong[contains(text(),'#{name}')]"                         \
            "/../../following-sibling::tr/td[contains(text(),'#{division}')]"  \
            "/following-sibling::td[#{data_column}]/div/input"
        element = kaiki.find(:xpath, xpath)
        element.set(value)
      end
    end
  end
end

# Public: Fills in a table on the page with a table of values.
#
# Parameters:
#   table_name - name of the table
#   table      - data to be used
#
# Returns nothing.
When(/^I answer the questions under "(.*?)" with:$/) do |table_name, table|
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
        approximate_xpath =
          ApproximationsFactory.transpose_build(
            "//table/tbody/tr/td/h2[contains(text(), '#{table_name}')]"        \
            "/../../../../following-sibling::div/div/table/tbody/tr/th"        \
              "[contains(text(), '#{row_name}')]"                              \
            "/../descendant::%s",
            [option4],
            [option3],
            [option1],
            [option2])
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
# Parameters:
#   table_name - name of the table
#   table      - data to be used
#
# Returns nothing.
When(/^I fill out the "([^"]*)" table with:$/) do |table_name, table|
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
      if value != ""
          option1 = "input[contains(@title, '#{column_name}')]"
          option2 = "select[contains(@title, '#{column_name}')]"
          option3 = "textarea[contains(@title, '#{column_name}')]"
          approximate_xpath =
            ApproximationsFactory.transpose_build(
              "//h3/span[contains(text(), '#{table_name}')]"                   \
                "/../following-sibling::table"                                 \
                "/descendant::tr/th[contains(text(), '#{row_name}')]"          \
                "/following-sibling::td/div/%s",
              [option1],
              [option2],
              [option3])
          kaiki.set_approximate_field(approximate_xpath, value)
      end
    end
  end
end

# Public: Checks a checkbox given the name by utlizing the ApproximationFactory
#         to find the xpath of the checkbox.
#
# Parameters:
#   check_name - name of the checkbox
#
# Returns nothing.
When(/^I check the "([^"]*)" checkbox$/) do |check_name|
  kaiki.pause
  kaiki.switch_default_content
  kaiki.select_frame("iframeportlet")
  approximate_xpath =
    ApproximationsFactory.transpose_build(
      "//%s[contains(text(), '#{check_name}')]"                                \
        "/../following-sibling::td/%s[@title = '#{check_name}']",
      ['th/div',      'input[1]'     ],
      ['th/label',    'select[1]'    ])
  kaiki.check_approximate_field(approximate_xpath)
end

# Public: Selects the radio button next to the option that is given by
#         using the approximation factory to find the xpath to the radio
#         button.
#
# Parameters:
#   field - name of the lable next to the radio button
#
# Returns nothing.
When (/^I click the "([^"]*)" radio button$/) do |field|
  kaiki.pause
  kaiki.switch_default_content
  kaiki.select_frame("iframeportlet")
  approximate_xpath =
    ApproximationsFactory.transpose_build(
      "//%s[contains(text(), '#{field}')]"                                     \
      "/preceding-sibling::th/%s",
      ['tr/td',      'input[1]'     ],
      [nil,         'select[1]'    ])
  element = kaiki.find_approximate_element(approximate_xpath)
  button_type = element[:type]
  kaiki.click_approximate_field(approximate_xpath, button_type)
end
