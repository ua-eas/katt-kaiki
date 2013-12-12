# Description: This file contains everything pertaining to filling in
#              various fields on the webpage.
#
# Original Date: August 20, 2011


# Description: Defines what is to be put into a given field
#
# Parameters:
#   field      - name of text field
#   value      - a text or numeral value
#   subsection - subsection of the page the radio should be in
#
# Example:
#   And I set the "Description" to "testing: KFSI-4479"
#
# Returns nothing.
When(/^I (?:set the|set) "([^"]*)" to "([^"]*)"(?:| (?:under|in) the "([^"]*)" subsection)$/)\
  do |field, value, subsection|

  kaiki.get_ready

  if field.include? "Cost"
    field = "Cost"
  elsif field.include? "Amt"                                                    
    field = "Amount"  
  end

  special_case_field = {
    "Oblg. Start" => {:section => "Award Hierarchy", :field => "awardHierarchyNodeItems[1].currentFundEffectiveDate"},
    "Oblg. End" => {:section => "Award Hierarchy", :field => "awardHierarchyNodeItems[1].obligationExpirationDate"},
    "Obligated" => {:section => "Award Hierarchy", :field => "awardHierarchyNodeItems[1].amountObligatedToDate"},
    "Anticipated" => {:section => "Award Hierarchy", :field => "awardHierarchyNodeItems[1].anticipatedTotalAmount"},
    "Project End" => {:section => "Award Hierarchy", :field => "awardHierarchyNodeItems[1].finalExpirationDate"},
    "Deposit" => {:section => "Deposit Header", :field => "depositTicketNumber"}
  }

  special_case_value = {
    "the recorded document number" => kaiki.record[:document_number],
    "the recorded requisition number" => kaiki.record[:requisition_number],
    "the recorded purchase order number" => kaiki.record[:purchase_order_number],
    "the recorded payment request number" => kaiki.record[:payment_request_number],
    "Today's Date" => kaiki.record[:today]
  }

  if special_case_field.key?(field)
    special_case_field.each do |key, value|
      if key.eql?(field)
        field = value[:field] if @section.eql?(value[:section])
      end
    end
  elsif special_case_value.key?(value)
    special_case_value.each do |key, option|
      value = option if key.eql?(value)
    end
  end

  case @tab
  when "Route Log"
    #Place holder for now, in case we need to set some field in the
    #Route Log tab
  else
    if subsection
# factory0 - KFS PA004-01 (Create Requisition)
# factory0 - KFS DI003-01 (Initiate DI)
      factory0 =                                                                
        ApproximationsFactory.transpose_build(
          "//h2[contains(., '#{@tab}')]/../../../../following-sibling::"       \
          "div/descendant::span[contains(., '#{@section}')]/../../"            \
          "following-sibling::tr/td[text()[contains(., '#{subsection}')]]/../" \
          "following-sibling::tr/descendant::%s[contains(@title, '#{field}')]",
          ['textarea'],
          ['input'],
          ['select'])                                                           
# factory1 - KFS PA004-0304 (Purchase Order)
      factory1 =
        ApproximationsFactory.transpose_build(
        "//h2[contains(., '#{@tab}')]/../../../../following-sibling::div/"     \
        "descendant::h3[contains(., '#{@section}')]/following-sibling::"       \
        "table/descendant::tr[contains(., '#{subsection}')]/following-sibling::"\
        "tr/descendant::%s[contains(@title, '#{field}')]",
        ['textarea'],
        ['input'],
        ['select'])
# factory2 - KC Feat. 2 (Award)
      factory2 =
        ApproximationsFactory.transpose_build(
        "//h2[contains(., '#{@tab}')]/../../../../following-sibling::div/"     \
        "descendant::span[contains(., '#{@section}')]/../following-sibling::"  \
        "div[contains(., '#{subsection}')]/following-sibling::"                \
        "div/descendant::%s[contains(@title, '#{field}')]",
        ['textarea'],
        ['input'],
        ['select'])
# factory3 - KFS PA004-01 (Create Requisition)
      factory3 =
        ApproximationsFactory.transpose_build(
        "//h2[contains(., '#{@tab}')]/../../../../following-sibling::div/"     \
        "descendant::tr[contains(., '#{subsection}')]/following-sibling::"     \
        "tr/th/label[contains(text(), '#{field}')]/../following-sibling::td/%s",
        ['textarea'],
        ['input'],
        ['select'])
# factory4- KC Test 7 (Key Personnel)
      factory4 =
        ApproximationsFactory.transpose_build(
        "//h2[contains(., '#{@tab}')]/../../../../following-sibling::div/"     \
        "descendant::h3[contains(., '#{@section}')]/following-sibling::"       \
        "table/descendant::div[contains(., '#{subsection}')]/following-sibling::"\
        "div/descendant::%s[contains(@title, '#{field}')]",
        ['textarea'],
        ['input'],
        ['select'])
      @approximate_xpath = factory0                                            \
                         + factory1                                            \
                         + factory2                                            \
                         + factory3                                            \
                         + factory4
    elsif @sec_type == "td"
# factory0 - KFS PA004-0304 (Purchase Order)
      factory0 =
      ApproximationsFactory.transpose_build(
        "//h2[contains(., '#{@tab}')]/../../../../following-sibling::div/"     \
        "descendant::tr[contains(., '#{@section}')]/"                          \
        "following-sibling::tr/descendant::%s/following-sibling::td/%s",
        ["div[text()[contains(., '#{field}')]]/..",   "textarea"],
        ["th[contains(text(), '#{field}')]",          "input"],
        [ nil,                                        "select"])
# factory1 - KC Feat. 1 (Key Personnel)
# factory1 - KC Feat. 3 (Key Personnel)
# factory1 - KC Feat. 6 (Proposal, Key Personnel)
# factory1 - KC Feat. 7 (Key Personnel)
      factory1 =
        ApproximationsFactory.transpose_build(
        "//td[contains(text(), '#{@section}')]/../../../following-sibling::div/"\
        "descendant::%s[contains(., '#{field}')]/../following-sibling::td/%s",
        ['div',   'select'],
        ['label', nil])
      @approximate_xpath = factory0                                            \
                         + factory1
    else
# factory0 - KFS PA004-01 (Create Requisition)
# factory0 - KFS PA004-0304 (Purchase Order)
# factory0 - KFS PA004-05   (Payment Request)
# factory0 - KFS PA004-06   (Vendor Credit Memo)
# factory0 - KC Feat. 1     (Proposal, Key Personnel, Special Review)
# factory0 - KC Feat. 2     (Award, Commitments, Time & Money)
# factory0 - KC Feat. 3     (Proposal, Key Personnel, Special Review)
# factory0 - KC Feat. 4     (Time and Money, Commitments)
# factory0 - KC Feat. 6     (Proposal, Key Personnel, Special Review)
# factory0 - KC Feat. 7     (Proposal Page, Special Review Page, Budget Versions Parameters)
# factory0 - KC Feat. 8     (Proposal Actions)
# factory0 - KC Faet. 13    (Institutional Proposal Page)
      factory0 =
        ApproximationsFactory.transpose_build(
        "//h2[contains(., '#{@tab}')]/../../../../following-sibling::div/"     \
        "descendant::h3[contains(., '#{@section}')]/following-sibling::"       \
        "table/descendant::%s[contains(@title, '#{field}')]",
        ['textarea'],
        ['input'],
        ['select'])
# factory1 - KC Feat. 1 (Budget Versions)
# factory1 - KC Feat. 2 (Time & Money)
# factory1 - KC Feat. 3 (Budget Versions)
# factory1 - KC Feat. 7 (Budget Versions)
# factory1 - KC Feat. 8 (Budget Verisons)
      factory1 =
        ApproximationsFactory.transpose_build(
        "//h2[contains(., '#{@tab}')]/../../../../following-sibling::div/"     \
        "descendant::h3[contains(., '#{@section}')]/following-sibling::"       \
        "%s/descendant::%s[contains(@name, '#{field}')]",
        ['div',    'input'],
        ['table',  nil])
      # factory2 =
        # ApproximationsFactory.transpose_build(
        # "//h2[contains(., '#{@tab}')]/../../../../following-sibling::div/"     \
        # "descendant::h3[contains(., '#{@section}')]/../following-sibling::"    \
        # "tr/descendant::%s[contains(@title, '#{field}')]",
        # ['textarea'],
        # ['input'],
        # ['select'])
# factory3 - KFS PA004-01 (Create Requisition)
# factory3 - KC Feat. 1   (Custom Data)
# factory3 - KC Feat. 3   (Custom Data)
# factory3 - KC Feat. 6   (Custom Data)
# factory3 - KC Feat. 7   (Custom Data)
      factory3 =
        ApproximationsFactory.transpose_build(
        "//h2[contains(., '#{@tab}')]/../../../../following-sibling::div/"     \
        "descendant::h3[contains(., '#{@section}')]/following-sibling::"       \
        "table/descendant::th[contains(., '#{field}')]/following-sibling::td/%s",
        ['input'],
        ['select'])
      # @approximate_xpath = factory0                                            \
                         # + factory1                                            \
                         # + factory2                                            \
                         # + factory3
      @approximate_xpath = factory0 + factory1 + factory3
    end
  end
  kaiki.set_approximate_field(@approximate_xpath, value)
end

# Description: Sets a dropdown using a fuzzy match
#
# Parameters:
#   field - name of dropdown
#   value - a text or numeral value
#
# Example:
#   And I set the "Destination Award" to something like "-00001"
#
# Returns nothing.
When(/^I (?:set the|set) "([^"]*)" to something like "([^"]*)"$/)              \
  do |field, value|

  kaiki.get_ready
# factory0 - KC Feat. 2 (Time & Money)
  # factory0 =
    # ApproximationsFactory.transpose_build(
      # "//%s[contains(@title,'#{field}')]",
      # ['select'],
      # ['input' ])
# factory1 - KC Feat. 4 (Time and Money)
  # factory1 =
    # ApproximationsFactory.transpose_build(
      # "//th[contains(., '#{field}')]"                                          \
        # "/../following-sibling::tr/td/div/%s[contains(@title, '#{field}')]",
      # ['select[1]'])
      factory0 =
        ApproximationsFactory.transpose_build(
        "//h2[contains(., '#{@tab}')]/../../../../following-sibling::div/"     \
        "descendant::h3[contains(., '#{@section}')]/following-sibling::"       \
        "table/descendant::%s[contains(@title, '#{field}')]",
        ['textarea'],
        ['input'],
        ['select'])
#  approximate_xpath = factory0                                                 \
#                    + factory1
  approximate_xpath = factory0
  element = kaiki.find_approximate_element(approximate_xpath)
  element_option = element.find(:xpath, "option[contains(text(), '#{value}')]")
  element_option.click
end

# KC Feat. 1 (Key Personnel)
# KC Feat. 3 (Key Personnel)
# KC Feat. 6 (Key Personnel)
# KC Feat. 7 (Key Personnel)
# KC Feat. 8 (Key Personnel)

# Description: Fills out a row of data for the Combined Credit Split table.
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
When(/^I fill out the Combined Credit Split for "(.*?)"(?:| under "(.*?)") with the following:$/)\
  do |division, name, table|

  kaiki.get_ready
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
          kaiki.highlight(:xpath, xpath)
          element.set(value)
      else
        xpath =
          "//tr/td/strong[contains(text(),'#{name}')]"                         \
            "/../../following-sibling::tr/td[contains(text(),'#{division}')]"  \
            "/following-sibling::td[#{data_column}]/div/input"
        element = kaiki.find(:xpath, xpath)
        kaiki.highlight(:xpath, xpath)
        element.set(value)
      end
    end
  end
end

# Description: Checks a checkbox given the name by utlizing the ApproximationFactory
#         to find the xpath of the checkbox.
#
# Parameters:
#   check_name - name of the checkbox
#
# Returns nothing.
When(/^I check the "([^"]*)" checkbox(?:| for "([^"]*)")$/) do |check_name, row_number|
  kaiki.get_ready
