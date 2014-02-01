# Description: This file contains everything pertaining to the verification of
#              the content that appears on the kuali webpages.
#
# Original Date: August 20, 2011


# KC and KFS all features

# Description: This step is for general verification of messages on the browser page.
#
# Parameters:
#   message - Message that should appear on the screen.
#
# Example:
#   Then I should see the message "Document was successfully saved."
#
# Returns nothing.
Then (/^I should see the message "(.*?)"$/) do |message|
  kaiki.get_ready
  kaiki.should(have_content(message))
end

# KC and KFS all features

# Description: This step definition is to verify text that shows up in the
#              document header.
#
# Parameters:
#   label - Label for the text in the document header.
#   text  - Text to be verified on the page.
#
# Example:
#	Then I should see the "Status" text set to "Final" in the document header
#
# Returns nothing.
Then (/^I should see (?:|the )"(.*?)" text set to "(.*?)" in the document header$/)\
  do |label, text|

  kaiki.get_ready
  factory0 =
    ApproximationsFactory.transpose_build(
    "//th[contains(., '#{label}')]/following-sibling::%s",
    ['td'])
  approximate_xpath = factory0
  begin
    element = kaiki.find_approximate_element(approximate_xpath)
    field_text = element.text
    raise Capybara::ExpectationNotMet unless field_text.include?(text)
  rescue Capybara::ExpectationNotMet
    kaiki.get_ready
    kaiki.click_approximate_field(["//a[@title='reload']"])
    retry
  end
end

# Description: This step verifies the given text is present on the page and verifies
#              the value in the text field is correct.
#
# Parameters:
#   label      - Optional matcher for given text.
#   text       - Text to be verified.
#   subsection - OPTIONAL - Area of the page the text should be located in.
#   person     - OPTIONAL - A subsection that is a person's name under which the field appears.
#
# Example:
#	  Then I should see "Account Number" set to "1732100" in the "From" subsection
#
# Returns nothing.
Then (/^I should see "(.*?)" (?:as|set to)(?:| active URL) "(.*?)"(?:| (?:under|in) the "([^"]*)" subsection)(?:| for "([^"]*)")$/)\
  do |label, text, subsection, person|

  kaiki.get_ready

  special_case_field = {
    "Oblg. Start" => {:section => "Award Hierarchy", :label => "awardHierarchyNodeItems[1].currentFundEffectiveDate"},
    "Oblg. End" => {:section => "Award Hierarchy", :label => "awardHierarchyNodeItems[1].obligationExpirationDate"},
    "Obligated" => {:section => "Award Hierarchy", :label => "awardHierarchyNodeItems[1].amountObligatedToDate"},
    "Anticipated" => {:section => "Award Hierarchy", :label => "awardHierarchyNodeItems[1].anticipatedTotalAmount"},
    "Project End" => {:section => "Award Hierarchy", :label => "awardHierarchyNodeItems[1].finalExpirationDate"}
  }

  if special_case_field.key?(label)
    special_case_field.each do |key, value|
      if key.eql?(label)
        label = value[:label] if @section.eql?(value[:section])
      end
    end
  end

  verify_text(label, text, subsection, person)
end

