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

  special_case_field = {
    "Oblg. Start" => {:section => "Award Hierarchy", :field => "awardHierarchyNodeItems[1].currentFundEffectiveDate"},
    "Oblg. End" => {:section => "Award Hierarchy", :field => "awardHierarchyNodeItems[1].obligationExpirationDate"},
    "Obligated" => {:section => "Award Hierarchy", :field => "awardHierarchyNodeItems[1].amountObligatedToDate"},
    "Anticipated" => {:section => "Award Hierarchy", :field => "awardHierarchyNodeItems[1].anticipatedTotalAmount"},
    "Project End" => {:section => "Award Hierarchy", :field => "awardHierarchyNodeItems[1].finalExpirationDate"},
    "Extended Cost" => {:section => "Additional Charges", :field => "Unit Cost"},
    "Deposit" => {:section => "Deposit Header", :field => "depositTicketNumber"},
    "Person" => {:section => "Ad Hoc Recipients", :field => "Principal Name"}
  }

  special_case_value = {
    "the recorded document number" => kaiki.record[:document_number],
    "the recorded requisition number" => kaiki.record[:requisition_number],
    "the recorded purchase order number" => kaiki.record[:purchase_order_number],
    "the recorded payment request number" => kaiki.record[:payment_request_number],
    "the recorded vendor credit memo document number" => kaiki.record[:vendor_credit_memo_document_number],
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
  elsif value =~ /{\d+i}/
    value = mod_value(value, :type => "digit")
  end

  case @tab
  when "Route Log"
    #Place holder for now, in case we need to set some field in the
    #Route Log tab
  else
    if subsection
# factory0 - KFS PA004-01  (Create Requisition)
# factory0 - KFS DI003-01  (Initiate DI)
# factory0 - KFS PRE001-01 (Initiate Pre-Encumbrance)
# factory0 - KFS TF001-01  (Initiate Transfer of Funds)
# factory0 - KFS SET001-01 (Initiate SET)
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
# factory3 - KFS PA004-01   (Create Requisition)
# factory3 - KFS 1099001-01 (Search for Payee)
# factory3 - KFS COA002-01  (Initiate New Object Code)
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
# factory0 - KFS PA004-01   (Create Requisition)
# factory0 - KFS PA004-0304 (Purchase Order)
# factory0 - KFS PA004-05   (Payment Request)
# factory0 - KFS PA004-06   (Vendor Credit Memo)
# factory0 - KFS CASH001-01 (Open Cash Drawer)
# factory0 - KFS 1099001-01 (Search for Payee)
# factory0 - KFS DV001-01   (Check ACH)
# factory0 - KAF DI003-01   (Initiate DI)
# factory0 - KFS PRE001-01  (Initiate Pre-Encumbrance)
# factory0 - KFS TF001-01   (Initiate Transfer of Funds)
# factory0 - KFS COA002-01  (Initiate New Object Code)
# factory0 - KFS SET001-01  (Initiate SET)
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
# factory1 - KFS CASH001-01 (Open Cash Drawer)
# factory1 - KC Feat. 1     (Budget Versions)
# factory1 - KC Feat. 2     (Time & Money)
# factory1 - KC Feat. 3     (Budget Versions)
# factory1 - KC Feat. 7     (Budget Versions)
# factory1 - KC Feat. 8     (Budget Verisons)
      factory1 =
        ApproximationsFactory.transpose_build(
        "//h2[contains(., '#{@tab}')]/../../../../following-sibling::div/"     \
        "descendant::h3[contains(., '#{@section}')]/following-sibling::"       \
        "%s/descendant::%s[contains(@name, '#{field}')]",
        ['div',    'input'],
        ['table',  nil])
# factory2 - KFS PA004-01   (Create Requisition)
# factory2 - KFS CASH001-01 (Open Cash Drawer)
# factory2 - KC Feat. 1     (Custom Data)
# factory2 - KC Feat. 3     (Custom Data)
# factory2 - KC Feat. 6     (Custom Data)
# factory2 - KC Feat. 7     (Custom Data)
      factory2 =
        ApproximationsFactory.transpose_build(
        "//h2[contains(., '#{@tab}')]/../../../../following-sibling::div/"     \
        "descendant::h3[contains(., '#{@section}')]/following-sibling::"       \
        "table/descendant::th[contains(., '#{field}')]/following-sibling::td/%s",
        ['input'],
        ['select'])
# factory3 - KFS DV001-01 (Check ACH)
      factory3 =
        ApproximationsFactory.transpose_build(
          "//h2[contains(., '#{@tab}')]/../../../../following-sibling::div"\
            "/descendant::span[contains(., '#{@section}')]/../.."\
            "/following-sibling::tr/descendant::%s[contains(@title, '#{field}')]",
         ['input' ],
         ['select'])
      if value.include? '<todays date>'
        value = value.sub('<todays date>', Time.now.strftime("%m%d%Y%H%M"))
      end
# factory4 - KFS PVEN002-01 (Foreign PO Vendor)
      locationPVEN002 = vendor_page_field_location(field)
      factory4 = [
        "//h2[contains(., '#{@tab}')]/../../../../following-sibling::div"\
          "/descendant::h3[contains(., '#{@section}')]"\
          "/following-sibling::table/descendant::#{locationPVEN002}"
        ]
      @approximate_xpath = factory0                                            \
                         + factory1                                            \
                         + factory2                                            \
                         + factory3                                            \
                         + factory4
    end
  end
  kaiki.set_approximate_field(@approximate_xpath, value)
end

# Description: This step sets a select field using a partial match. If there
#              are multiple options to choose from, this step will choose the
#              first option.
#
# Parameters:
#   field - The name of the select field.
#   value - The partial value to set the select field to.
#
# Example: (taken from KC 3_proposal_continuation)
#   When I set the Award ID" to something like "-00001"
#
# Returns nothing.
When(/^I (?:set the|set) "([^"]*)" to something like "([^"]*)"(?:| (?:under|in) the "([^"]*)" subsection)$/)\
  do |field, value, subsection|

  kaiki.get_ready
# factory0 - KC Feat. 2 (Time & Money)
# factory0 - KC Feat. 4 (Time & Money)
    factory0 =
      ApproximationsFactory.transpose_build(
      "//h2[contains(., '#{@tab}')]/../../../../following-sibling::div/"     \
      "descendant::h3[contains(., '#{@section}')]/following-sibling::"       \
      "table/descendant::%s[contains(@title, '#{field}')]",
      ['textarea'],
      ['input'],
      ['select'])
# factory1 - KFS COA002-01 (Initiate New Object Code)
    factory1 =
      ApproximationsFactory.transpose_build(
      "//h2[contains(., '#{@tab}')]/../../../../following-sibling::div/"     \
      "descendant::tr[contains(., '#{subsection}')]/following-sibling::"     \
      "tr/th/label[contains(text(), '#{field}')]/../following-sibling::td/%s",
      ['textarea'],
      ['select'],
      ['input'])
  approximate_xpath = factory0                                                 \
                    + factory1
  element = kaiki.find_approximate_element(approximate_xpath)
  element_option = element.find(:xpath, "option[text()[contains(., '#{value}')]]")
  element_option.click
end

# KC Feat. 1 (Key Personnel)
# KC Feat. 3 (Key Personnel)
# KC Feat. 6 (Key Personnel)
# KC Feat. 7 (Key Personnel)
# KC Feat. 8 (Key Personnel)

# Description: This step fills out a row of data for the Combined Credit Split
#              table. Due to the structure of this table, a special definition
#              needed to be created.
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
#   field_name - This is the name of the field that is to be filled.
#   value      - This is the value of the field to be filled.
#
# Example: (taken from KC 1_proposal_new)
#   And I fill out the Combined Credit Split for "Linda L Garland" with the following:
#     | Credit for Award | 25 |
#     | F&A Revenue      | 25 |
#   And I fill out the Combined Credit Split for "0721 - Cancer Center Division" under "Linda L Garland" with the following:
#     | Credit for Award | 100 |
#     | F&A Revenue      | 100 |
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

# Description: This step checks the named checkbox.
#
# Parameters:
#   check_name - The name of the checkbox.
#   row_number - OPTIONAL - The row indicator for a checkbox in a table.
#
# Example: (taken from KC 1_proposal_new)
#   And I click the "Final?" checkbox
#
# Returns nothing.
When(/^I ([^"]*) the "([^"]*)" checkbox(?:| for "([^"]*)")(?:|(?: under| in) the "([^"]*)" subsection)$/)\
  do |option, check_name, row_number, subsection|

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
    @approximate_xpath = factory0
  elsif subsection
    factory0 =
      ApproximationsFactory.transpose_build(
      "//h2[contains(., '#{@tab}')]/../../../../following-sibling::"           \
        "div/descendant::tr[contains(., '#{subsection}')]/%s"                  \
        "tr/th[contains(., '#{check_name}')]/following-sibling::td/input",
        ['following-sibling::'],
        ['../../table/descendant::'])
    @approximate_xpath = factory0
  else
# factory0 - KFS PA004-05 (Payment Request)
# factory0 - KC Feat. 7   (Budget Versions Parameters Page)
# factory0 - KC Feat. 8   (Proposal Actions, Budget Versions)
    factory0 =
      ApproximationsFactory.transpose_build(
        "//h2[contains(., '#{@tab}')]/../../../../following-sibling::"         \
          "div/descendant::h3[contains(., '#{@section}')]/following-sibling::" \
          "table/descendant::%s[contains(@title,'#{check_name}')]",
        ['input' ])
# factory1 - KC Feat. 6 (Key Personnel)
    factory1 =
      ApproximationsFactory.transpose_build(
        "//h2[contains(text(), '#{check_name}')]/preceding-sibling::%s",
        ['input'])
# factory2 - KC Feat. 13 (Institutional Proposal Actions Page)
    factory2 =
      ApproximationsFactory.transpose_build(
        "//tr/th[contains(text(), '#{check_name}')]"                           \
          "/../following-sibling::tr/td/div/%s",
        ['input'])
    @approximate_xpath = factory0                                              \
                       + factory1                                              \
                       + factory2
  end
  if option.eql?("check")
    kaiki.check_approximate_field(@approximate_xpath)
  else
    kaiki.uncheck_approximate_field(@approximate_xpath)
  end
end

# KC Feat. 2 (Time & Money)

# Description: This step will fill in a field in the specified row in the
#              specified table on the page.
#
# Parameters:
#   label      - The name of the field to be filled in.
#   row_number - This is the row number.
#   value      - The value to be filled into the field
#   table_name - The name of the table.
#
# Example: (taken from KC 12_award_no_cost_extension)
#   And I set "End Date" in row "5" to "06/11/2019" under the "Direct/F&A Funds Distribution" table
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

# Description: This step will open the calendar popup adjacent to the specified
#              field and select the appropriate date from within it by calling
#              the approporiate method in the CapybaraDriver.
#
# Requirement: If a date other than 'Today' is to be selected, the format for
#              the date needs to be in long date format. See the example below.
#
# Parameters:
#   label         - name of the field the calendar is adjacent to
#   date_option   - option inside the calender to be selected
#
# Example: (currently unused in any feature file)
#   When I click the "Date Required" calendar and set the date to "Today"
#   When I click the "Date Required" calendar and set the date to "November 19, 2013"
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