# factory0 - KFS CASH001-01 (Open Cash Drawer)  
  if row_number                                                                  
    row_number = "#" if row_number.eql?("all")
    factory0 =
      ApproximationsFactory.transpose_build(
      "//h2[contains(., '#{@tab}')]/../../../../following-sibling::"           \
        "div/descendant::h3[contains(., '#{@section}')]/following-sibling::"   \
        "div/descendant::%s[contains(., '#{row_number}')]/"                    \
        "preceding-sibling::td/descendant::%s",
        ['th',  'input'],                                                       
        ['td',  nil])
    approximate_xpath = factory0                                                
  kaiki.check_approximate_field(approximate_xpath)
  else
# factory0 - KFS PA004-05 (Payment Request)
# factory0 - KC Feat. 7   (Budget Versions Parameters Page)
# factory0 - KC Feat. 8   (Proposal Actions, Budget Versions)
  factory0 =
    ApproximationsFactory.transpose_build(
      "//h2[contains(., '#{@tab}')]/../../../../following-sibling::"           \
        "div/descendant::h3[contains(., '#{@section}')]/following-sibling::"   \
        "table/descendant::%s[contains(@title,'#{check_name}')]",
      ['input' ])
# factory1 - KC Feat. 6 (Key Personnel)
  factory1 =
    ApproximationsFactory.transpose_build(
      "//h2[contains(text(), '#{check_name}')]/preceding-sibling::%s",
      ['input'])