# Description: This step verifies the given text is present on the page and verifies
#              the value in the text field is correct, using a fuzzy match.
#
# Parameters:
#   label      - Optional matcher for given text.
#   text       - Text to be verified.
#   subsection - OPTIONAL - Area of the page the text should be located in.
#   person     - OPTIONAL - A subsection that is a person's name under which the field appears.
#
# Example:
#	  Then I should see "Award ID" set to something like "-00001"
#
# Returns nothing.
Then (/^I should see "([^"]*)" set to something like "([^"]*)"(?:| (?:under|in) the "([^"]*)" subsection)(?:| for "([^"]*)")$/)\
  do |label, text, subsection, person|

  kaiki.get_ready
  verify_text(label, text, subsection, person, 'fuzzy')
end

# Public: This method receives the parameters provided by step definitions to
#         verify text is on the page, using a fuzzy or exact match.
#
# Parameters:
#   label      - Optional matcher for given text.
#   text       - Text to be verified.
#   subsection - Area of the page the text should be located in.
#   person     - A subsection that is a person's name under which the field appears.
#   mode       - The valid modes are 'exact' (default) or 'fuzzy'.
#
# Returns nothing.
def verify_text(label, text, subsection, person, mode='exact')

  case @tab
  when "Route Log"
    kaiki.select_frame("routeLogIFrame")
    factory0 =
      ApproximationsFactory.transpose_build(
      "//%s[contains(., '#{label}')]/following-sibling::td[1]",
      ['th'])
      approximate_xpath = factory0
      @field_text = kaiki.get_approximate_field(approximate_xpath)
  else
    if person
# factory0 - KC Feat. 2 (Contacts)
      factory0 =
      ApproximationsFactory.transpose_build(
      "//h2[contains(., '#{@tab}')]/../../../../following-sibling::div/"       \
        "descendant::h3[contains(., '#{@section}')]/following-sibling::div/"   \
        "descendant::div[contains(., '#{person}')]/../../following-sibling::tr/"\
        "descendant::div[contains(., '#{subsection}')]/following-sibling::div/"\
        "descendant::div[contains(., '#{label}')]/../following-sibling::td/"   \
        "%s[contains(@title, '#{label}')]",
        ['textarea'],
        ['input'],
        ['select'])
# factory1 - KC Feat. 2 (Contacts)
      factory1 =
      ApproximationsFactory.transpose_build(
      "//h2[contains(., '#{@tab}')]/../../../../following-sibling::div/"       \
        "descendant::h3[contains(., '#{@section}')]/following-sibling::div/"   \
        "descendant::div[contains(., '#{person}')]/../../following-sibling::tr/"\
        "descendant::div[contains(., '#{subsection}')]/following-sibling::div/"\
        "descendant::div[contains(., '#{label}')]/../../following-sibling::tr/"\
        "descendant::%s",
        ["div[text()[contains(., '#{text}')]]"])
      approximate_xpath = factory0                                             \
                        + factory1
      @field_text = kaiki.get_approximate_field(approximate_xpath)
    elsif subsection
# factory0 - KC Feat. 2 (Award, Contacts)
# factory0 - KC Feat. 4 (Award)
# factory0 - KC Feat. 6 (Non-Personnel)
        factory0 =
          ApproximationsFactory.transpose_build(
            "//h2[contains(., '#{@tab}')]/../../../../following-sibling::div/" \
            "descendant::h3[contains(., '#{@section}')]/following-sibling::"   \
            "%sdiv[contains(., '#{subsection}')]/following-sibling::div/"      \
            "descendant::%s[contains(@title, '#{label}')]",
            ['table/descendant::', 'textarea'],
            [ '',                  'select'],
            [ nil,                 'input'])
# factory2 - KC Feat. 7 (Grants.gov)
        factory1 =
          ApproximationsFactory.transpose_build(
            "//h2[contains(., '#{@tab}')]/../../../../following-sibling::div/" \
              "descendant::h3[contains(., '#{@section}')]/following-sibling::" \
              "div/descendant::div[contains(., '#{subsection}')]/"              \
              "following-sibling::div/descendant::div[text()[contains(., '#{label}')]]"\
              "/../following-sibling::%s",
              ['td/select'],
              ['td/a'],
              ['td/input'])
# factory2 - KFS COA002-01 (Initiate New Object Code)
      factory2 =
        ApproximationsFactory.transpose_build(
        "//h2[contains(., '#{@tab}')]/../../../../following-sibling::div/"     \
        "descendant::tr[contains(., '#{subsection}')]/following-sibling::"     \
        "tr/th/label[contains(text(), '#{label}')]/../following-sibling::td/%s",
        ['textarea'],
        ['select'],
        ['input'])
        approximate_xpath = factory0                                           \
                          + factory1                                           \
                          + factory2
        @field_text = kaiki.get_approximate_field(approximate_xpath)
    else
# factory0 - KFS PA004-02   (Assign CM)
# factory0 - KFS PA004-0304 (Purchase Order)
# factory0 - KFS PA004-06   (Vendor Credit Memo)
# factory0 - CASH001-01     (Cash Drawer)
# factory0 - DV001-01       (Check ACH)
# factory0 - KC  Feat. 2    (Award, Time & Money, Commitments, Custom Data)
# factory0 - KC  Feat. 3    (Proposal)
# factory0 - KC  Feat. 4    (Proposal, Commitments)
# factory0 - KC  Feat. 6    (Proposal)
# factory0 - KC  Feat. 7    (Proposal)
# factory0 - KC  Feat. 8    (Proposal)
# factory0 - KC  Feat. 13   (Institutional Proposal Actions)
      factory0 =
        ApproximationsFactory.transpose_build(
          "//h2[contains(., '#{@tab}')]/../../../../following-sibling::div/"   \
          "descendant::h3[contains(., '#{@section}')]/following-sibling::"     \
          "table/descendant::%s[contains(@title, '#{label}')]",
          ['textarea'],
          ['input'],
          ['select'])
# factory1 - KC Feat. 2 (Time & Money)
# factory1 - CASH001-01 (Cash Drawer)
      factory1 =
        ApproximationsFactory.transpose_build(
          "//h2[contains(., '#{@tab}')]/../../../../following-sibling::div/"   \
          "descendant::h3[contains(., '#{@section}')]/following-sibling::"     \
          "div/descendant::%s[contains(%s, '#{label}')]",
          ['input', '@name'],
          [ nil,    '@title'])
# factory2- KC Feat. 8 (Custom Data)
      factory2 =
        ApproximationsFactory.transpose_build(
          "//h2[contains(., '#{@tab}')]/../../../../following-sibling::div/"   \
          "descendant::h3[contains(., '#{@section}')]/following-sibling::"     \
          "table/descendant::%s/following-sibling::%s",
          ["th[contains(text(), '#{label}')]",    "td/input"],
          [ nil,                                  "td"],
          [ nil,                                  "td/div"])
      approximate_xpath = factory0                                             \
                        + factory1                                             \
                        + factory2
      @field_text = kaiki.get_approximate_field(approximate_xpath)
    end
  end

  if mode == 'exact'
    unless @field_text == text
      raise Capybara::ExpectationNotMet
    end
  elsif mode == 'fuzzy'
    unless @field_text.include?(text)
      raise Capybara::ExpectationNotMet
    end
  else
    raise Capybara::InvalidModeInVerifyText
  end
end

# Description: This step definition is to verify text in a certain area of the
#              browser page actually shows up there.
#
# Parameters:
#   label          - Label of the field the shows up in.
#   something_like - OPTIONAL - Conditional matcher for 'fuzzy' or 'exact' text matching.
#   text           - Text to be verified on the page.
#   subsection     - OPTIONAL - Area of the page the text should be located in.
#
# Example:
#	  And I should see "Status" text set to "FINAL"
#
# Returns nothing.
Then (/^I should see (?:|the )"([^"]*)" text set to (?:|([^"]*) )"([^"]*)"(?:| (?:under|in) the "([^"]*)" subsection)$/)\
  do |label, something_like, text, subsection|

  kaiki.get_ready

  special_case = Hash[
    "the recorded document number" => kaiki.record[:document_number],
    "the recorded requisition number" => kaiki.record[:requisition_number],
    "the recorded purchase order number" => kaiki.record[:purchase_order_number],
    "Today's Date" => kaiki.record[:today],
    "Check Amount" => kaiki.record[:check_amount]
    ]

  if special_case.key?(text)
    special_case.each do |key, value|
      text = value if key == text
    end
  end

  case @tab
  when "Route Log"
    kaiki.select_frame("routeLogIFrame")
# factory0 - KFS PA004-02 (Assign CM)
# factory0 - KFS CASH001-01 (Open Cash Drawer)
    factory0 =
      ApproximationsFactory.transpose_build(
      "//%s[contains(., '#{label}')]/following-sibling::td[1]",
      ['th'])
    approximate_xpath = factory0
    @field_text = kaiki.get_approximate_field(approximate_xpath)
  when "1099 Classification"
# factory0 - KFS PA004-05 (Payment Request)
# factory0 - KFS PA004-06 (Vendor Credit Memo)
# factory0 - KFS DV001-01 (Check ACH)
    factory0 =
      ApproximationsFactory.transpose_build(
        "//h2[contains(., '#{@tab}')]/../../../../following-sibling::div/"     \
          "descendant::%s[contains(text(), '#{label}')]",
        ["td"])
    approximate_xpath = factory0
    @field_text = kaiki.get_approximate_field(approximate_xpath)
  when "Future Action Requests"
    kaiki.select_frame("routeLogIFrame")
# factory0 - KFS PRE001-01 (Initiate Pre-Encumbrance)
# factory0 - KFS TF001-01  (Initiate Transfer of Funds)
    factory0 =
      ApproximationsFactory.transpose_build(
        "//h2[contains(., '#{@tab}')]/../../../../following-sibling::div/"     \
          "descendant::tr/%s/../following-sibling::"                           \
          "tr/%s[text()[contains(., '#{text}')]]",
        ["th[3 and text()[contains(., '#{label}')]]", "td[3]/a"])
    approximate_xpath = factory0
    @field_text = kaiki.get_approximate_field(approximate_xpath)
  else
    if subsection
# factory0 - KC Feat. 2 (Award)
# factory0 - KC Feat. 3 (Medusa)
# factory0 - KC Feat. 4 (Award, Time and Money)
      factory0 =
        ApproximationsFactory.transpose_build(
          "//h2[contains(., '#{@tab}')]/../../../../following-sibling::div/"   \
            "descendant::span[contains(., '#{@section}')]/../following-sibling::"\
            "div[contains(., '#{subsection}')]/following-sibling::div/"        \
            "descendant::%s/following-sibling::%s",
          ["div[text()[contains(., '#{label}')]]/..",   "td/div"],
          ["th[contains(text(), '#{label}')]",          "td"],
          [nil,                                         "th/div"])