# factory6 - KC Feat. 13 (Institutional Proposal Actions Page)
  factory2 =
    ApproximationsFactory.transpose_build(
      "//tr/th[contains(text(), '#{check_name}')]"                             \
        "/../following-sibling::tr/td/div/%s",
      ['input'])
  approximate_xpath = factory0                                                 \
                    + factory1                                                 \
                    + factory2
  kaiki.check_approximate_field(approximate_xpath)
  end
end

# KC Feat. 2 (Time & Money)

# Description: This method will fill in a specific field in a specific row
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
  factory0 =
    ApproximationsFactory.transpose_build(
      "//%s[contains(text(),'#{table_name}')]"                                 \
        "/../../../../following-sibling::%s[contains(text(),'#{row_number}')]" \
        "/following-sibling::%s[contains(@title,'#{label}')]",
      ['table/tbody/tr/td/h2', 'div/div/table/tbody/tr/th', 'td/div/input' ])
  approximate_xpath = factory0
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

  calendar_name = label.sub('Date', '').gsub(/\s/, '')
  kaiki.find_approximate_element(["//h2[contains(., '#{@tab}')]/../../../../"  \
    "following-sibling::div/descendant::img[contains(@id, '#{calendar_name}')]"]).click
  kaiki.select_calender_date(date_option)
end