# factory1 - KC Feat. 6 (Non-Personnel)
# factory1 - KC Feat. 7 (Grants.gov)
      factory1 =
        ApproximationsFactory.transpose_build(
          "//h2[contains(., '#{@tab}')]/../../../../following-sibling::div/"   \
          "descendant::span[contains(., '#{@section}')]/../following-sibling::"\
          "%s/descendant::div[contains(., '#{subsection}')]/"                  \
          "following-sibling::div/descendant::div[text()[contains(., '#{label}')]]"\
          "/../following-sibling::%s",
          ['div',   'td'],
          ['table', 'td/div'])
# factory2 - KC Feat. 3 (Medusa)
      factory2 =
        ApproximationsFactory.transpose_build(
          "//h2[contains(., '#{@tab}')]/../../../../following-sibling::div/"   \
          "descendant::h3[contains(., '#{@section}')]/following-sibling::"     \
          "div[contains(., '#{subsection}')]/descendant::"                     \
          "th[contains(text(), '#{label}')]/following-sibling::%s",
          ['td'])
# factory3 - KFS PVEN02 (Foreign PO Vendor)
      field_element = vendor_page_field_location(label, subsection)
      factory3 = [
        "//h2[contains(., '#{@tab}')]/../../../../following-sibling::div/"     \
        "descendant::tr[contains(., '#{subsection}')]/following-sibling::"     \
        "tr/#{field_element}"]
      approximate_xpath = factory0                                             \
                        + factory1                                             \
                        + factory2                                             \
                        + factory3
      @field_text = kaiki.get_approximate_field(approximate_xpath)
    else
      case @sec_type
      when "h3"
# factory0 - KFS PA004-0304 (Purchase Order)
# factory0 - KFS PA004-05   (Payment Request)
# factory0 - KC  Feat. 1    (Proposal, Key Personnel)
# factory0 - KC  Feat. 2    (Award)
# factory0 - KC  Feat. 3    (Proposal, Key Personnel)
# factory0 - KC  Feat. 6    (Proposal)
# factory0 - KC  Feat. 7    (Proposal)
# factory0 - KC  Feat. 13   (Institutional Proposal)
        factory0 =
        ApproximationsFactory.transpose_build(
          "//h2[contains(., '#{@tab}')]/../../../../following-sibling::div/"   \
            "descendant::h3[contains(., '#{@section}')]/"                      \
            "following-sibling::table/descendant::%s/following-sibling::%s",
          ["div[text()[contains(., '#{label}')]]/..",   "td/div"],
          ["th[contains(text(), '#{label}')]",          "td"],
          [ nil,                                        "th/div"])
        approximate_xpath = factory0
        @field_text = kaiki.get_approximate_field(approximate_xpath)
      when "td"
# factory0 - KFS PA004-0304 (Purchase Order)
# factory0 - KFS PA004-05   (Payment Request)
# factory0 - KFS PA004-06   (Vendor Credit Memo)
        factory0 =
        ApproximationsFactory.transpose_build(
          "//h2[contains(., '#{@tab}')]/../../../../following-sibling::div/"   \
            "descendant::tr[contains(., '#{@section}')]/"                      \
            "following-sibling::tr/descendant::%s/following-sibling::%s",
          ["div[text()[contains(., '#{label}')]]/..",   "td/div"],
          ["th[contains(text(), '#{label}')]",          "td"],
          [ nil,                                        "th/div"])
        approximate_xpath = factory0
        @field_text = kaiki.get_approximate_field(approximate_xpath)
      end
    end
  end

  if @tab == "1099 Classification"
    @field_text = @field_text[/\d+[.]\d+/]
    raise Capybara::ExpectationNotMet unless @field_text == kaiki.record[@amount_label]
  else
    if something_like
      raise Capybara::ExpectationNotMet unless @field_text.include?(text)
    else
      raise Capybara::ExpectationNotMet unless @field_text.eql?(text)
    end
  end
end

# Description: This step verifies the given values from the table are present on
#              the web page in the correct text fields
#
# Parameters:
#   table_name  - Name of the table to be filled in.
#   table       - Table of data being read in from the feature file.
#
# Example:
# 	And I should see the "Current Items" table filled out with:
#	  | Item # |  Item Type        | Quantity | Unit Of Measure Code | Catalog # | Description       | Unit Cost |
#   | Item 1 |  QUANTITY TAXABLE | 10.00    | EA                   | 123-ABC   | Bunny Slippers    | 6.00      |
#   | Item 2 |  QUANTITY TAXABLE | 10.00    | BX                   | 333-FRG   | Frog Hats         | 5.50      |
#
# Returns nothing.
Then (/^I should see the "([^"]*)" table filled out with:$/)                   \
  do |table_name, table|

  kaiki.get_ready
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
      option4 = "div[text()[contains(.,'#{value}')]]"
      option5 = "input[@title='#{column_name} - #{value}']"
      case kaiki.application
      when "kfs"
# factory0 - KFS PA004-0304 (Purchase Order)
        factory0 =
          ApproximationsFactory.transpose_build(
            "//h2[contains(., '#{@tab}')]/../../../../following-sibling::"     \
            "div/descendant::span[contains(., '#{@section}')]"                 \
            "/../../following-sibling::tr[contains(., '#{row_name}')]"         \
            "/following-sibling::tr/descendant::%s",
            [option3],
            [option1],
            [option2])
# factory1 - KFS PA004-05 (Payment Request)
        factory1 =
          ApproximationsFactory.transpose_build(
            "//h2[contains(., '#{@tab}')]/../../../../following-sibling::"     \
            "div/descendant::span[contains(., '#{@section}')]/../../../../"    \
            "descendant::tr/td/b[contains(., '#{row_name}')]/../"              \
            "following-sibling::td/descendant::%s",
            [option3],
            [option1],
            [option2])
        approximate_xpath = factory0                                           \
                          + factory1
        @field_text = kaiki.get_approximate_field(approximate_xpath)
      when "kc"
# factory0 - KC Feat. 1 (Budget Versions Parameters)
# factory0 - KC Feat. 2 (Time & Money, Special Review, Commitments)
# factory0 - KC Feat. 6 (Budget Versions Parameters)
# factory0 - KC Feat. 7 (Budget Versions Parameters)
# factory0 - KC Feat. 8 (Questions)
        factory0 =
          ApproximationsFactory.transpose_build(
            "//h2[contains(., '#{@tab}')]/../../../../following-sibling::"     \
            "div/descendant::h3[contains(., '#{table_name}')]/following-sibling::"\
            "table/descendant::th[contains(text(), '#{row_name}')]/"           \
            "following-sibling::td/descendant::%s",
            [option5],
            [option1],
            [option2],
            [option3],
            [option4])
# factory1 - KC Feat. 2 (Contacts)
# factory1 - KC Feat. 4 (Commitments)
# factory1 - KC Feat. 8 (Special Review, Budget Versions)
        factory1 =
          ApproximationsFactory.transpose_build(
            "//h2[contains(., '#{@tab}')]/../../../../following-sibling::"     \
            "div/descendant::h3[contains(., '#{@section}')]/following-sibling::"\
            "div[text()[contains(., '#{table_name}')]]/following-sibling::"    \
            "div/descendant::th[contains(text(), '#{row_name}')]/"             \
            "following-sibling::td/descendant::%s",
            [option4],
            [option2],
            [option1],
            [option3])
        approximate_xpath = factory0                                           \
                          + factory1
        @field_text = kaiki.get_approximate_field(approximate_xpath)
      end

      begin
        raise Capybara::ExpectationNotMet unless @field_text.eql?(value)
      rescue Capybara::ExpectationNotMet
        raise Capybara::ExpectationNotMet unless @field_text.eql?("true")
      end
    end
  end
end

# KC Feat. 6 (Non-Personnel)

# Description: This step may need another ApproximationsFactory segment added
#              but as is, it will fill in an input/select/textarea field in a table
#              given the name of the table.
#
# Parameters:
#   table_name - Name of the table.
#   row_number - Row of the table to be verified.
#   table      - The data to be used.
#
# Example:
#	 Then I should see the "Travel" table row "1" filled with:
#	  | Object Code Name           | Object Code Name | Description | Quantity | Total Base Cost |
#	  | Travel - Out of State      | 6240             | conference  |          | 5,000.00        |
#
# Returns nothing.
Then (/^I should see the "([^"]*)" table row "([^"]*)" filled with:$/)         \
  do |table_name, row_number, table|

  kaiki.get_ready
  kaiki.should(have_content(table_name))
  data_table = table.raw
  rows = data_table.length-1
  cols = data_table[0].length-1
  (1..rows).each do |data_row_counter|
    (0..cols).each do |data_column_counter|
      column_name = data_table[0][data_column_counter]
      value = data_table[data_row_counter][data_column_counter]
      if value != ""
        option1 = "/input[contains(@title, '#{column_name}')]"
        option2 = "/select[contains(@title, '#{column_name}')]"
        option3 = "/textarea[contains(@title, '#{column_name}')]"
        option4 = "[text()[contains(., '#{value}')]]"
        factory1 =
          ApproximationsFactory.transpose_build(
            "//h2[contains(., '#{@tab}')]/../../../../following-sibling::div/" \
            "descendant::h3[contains(., '#{table_name}')]/following-sibling::" \
            "table/descendant::th[contains(text(), '#{row_number}')]"          \
            "/following-sibling::td/div%s",
            [option3],
            [option1],
            [option2],
            [option4])
        approximate_xpath = factory1
        element = kaiki.find_approximate_element(approximate_xpath)
        if element[:type] == "text"
          @field_text = element[:value]
        elsif element[:type] == "select-one"
          begin
            @element_option = element.find(:xpath, "option[@selected ='selected']")
          rescue Capybara::ElementNotFound
            @element_option = element.find(:xpath, "option[@value='#{element[:value]}']")
          end
          @field_text = element_option.text
        else
          @field_text = element.text.strip
        end
         raise Capybara::ExpectationNotMet unless @field_text.eql?(value)
      end
    end
  end
end


# KC Feat. 2 (Contacts)
# KC Feat. 8 (Key Personnel)

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

  i = 0
  if @xpath != nil
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


# Description: This step verifies a row of data for the Combined Credit Split table contains
#              the correct value.
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
#
# Example:
#	  And I fill out the Combined Credit Split for "Linda L Garland" with the following:
#	    | Credit for Award | 20 |
#	    | F&A Revenue      | 20 |
#
# Returns nothing.
Then (/^I should see Combined Credit Split for "(.*?)"(?:| under "(.*?)") with the following:$/)\
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
          ["//td/strong[contains(text(),'#{division}')]"                       \
           "/../following-sibling::td[#{data_column}]"                         \
           "/div/strong/input"]
        field_text = kaiki.get_approximate_field(xpath)
        raise Capybara::ExpectationNotMet unless field_text.eql?(value)
      end
    end
  end
end

# Description: This step verifies the given values from the table are present on the web page
#              in the correct place
#
# Parameters:
#   table_name - Name of the table to be filled in.
#   table      - Table of data being read in from the feature file.
#
# Example:
# 	And I should see Total calculated as:
#	    |Direct Cost 			| $330,000.00 |
#     |F&A Cost   			| $170,000.00 |
#
# Returns nothing.
Then (/^I should see (.*?) calculated as:$/) do |table_name, table|
  kaiki.get_ready

  data_table = table.raw
  data_hash = Hash.new

  case table_name
# KC Feat. 2 (Time & Money)
  when "Total"
    #There are 2 columns on the page. For now this is the easiest way to run this loop.
    (0..1).each do |data_row_counter|
      header_value = kaiki.find(
        :xpath,
        "//h2[contains(., '#{@tab}')]/../../../../following-sibling::div/"     \
          "descendant::h3[contains(., '#{@section}')]/following-sibling::"     \
          "table/tbody/tr[1]/th[#{data_row_counter+4}]").text
      data_value = kaiki.find(
        :xpath,
        "//h2[contains(., '#{@tab}')]/../../../../following-sibling::div/"     \
          "descendant::h3[contains(., '#{@section}')]/following-sibling::"     \
          "table/descendant::tr[contains(., 'Total')]/"                        \
          "th[#{data_row_counter+2}]/div").text
      data_hash.store(header_value, data_value)
    end
    rows = data_table.length-1
    (0..rows).each do |data_row_counter|
      header_name = data_table[data_row_counter][0]
      value = data_table[data_row_counter][1]
      data_hash.each_key { |key| header_name = key if key.include?(header_name) }
      if data_hash[header_name].include?(value)
        kaiki.highlight(
          :xpath,
          "//h2[contains(., '#{@tab}')]/../../../../following-sibling::div/"   \
          "descendant::h3[contains(., '#{@section}')]/following-sibling::"     \
          "table/descendant::tr[contains(., 'Total')]/"                        \
          "th/div[contains(., '#{value}')]")
      else
        raise Capybara::ExpectationNotMet
      end
    end
# KC Feat. 7 (Budget Versions Parameters)
# KC Feat. 8 (Budget Versions Parameters)
  when "Totals"
    # There are 11 columns on the page. For now this is the easiest way to run this loop.
    (0..10).each do |data_row_counter|
      header_value = kaiki.find(
        :xpath,
        "//h2[contains(., '#{@tab}')]/../../../../following-sibling::div/"     \
          "descendant::h3[contains(., '#{@section}')]/following-sibling::"     \
          "table/tbody/tr[1]/th[#{data_row_counter+1}]/div").text.strip
      data_value = kaiki.find(
        :xpath,
        "//h2[contains(., '#{@tab}')]/../../../../following-sibling::div/"     \
          "descendant::h3[contains(., '#{@section}')]/following-sibling::"     \
          "table/descendant::tr[contains(., 'Totals')]/following-sibling::"    \
          "tr[1]/td[#{data_row_counter+1}]/div").text.strip
      data_hash.store(header_value, data_value)
    end
    rows = data_table.length-1
    (0..rows).each do |data_row_counter|
      header_name = data_table[data_row_counter][0]
      value = data_table[data_row_counter][1]
      if data_hash[header_name].include?(value)
        kaiki.highlight(
          :xpath,
          "//h2[contains(., '#{@tab}')]/../../../../following-sibling::div/"   \
            "descendant::h3[contains(., '#{@section}')]/following-sibling::"   \
            "table/descendant::tr[contains(., 'Totals')]/following-sibling::"  \
            "tr[1]/td[#{data_row_counter+2}]/div[contains(., '#{value}')]")
      else
        raise Capybara::ExpectationNotMet
      end
    end
  end
end

# KC Feat. 2 (Award)

# Description: This step is specific to the Current Funding Proposals section on the
#              Award tab when creating a new award. To guarantee the values show up
#              under the specified headers, this is the best way we can achieve this.
#              All the data is pulled from the page section, and then our table
#              data is verified against it.
#
# Parameters:
#   table - Table of headers and values that should appear in the sections.
#
# Example:
#	  Then I should see the Current Funding Proposals table filled out with:
#    	  | Award Version          | 1                          |
#    	  | Principal Investigator | Linda L Garland            |
#
# Returns nothing.
Then (/^I should see the Current Funding Proposals table filled out with:$/)   \
  do |table|

  kaiki.get_ready

  data_table = table.raw
  data_hash = Hash.new

  #There are 9 columns on the page. For now this is the easiest way to run this loop.
  (0..8).each do |data_row_counter|
    header_value = kaiki.find(
      :xpath,
      "//h2[contains(., '#{@tab}')]/../../../../following-sibling::div/"       \
        "descendant::h3[contains(., '#{@section}')]/following-sibling::table/" \
        "tbody/tr[1]/th[#{data_row_counter+1}]/div").text.strip
    data_value = kaiki.find(
      :xpath,
      "//h2[contains(., '#{@tab}')]/../../../../following-sibling::div/"       \
        "descendant::h3[contains(., '#{@section}')]/following-sibling::table/" \
        "tbody/tr[2]/td[#{data_row_counter+1}]").text.strip
    data_hash.store(header_value, data_value)
  end
  rows = data_table.length-1
  (0..rows).each do |data_row_counter|
    header_name = data_table[data_row_counter][0]
    value = data_table[data_row_counter][1]
    if data_hash[header_name].include?(value)
      kaiki.highlight(
          :xpath,
          "//h2[contains(., '#{@tab}')]/../../../../following-sibling::div/"   \
          "descendant::h3[contains(., '#{@section}')]/following-sibling::table/"\
          "descendant::td[contains(., '#{value}')]")
    else
      raise Capybara::ExpectationNotMet
    end
  end
end

# KC Feat. 2 (Contacts)

# Description: This step is specific to the Sponsor Contacts section on the
#              Sponsor Contacts tab when creating a new award. To guarantee
#              the values show up under the specified headers, this is the
#              best way we can achieve this. All the data is pulled from the
#              page section, and then our table data is verified against it.
#
# Parameters:
#   table - Table of headers and values that should appear in the sections.
#
# Example:
#	  Then I should see the Sponsor Contacts table filled out with:
#    	  | Person or Organization | Last Name TBD, First Name TBD Middle Name TBD |
#    	  | Project Role           | Other                                         |
#
# Returns nothing.
Then (/^I should see the Sponsor Contacts table filled out with:$/) do |table|
  kaiki.get_ready

  data_table = table.raw
  data_hash = Hash.new

  #There are 5 columns on the page. For now this is the easiest way to run this loop.
  (0..4).each do |data_row_counter|
    header_value = kaiki.find(
      :xpath,
      "//h2[contains(., '#{@tab}')]/../../../../following-sibling::div/"       \
      "descendant::h3[contains(., '#{@section}')]/following-sibling::table/"   \
      "tbody/tr[1]/th[#{data_row_counter+2}]").text.strip
    factory0 =
      ApproximationsFactory.transpose_build(
        "//h2[contains(., '#{@tab}')]/../../../../following-sibling::div/"     \
        "descendant::h3[contains(., '#{@section}')]/following-sibling::table/" \
        "tbody/tr[3]/td[#{data_row_counter+1}]/%s",
        ['div/select'],
        ['div'],
        ['div/input'])

    data_element = kaiki.find_approximate_element(factory0)

    if data_element[:type] == "select-one"
      begin
        @element_option = data_element.find(:xpath, "option[@selected ='selected']")
      rescue Capybara::ElementNotFound
        @element_option = data_element.find(:xpath, "option[@value='#{data_element[:value]}']")
      end
      @data_value = @element_option.text
    elsif data_element[:type] == "text"
      @data_value = data_element[:value]
    else
      @data_value = data_element.text.strip
    end
    data_hash.store(header_value, @data_value)
  end
  rows = data_table.length-1
  (0..rows).each do |data_row_counter|
    header_name = data_table[data_row_counter][0]
    value = data_table[data_row_counter][1]
    data_hash.each_key { |key| header_name = key if key.include?(header_name) }

    if data_hash[header_name].include?(value)
      kaiki.highlight(
        :xpath,
        "//h2[contains(., '#{@tab}')]/../../../../following-sibling::div/"     \
        "descendant::h3[contains(., '#{@section}')]/following-sibling::table/" \
        "descendant::tr[3]/td[contains(., '#{value}')]")
    else
      raise Capybara::ExpectationNotMet
    end
  end
end

# KC Feat. 8 (Budget Versions Parameters)

# Description: This step is specific to the Budget Versions table, to guarantee the
#	             values show up under the specified headers, this is the best way we
#	             can achieve this. All the data is pulled from the page section, and
#              then our table data is verified against it.
#
# Parameters:
#   table - Table of headers and values that should appear in the sections.
#
# Example:
#  	Then I should see the Budget Versions table filled out with:
#      	  | Name          | Final Budget |
#      	  | Version #     | 1            |
#
# Returns nothing.
Then (/^I should see the Budget Versions table filled out with:$/) do |table|

  kaiki.get_ready

  data_table = table.raw
  data_hash = Hash.new

  #There are 8 columns on the page we want to verify. For now this is the easiest way to run this loop.
  (0..7).each do |data_row_counter|
    header_value = kaiki.find(
      :xpath,
      "//h2[contains(., '#{@tab}')]/../../../../following-sibling::div/"       \
        "descendant::h3[contains(., '#{@section}')]/following-sibling::table/" \
        "thead/tr[1]/th[#{data_row_counter+1}]").text.strip
    factory0 =
      ApproximationsFactory.transpose_build(
        "//h2[contains(., '#{@tab}')]/../../../../following-sibling::div/"     \
        "descendant::h3[contains(., '#{@section}')]/following-sibling::table/" \
        "tbody/tr[1]/td[#{data_row_counter+1}]%s",
        ['/div/select'],
        ['/div/input'],
        ['/div'],
        [''])
    data_element = kaiki.find_approximate_element(factory0)
    if data_element[:type] == "select-one"
      begin
        @element_option = data_element.find(:xpath, "option[@selected ='selected']")
      rescue Capybara::ElementNotFound
        @element_option = data_element.find(:xpath, "option[@value='#{data_element[:value]}']")
      end
      @data_value = @element_option.text
    elsif data_element[:type] == "text"
      @data_value = data_element[:value]
    elsif data_element[:type] == "checkbox"
      @data_value = data_element[:checked]
      if @data_value == nil
        @data_value = "unchecked"
      else
        @data_value = "checked"
      end
    else
      @data_value = data_element.text.strip
    end
    data_hash.store(header_value, data_value)
  end
  rows = data_table.length-1
  (0..rows).each do |data_row_counter|
    header_name = data_table[data_row_counter][0]
    value = data_table[data_row_counter][1]
    data_hash.each_key { |key| header_name = key if key.include?(header_name) }
    if data_hash[header_name].include?(value)
      kaiki.highlight(
        :xpath,
        "//h2[contains(., '#{@tab}')]/../../../../following-sibling::div/"     \
        "descendant::h3[contains(., '#{@section}')]/following-sibling::table/" \
        "descendant::tr[1]/td[contains(., '#{value}')]")
    else
      raise Capybara::ExpectationNotMet
    end
  end
end

# KFS CASH001-01 (Open Cash Drawer)

# Description: This method is specific to the Final Deposit section on the
#	             Deposits tab. To guarantee the values show up under the specified
#	             headers, this is the best way we can achieve this.
#	             All the data is pulled from the page section, and then our table
#	             data is verified against it.
#
# Parameters:
#   table - Table of headers and values that should appear in the sections.
#
# Example:
#    	And I should see the Final Deposit table filled out with:
#      	  | Amt | 100.00 |
#
# Returns nothing.
Then (/^I should see the Final Deposit table filled out with:$/) do |table|
  kaiki.pause
  kaiki.switch_default_content
  begin
    kaiki.select_frame("iframeportlet")
  rescue Selenium::WebDriver::Error::NoSuchFrameError
  end

  data_table = table.raw
  data_hash = Hash.new

  #There are 5 columns on the page. For now this is the easiest way to run this loop.
  (0..4).each do |data_row_counter|
    header_value = kaiki.find(
      :xpath,
      "//h2[contains(., '#{@tab}')]/../../../../following-sibling::div/"       \
      "descendant::h3[contains(., '#{@section}')]/following-sibling::table/"   \
      "descendant::table/tbody/tr[1]/th[#{data_row_counter+1}]").text.strip
    factory0 =
      ApproximationsFactory.transpose_build(
        "//h2[contains(., '#{@tab}')]/../../../../following-sibling::div/"     \
        "descendant::h3[contains(., '#{@section}')]/following-sibling::table/" \
        "descendant::table/tbody/tr[2]/td[#{data_row_counter+1}]%s",
        ['/input'],
        [''])
    data_element = kaiki.get_approximate_field(factory0)
    data_hash.store(header_value, data_element)
  end
  rows = data_table.length-1
  (0..rows).each do |data_row_counter|
    header_name = data_table[data_row_counter][0]
    value = data_table[data_row_counter][1]
    data_hash.each_key { |key| header_name = key if key.include?(header_name) }

    if data_hash[header_name].include?(value)
      kaiki.highlight(
        :xpath,
        "//h2[contains(., '#{@tab}')]/../../../../following-sibling::div/"     \
        "descendant::h3[contains(., '#{@section}')]/following-sibling::table/" \
        "descendant::table/descendant::tr[2]/td[contains(., '#{value}')]")
    else
      raise Capybara::ExpectationNotMet
    end
  end
end

# KFS CASH001-01 (Open Cash Drawer)

# Description: This step is specific to the Cash Receipts section on the
#	             Deposits tab. To guarantee the values show up under the specified
#	             headers, this is the best way we can achieve this.
#	             All the data is pulled from the page section, and then our table
#	             data is verified against it.
#
# Parameters:
#   table - Table of headers and values that should appear in the sections.
#
# Example:
#    	And I should see the Cash Receipts table filled out with:
#      	  | Total Check Amount | 100.00 |
#
# Returns nothing.
Then (/^I should see the Cash Receipts table filled out with:$/) do |table|
  kaiki.pause
  kaiki.switch_default_content
  begin
    kaiki.select_frame("iframeportlet")
  rescue Selenium::WebDriver::Error::NoSuchFrameError
  end

  data_table = table.raw
  data_hash = Hash.new

  #There are 4 columns on the page. For now this is the easiest way to run this loop.
  (0..3).each do |data_row_counter|
    header_value = kaiki.find(
      :xpath,
      "//h2[contains(., '#{@tab}')]/../../../../following-sibling::div/"       \
      "descendant::h3[contains(., '#{@section}')]/following-sibling::table/"   \
      "tbody/tr[5]/th[#{data_row_counter+1}]").text.strip
    factory0 =
      ApproximationsFactory.transpose_build(
        "//h2[contains(., '#{@tab}')]/../../../../following-sibling::div/"     \
        "descendant::h3[contains(., '#{@section}')]/following-sibling::table/" \
        "tbody/tr[6]/td[#{data_row_counter+1}]%s",
        ['/a'],
        [''])
    data_element = kaiki.get_approximate_field(factory0)
    data_hash.store(header_value, data_element)
  end
  rows = data_table.length-1
  (0..rows).each do |data_row_counter|
    header_name = data_table[data_row_counter][0]
    value = data_table[data_row_counter][1]
    data_hash.each_key { |key| header_name = key if key.include?(header_name) }

    if data_hash[header_name].include?(value)
      kaiki.highlight(
        :xpath,
        "//h2[contains(., '#{@tab}')]/../../../../following-sibling::div/"     \
        "descendant::h3[contains(., '#{@section}')]/following-sibling::table/" \
        "descendant::tr[6]/td[contains(., '#{value}')]")
    else
      raise Capybara::ExpectationNotMet
    end
  end
end

# Description: This step dynamically waits for the test to pass through the
#              processing page by polling the page to see if certain content still appears
#
# Example:
#	  When I wait for the document to finish being processed
#
# Returns nothing.
When (/^I wait for the document to finish being processed$/) do
  if @element[:title] == "submit" || @element[:title] == "Blanket Approve"
    @xpath = "//input[@title = '#{@element[:title]}'"
  elsif @element[:name] == "methodToCall.processAnswer.button1"
    @xpath = "//input[@name = '#{@element[:name]}'"
  end

  i = 0
  if @xpath != nil
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

# KC Feat. 1, 3, 6, 7, 8, 10

# Description: This step verifies that the Institutional Proposal has been generated
#
# Parameters:
#	  text1 - First value being checked for i e, "Institutional Proposal".
#	  text2 - Second value being checked for ie, "has been generated".
#
# Example:
#	  Then I should see a message starting with "Institutional Proposal" and ending with "has been generated"
#
# Returns nothing.
Then (/^I should see a message starting with "([^"]*)" and ending with "([^"]*)"$/)\
  do |text1, text2|

  kaiki.get_ready
  kaiki.wait_for(:xpath, "//div[@class='left-errmsg']")
  kaiki.should(have_content(text1))
  kaiki.should(have_content(text2))
end

# KC Feat. 7 (Custom Data)

# Description: Verifies that no messages appear at the top of the screen,
#	             because if one does appear, something has gone wrong.
#
# Example:
#	  Then I should not see a message at the top of the screen
#
# Returns nothing.
Then (/^I should not see a message at the top of the screen$/) do
  kaiki.get_ready
  kaiki.wait_for(:xpath, "//div[@class='left-errmsg']")
  element = kaiki.find(:xpath, "//div[@class='left-errmsg']")
  raise Capybara::ExpectationNotMet unless element.text.eql?("")
end

# KC Feat. 7

# Description: This step checks to see if a unit administrator has been set up
#              for a specific unit.
#
# Example:
#	  Given unit administrator has been established
#
# Returns nothing.
Given (/^unit administrator has been established$/) do
  # Here are the steps that need to occur to check that a unit administrator
  # has been set up. (Check if it is there)
  steps %{
    Given I am backdoored as "sandovar"
      And I am on the "Maintenance" system tab
    When I click the "Unit Administrator" link
      And I set "Unit Number" to "0721" on the search page
      And I click the "Search" button
    Then I should see a description of "Grants.Gov Proposal Contact"
  }
end

# KC Feat. 7

# Description: If no unit administrator has been set up, these are the steps
#              used to set up the unit administrator.
#
# Parameters:
#   description - Holds the description of the unit administrator.
#
# Example:
#	  Then I should see a description of "Grants.Gov Proposal Contact"
#
# Returns nothing.
Then (/^I should see a description of "(.*?)"$/) do |description|
   begin
     kaiki.find(:xpath, "//td/a[contains(text(), '#{description}')]")
   rescue Selenium::WebDriver::Error::NoSuchElementError,
          Selenium::WebDriver::Error::TimeOutError,
          Selenium::WebDriver::Error::InvalidSelectorError,
          Capybara::ElementNotFound
     # if no, Steps to create the unit administrator:
      steps %{
        When I do not see "Grants.gov Proposal Contact"
          And I click the "Create New" button
          And I am in the "Document Overview" tab
          And I set "Description" to "Grants.gov Proposal Contact - New"
          And I am in the "Edit UnitAdministrator" tab
          And I set "Unit Administrator Type Code" to "6" in the "New" subsection
          And I set "KC Person" to "sesham" in the "New" subsection
          And I set "Unit Number" to "0721" in the "New" subsection
          And I click the "Submit" button
        Then I should see the message "Document was successfully submitted."
      }
    end
end

# KC Feat. 7

# Description: This step verifies that the description for the unit administrator is
#              NOT present on the screen.
#
# Parameters:
#   description - Holds the description of the unit administrator.
#
# Example:
#	  When I do not see "Grants.gov Proposal Contact"
#
# Returns nothing.
When (/^I do not see "(.*?)"$/) do |description|
  kaiki.get_ready
  kaiki.should_not(have_content(description))
end


# KFS PA004-01 (Create Requisition)

# Description: This step verifies the text "No Accounts" doesn't show up under the
#	             Accounts Summary tab for KFS test PA004-01. If it does show up,
#	             the "refresh accounts summary" button needs to be clicked.
#
# Parameters:
#   message - Message that should not appear on the page.
#
# Example
#	  Then I should not see the message "No Accounts"
#
# Returns nothing.
Then (/^I should not see the message "(.*?)"$/) do |message|
  kaiki.within(:xpath, "//h2[contains(text(), '#{@tab}')]") do
    @tf = kaiki.should_not(have_content(message))
  end
  unless @tf
    steps %{
      And I click the "Refresh Account Summary" button
    }
  end
end

# KC Feat. 7 (Grants.gov)

# Description: This step verifies that the field is not blank.
#
# Parameters:
#   label - The name of the field to check.
#
# Example:
#	  Then I should see Received Date not null
#
# Returns nothing.
Then (/^I should see (.*?) not null$/) do |label|
  kaiki.get_ready
  element = kaiki.find(:xpath, "//div[text()[contains(., '#{label}')]]/../"    \
                               "following-sibling::td")
  raise Capybara::ExpectationNotMet if element.text.eql?("")
end

# Description: This step will verify the checkbox is checked or unchecked using
#	             location awareness.
#
# Parameters:
#   field - Name on the page for the checkbox.
#   value - Indicator of "checked" or "unchecked".
#   subsection - This is the subsection the field belongs to.
#
#   And I should see the "Active Indicator" checkbox is "checked" in the "Detail Information" subsection
#
# Returns nothing.
Then (/^I should see the "([^"]*)" checkbox is "([^"]*)"(?:| in the "([^"]*)" subsection)$/)\
  do |check_name, value, subsection|

  kaiki.get_ready
  if subsection
# factory0 - KFS COA002-01 (Initiate New Object Code)
    factory0 =
      ApproximationsFactory.transpose_build(
      "//h2[contains(., '#{@tab}')]/../../../../following-sibling::div/"       \
      "descendant::tr[contains(., '#{subsection}')]/following-sibling::"       \
      "tr/th/label[contains(text(), '#{check_name}')]/../following-sibling::td/%s",
      ['input'])
# factory1 KFS PVEN002 (Foreign PO Vendor)
    field_element = vendor_page_field_location(check_name, subsection)
    factory1 =
      ApproximationsFactory.transpose_build(
        "//h2[contains(., '#{@tab}')]/../../../../following-sibling::div/"     \
        "descendant::tr[contains(., '#{subsection}')]/%s",
        ["/following-sibling::tr/td/#{field_element}"                   ],
        ["/../../following-sibling::table/descendant::#{field_element}" ])
    approximate_xpath = factory0                                               \
                      + factory1
    @element = kaiki.find_approximate_element(approximate_xpath)
  else
# factory0 - KFS PA004-0304 (Purchase Order)
# factory0 - KFS PA004-05   (Payment Request)
# factory0 - KC  Feat. 8    (Proposal Actions)
    factory0 =
      ApproximationsFactory.transpose_build(
        "//h2[contains(., '#{@tab}')]/../../../../following-sibling::div/"     \
        "descendant::h3[contains(., '#{@section}')]/following-sibling::"       \
        "table/descendant::%s[contains(@title,'#{check_name}')]",
        ['input'])
    approximate_xpath = factory0
    @element = kaiki.find_approximate_element(approximate_xpath)
  end
  if value.downcase == "checked"
    value = "true"
  elsif value.downcase == "unchecked"
    value = nil
  end
  raise Capybara::ExpectationNotMet unless @element[:checked].eql?(value)
end

# KC Feat. 3 (Medusa)

# Description: This step performs an verification of links found within the page.
#
# Parameters:
#   link  - This is the value/link to be verified on the page.
#   stuff - OPTIONAL - Placeholder for extraneous text that may be after the link name.
#
# Example:
#	  And I should see the link for "Development Proposal"
#
# Returns nothing.
Then (/^I should see the link for "(.*?)"(.*?)$/) do |link, stuff|
  kaiki.get_ready
  element = kaiki.find_approximate_element(["//a[contains(text(), '#{link}')]"])
end

# KFS PA004-01   (Create Requisition)
# KFS PA004-0304 (Purchase Order)

# Description: This step verifies if the specified radio button is either selected or unselected.
#
# Parameters:
#   label      - Name for the radio button.
#   option     - Selected or unselected, or name of a specific button to be selected.
#   subsection - OPTIONAL - Area of the page the text should be located in.
#
# Example:
#   Then I should see "Shipping Address Presented to Vendor (use Receiving Address?)" radio button set to "Final Delivery Address"
#
# Returns nothing.
Then (/^I should see (?:|the )"([^"]*)" radio button set to "([^"]*)"(?:| (?:under|in) the "([^"]*)" subsection)$/)\
  do |label, option, subsection|

  kaiki.get_ready
  factory0 =
    ApproximationsFactory.transpose_build(
      "//h2[contains(., '#{@tab}')]/../../../../following-sibling::div/"       \
      "descendant::h3[contains(., '#{@section}')]/following-sibling::"         \
      "table/descendant::%s[contains(@title, '#{option}')]",
      ['input'])
  approximate_xpath = factory0
  element = kaiki.find_approximate_element(approximate_xpath)

  raise Capybara::ExpectationNotMet unless element[:checked].eql?("true")
end

# KFS PA004-02 (Assign CM)

# Description: This step verifies that the recorded requisition number appears within the table
#              on the page.
#
# Parameters:
#   value – The recorded requisition number.
#
# Example:
#	  And I should see a table row with a Requisition Number of "the recorded requisition number"
#
# Returns nothing.
Then (/^I should see a table row with a Requisition Number of "(.*?)"$/) do |value|
  kaiki.get_ready
  value = kaiki.record[:requisition_number] if value == "the recorded requisition number"
  element = kaiki.find_approximate_element(["//h2[contains(., '#{@tab}')]"     \
    "/../../../../following-sibling::div/descendant::h3[contains(., '#{@section}')]"\
    "/following-sibling::table/descendant::tr/td[2]/a[contains(text(), '#{value}')]"])
  raise Capybara::ExpectationNotMet unless element.text.eql?(value)
end

# Description: This step locates the identified text on the page and makes certain the
#	             field has no value.
#
# Parameters:
#   field       - This is the header that identifies the text on the page.
#   subsection  - This is the subsection the field belongs to.
#
# Example:
#	  Then I should see "Vendor #" text set to null in the "General Information" subsection
#
# Returns nothing.
Then (/^I should see "(.*?)" text set to null in the "(.*?)" subsection$/) do |field, subsection|
  kaiki.get_ready
  field_element = vendor_page_field_location(field, subsection)
  option1 = "../following-sibling::tr/#{field_element}"
# factory0 - KFS PVEN002-01 (Foreign PO Vendor)
  factory0 = [
    "//h2[contains(., '#{@tab}')]/../../../../following-sibling::div" \
      "/descendant::td[contains(., '#{subsection}')]/.."  \
      "/following-sibling::tr/#{field_element}"]
  approximate_xpath = factory0
  field_value = kaiki.get_approximate_field(approximate_xpath)
  raise Capybara::ExpectationNotMet if field_value != ""
end

# Description: This step will verify the values in the table provided match what
#	             is on the page.
#
# Parameters:
#   table_name – Name of the table to be filled out.
#   table – The data to be used.
#
# Example:
#	  Then I should see the "Notes and Attachments" table text filled with:
#	    | # | Posted Timestamp             |
#	    | 1 | <document created timestamp> |
#
# Returns nothing.
Then (/^I should see the "(.*?)" table text filled with:$/) do |table_name, table|
  kaiki.get_ready
  data_table = table.raw
  rows = data_table.length-1
  cols = data_table[0].length-1
  table_location     = "//h2[contains(., '#{@tab}')]/../../../../"    \
                         "following-sibling::div/"                    \
                         "descendant::h3[contains(., '#{@section}')]" \
                         "/following-sibling::table"
  page_table_element = kaiki.find_approximate_element([table_location])
  table_columns      = find_table_columns(table_location)

  header_row_location = table_location + "/descendant::tr[1]"
  page_header_row = get_page_table_headers(header_row_location, table_columns)

  (1..rows).each do |data_row_counter|
    (1..cols).each do |data_column_counter|
      row_name = data_table[data_row_counter][0]
      column_name = data_table[0][data_column_counter]
      value = data_table[data_row_counter][data_column_counter]
      if value == "<document created timestamp>"
        datetime = kaiki.record[:created]
        time = Time.strptime(datetime,"%H:%M %p %m/%d/%Y").strftime("%I:%M %p")
        date = Date.strptime(datetime,"%H:%M %p %m/%d/%Y").strftime("%m/%d/%Y")
        value = "#{date} #{time}"
      end
      column_number = page_header_row[column_name]
      factory0 = [
        "#{table_location}/descendant::tr/th[contains(.,#{row_name})]"\
          "/following-sibling::td[#{column_number-1}]"
        ]
      approximate_xpath = factory0
      field_text = kaiki.get_approximate_field(approximate_xpath)
      begin
        raise Capybara::ExpectationNotMet unless field_text.eql?(value)
      rescue Capybara::ExpectationNotMet
        raise Capybara::ExpectationNotMet unless field_text.eql?("true")
      end
    end
  end
end

# Description: Verifies HTTP status 500 does not appear
#
# Parameters:
#   status_no - what is being displayed
#
# Returns nothing
Then (/^I shouldn't get an HTTP Status (\d+)$/) do |status_no|
  kaiki.should_not(have_content("HTTP Status #{status_no}"))


# Description: Checks the state of a certain checkbox if it's checked or not.
#
# Parameters:
#   status_no - what is being displayed
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


# Description: Verifies 'Incident Report' does not appear on the page
#
# Returns nothing
Then (/^I shouldn't see an incident report/) do
  kaiki.should_not(have_content('Incident Report'))
end


# Decription: Verifies that the provided text shows up inside the given frame
#
# Parameters:
#   text  - text that should be within the given frame
#   frame - frame to check inside for given text
#
# Returns nothing.
Then (/^I should see "([^"]*)" in the "([^"]*)" iframe$/) do |text, frame|
  kaiki.get_ready
  kaiki.select_frame(frame+"IFrame")
  raise Capybara::ExpectationNotMet unless kaiki.should have_content(text)
end
