# Description: This file contains everything that pertains for either
#              initiating a search or interacting with fields/records on
#              a search page itself.
#
# Original Date: November 20th, 2013

# Description: Takes the name of the button and clicks on the button with that name
#
# Parameters:
#   link  - name of the item to be clicked
#
# Returns nothing.
When(/^I click the "(.*?)" search link$/) do |link|
  kaiki.get_ready
  element = kaiki.find_approximate_element(
    ["//td[contains(text(), '#{link}')]/following-sibling::td/a/img[@alt='lookup']"\
     "/parent::a"])
  element.click
end

# Description: Takes the name of the button and clicks on the button with that name
#
# Parameters:
#   button     - name of the button to be clicked
#   subsection - subsection of the page the radio should be in
#
# Returns nothing.
When(/^I start a lookup for "(.*?)"(?:| (?:under|in) the "(.*?)" subsection)$/) do |button, subsection|
  kaiki.get_ready
  item = button.downcase
  lookup_button_by_name = Hash[
    "employee"                            => "methodToCall.performLookup.(!!org.kuali.kra.bo.KcPerson!!).(((personId:newPersonId))).((``)).((<>)).(([])).((**)).((^^)).((&&)).((//)).((~~)).(::::;;::::).anchor",
    "non-employee"                        => "methodToCall.performLookup.(!!org.kuali.kra.bo.NonOrganizationalRolodex!!).(((rolodexId:newRolodexId))).((``)).((<>)).(([])).((**)).((^^)).((&&)).((//)).((~~)).(::::;;::::).anchor",
    "institutional proposal id"           => "methodToCall.performLookup.(!!org.kuali.kra.institutionalproposal.home.InstitutionalProposal!!).(((proposalId:fundingProposalBean.newFundingProposal.proposalId))).((`fundingProposalBean.newFundingProposal.proposalNumber:proposalNumber`)).((<>)).(([])).((**)).((^^)).((&&)).((//)).((~~)).(::::;;::::).anchorFundingProposals",
    "sponsor template code"               => "methodToCall.performLookup.(!!org.kuali.kra.award.home.AwardTemplate!!).(((templateCode:document.award.templateCode,description:document.award.awardTemplate.description))).((``)).((<>)).(([])).((**)).((^^)).((&&)).((//)).((~~)).(::::;;::::).anchor61",
    "award id"                            => "methodToCall.performLookup.(!!org.kuali.kra.award.home.Award!!).(((awardNumber:document.developmentProposalList[0].currentAwardNumber))).((``)).((<>)).(([])).((**)).((^^)).((&&)).((//)).((~~)).(::::;;::::).anchorRequiredFieldsforSavingDocument",
    "original institutional proposal id"  => "methodToCall.performLookup.(!!org.kuali.kra.institutionalproposal.home.InstitutionalProposal!!).(((proposalNumber:document.developmentProposalList[0].continuedFrom))).((``)).((<>)).(([])).((**)).((^^)).((&&)).((//)).((~~)).(::::;;::::).anchorRequiredFieldsforSavingDocument",
    "person"                              => "methodToCall.performLookup.(!!org.kuali.rice.kim.bo.Person!!).(((principalName:newAdHocRoutePerson.id,name:newAdHocRoutePerson.name))).((#newAdHocRoutePerson.id:principalName#)).((<>)).(([])).((**)).((^^)).((&&)).((//)).((~~)).(::::;;::::).anchor32",
    "vendor #"                            => "methodToCall.performLookup.(!!org.kuali.kfs.vnd.businessobject.VendorDetail!!).(((vendorHeaderGeneratedIdentifier:document.newMaintainableObject.vendorHeaderGeneratedIdentifier,vendorDetailAssignedIdentifier:document.newMaintainableObject.vendorDetailAssignedIdentifier,vendorNumber:document.newMaintainableObject.vendorNumber,))).((#document.newMaintainableObject.vendorHeaderGeneratedIdentifier:vendorHeaderGeneratedIdentifier,document.newMaintainableObject.vendorDetailAssignedIdentifier:vendorDetailAssignedIdentifier,document.newMaintainableObject.vendorNumber:vendorNumber,#)).((<>)).(([])).((**)).((^^)).((&&)).((/vendorDetail/)).((~~)).(::::;https://kf-#{kaiki.env}.mosaic.arizona.edu/kfs-#{kaiki.env}/kr/lookup.do;::::).anchor1",
    "1099 payee id"                       => "methodToCall.performLookup.(!!com.rsmart.kuali.kfs.tax.businessobject.Payee!!).(((id:document.newMaintainableObject.payeeId,))).((#document.newMaintainableObject.payeeId:id,#)).((<>)).(([])).((**)).((^^)).((&&)).((/payee/)).((~~)).(::::;https://kf-#{kaiki.env}.mosaic.arizona.edu/kfs-#{kaiki.env}/kr/lookup.do;::::).anchor1"
  ]

  lookup_button_by_xpath = Hash[
    "grants.gov"                          => "//div[contains(., '#{item}')]/input[contains(@title, 'Search')]",
    "unit of measure code"                => "/html/body/form/table/tbody/tr/td[2]/div/div[4]/div[2]/table/tbody/tr[3]/td[4]/input[2]",
    "note text"                           => "/html/body/form/table/tbody/tr/td[2]/div/div[4]/div[2]/table/tbody/tr[2]/td/input"
  ]

  name  = lookup_button_by_name[item]
  xpath = lookup_button_by_xpath[item]

  if name
    @element = kaiki.find_approximate_element(["//input[@name='#{name}']"])
  elsif xpath
    @element = kaiki.find_approximate_element([xpath])
  else
# factory0 - KFS PA004-01   (Create Requisition)
# factory0 - KFS PA004-0304 (Purchase Order)
# factory0 - KFS DV001-01   (Check ACH)
    factory0 =
      ApproximationsFactory.transpose_build(
        "//h2[contains(., '#{@tab}')]/../../../../following-sibling::div/"     \
        "descendant::%s/descendant::th/div[text()[contains(., '#{button}')]]/../"\
        "following-sibling::td/input[contains(@title, 'Search')]",
        ["h3[contains(., '#{@section}')]/following-sibling::table"],
        ["td[contains(text(), '#{@section}')]/../following-sibling::tr"])
    value = kaiki.record[:requisition_number]
# factory1 - KFS PA004-02 (Assign CM)
    factory1 =
      ApproximationsFactory.transpose_build(
        "//h2[contains(., '#{@tab}')]/../../../../following-sibling::div/"     \
        "descendant::%s/descendant::td/a[contains(text(), '#{value}')]"        \
        "/../preceding-sibling::td/input[contains(@title, 'Search')]",
        ["h3[contains(., '#{@section}')]/following-sibling::table"])
# factory2 - KFS DV001-01 (Check ACH)
   factory2 = 
      ApproximationsFactory.transpose_build(
        "//h2[contains(., '#{@tab}')]/../../../../following-sibling::div/"     \
        "descendant::%s/descendant::input[contains(@title, 'Search #{button}')]",
        ["h3[contains(., '#{@section}')]/following-sibling::table"],
        ["td[contains(., '#{@section}')]/../following-sibling::tr"])
      approximate_xpath = factory0                                             \
                        + factory1                                             \
                        + factory2
      @element = kaiki.find_approximate_element(approximate_xpath)
  end
  @element.click
end

# KFS PA004-01    (Create Requisition)
# KFS PA004-02    (Assign CM)
# KFS PA004-0304  (Purchase Order)
# KFS PA004-05    (Payment Request)
# KFS PA004-06    (Vendor Credit Memo)
# KFS 1099001-01  (Search for Payee)
# KFS PA004-07    (Verify GL Entry)
# KFS DV001-01    (Check ACH)
# KC Feat. 1      (Search Page (Person Lookup))
# KC Feat. 3      (Search Page (Person Lookup))
# KC Feat. 4      (Search Page (Award Lookup))
# KC Feat. 7      (Search Page (Award Lookup))
# KC Feat. 8      (Search Page (Proposal Lookup), Search Page (Institutional Proposal Lookup))
# KC Feat. 13     (Search Page (Institutional Proposal Lookup))

# Description: Step methods for feature files for filling in forms and tables
#
# Description: Defines what is to be put into a given field
#
# Parameters:
#   field - name of text field
#   value - a text or numeral value
#
# Example:
#    And I set "Award Status" to "Active" on the search page
#
# Returns nothing.
When (/^I set "(.*?)" to "(.*?)" on the search page$/) do |field, value|
  kaiki.get_ready

  value_hash = Hash[
    "the recorded document number"                    => kaiki.record[:document_number],                    
    "the recorded requisition number"                 => kaiki.record[:requisition_number],                 
    "the recorded purchase order number"              => kaiki.record[:purchase_order_number],              
    "the recorded requisition document number"        => kaiki.record[:requisition_document_number],        
    "the recorded purchase order document number"     => kaiki.record[:purchase_order_document_number],     
    "the recorded payment request document number"    => kaiki.record[:payment_request_document_number],    
    "the recorded vendor credit memo document number" => kaiki.record[:vendor_credit_memo_document_number], 
  ]
  value = value_hash[value] if value_hash.key?(value)

  factory0 =
    ApproximationsFactory.transpose_build(
      "//%s[contains(text(), '#{field}')]/../following-sibling::td/%s",
      ['th/label',    'select'],
      ['th/div',      'input'])
  approximate_xpath = factory0
  kaiki.set_approximate_field(approximate_xpath, value)
end

# Description: Verifies that the search returns at least one item
#
# Returns nothing.
Then(/^I should see one or more items retrieved on the search page$/) do
  kaiki.pause
  kaiki.switch_default_content
  begin
    kaiki.select_frame("iframeportlet")
  rescue Selenium::WebDriver::Error::NoSuchFrameError
  end
  kaiki.should(have_content('retrieved'))
end

# Description: Orders records in descending order for the selected column
#
# Returns nothing.
When(/^I sort by ([^"]*) on the search page$/) do |column|
  kaiki.get_ready
  kaiki.find(
    :xpath,
    "//a[contains(text(), '#{column}')]").click
  kaiki.wait_for(
    :xpath,
    "//a[contains(text(), '#{column}')]")
  kaiki.find(
    :xpath,
    "//a[contains(text(), '#{column}')]").click
end

# KFS 1099001-01 (Search for Payee)
# KFS DV001-01   (Check ACH)

# Description: Returns the chosen result from a search query
#
# Known Issue: This function will click the 'return value' link on the first
#              row that contains the value anywhere on the data row. Capybara
#              version 2+ has a method to extract the xpath from a Capybara
#              element to do string manipulation and find the correct column to
#              look in. If there is a way to do this in Capybara v1.1.4 which
#              is currently in use, this is remains elusive.
#
# Parameters:
#   column - the column to look in
#   value  - result to be returned
#
# Returns nothing.
When(/^I return the record with "(.*?)" of "(.*?)" on the search page$/)       \
  do |column, value|

  kaiki.get_ready
  factory0 =
    ApproximationsFactory.transpose_build(
      "//th/a[contains(text(),'#{column}')]/../../../"                         \
      "following-sibling::tbody/tr/td%s[contains(text(),'#{value}')]%s/"       \
      "td/a[contains(text(),'return value')]",
      ['/a', '/../..'],
      ['',   '/..'])
  approximate_xpath = factory0
  element = kaiki.find_approximate_element(approximate_xpath)
  element.click
end

# KC & KFS all features

# Description: Performs an action on the first record in the table.
#
# Parameters:
#   action - This is the action to be performed on the first record.
#
# Returns nothing.
When(/^I "(.*?)" the first record on the search page$/) do |action|
  kaiki.get_ready
  element = kaiki.find_approximate_element(["//a[contains(text(), '#{action}')]"])
  element.click
end

# KC & KFS all features

# Description: Performs an action on the returned record in the table.
#
# Parameters:
#   action - This is the action to be performed on the first record.
#
# Returns nothing.
When(/^I select the first document on the search page$/) do
  kaiki.get_ready
  element = kaiki.find_approximate_element(["/html/body/form/table/tbody/tr/"  \
                                            "td[2]/table/tbody/tr/td/a"])
  element.click
end

# KFS PA004-0304 (Purchase Order)
# KFS PA004-05   (Payment Request)
# KFS PA004-06   (Vendor Credit Memo)
# KFS CASH001-01 (Open Cash Drawer) 
# KFS 1099001-01 (Search for Payee)

# Description: Used to open a saved document that has a given descriptive number,
#              i.e. document number, requisition number, etc.
#
# Parameters:
#   column - name of the field the value corresponds to
#   value  - number on the page to look for
#
# Returns nothing.
When(/^I open the saved document with "(.*?)" of "(.*?)" on the search page$/) \
  do |column, value|

  kaiki.get_ready

  case value
  when "the recorded document number"
    value = kaiki.record[:document_number]
  when "the recorded requisition number"
    value = kaiki.record[:requisition_number]
  when "the recorded purchase order number"
    value = kaiki.record[:purchase_order_number]
  else
    raise NotImplementedError
  end

  element = kaiki.find_approximate_element(
    ["//th/a[contains(text(),'#{column}')]/../../../"                          \
    "following-sibling::tbody/tr/td/a[contains(text(),'#{value}')]"])
  element.click
end

# KC & KFS all features

# Description: Performs a search for a specified field on a search page.
#
# Parameters:
#   field - field in which you want to search for
#
# Returns nothing.
When (/^I start a lookup for "(.*?)" on the search page$/) do |field|
  kaiki.get_ready
  element = kaiki.find_approximate_element(["//input[@title = 'Search #{field}']"])
  element.click
end

# KC & KFS all features 

# Public: This sets the value for a group of radio buttons to the specified
#         option. Generates a title for the button to click as
#         "<group name> - <option>" and attempts to click it. This is
#         specifically for a search page and does not contain location
#         awareness.
#
# Parameters:
#   field   - the name of the group of radio buttons.
#   option  - the name of the option within the group to be chosen.
#
# Example: 
#   When I set the "Pending Entry Approved Indicator" option to "No" on the search page
#   This will generate the title "Pending Entry Approved Indicator - No" and
#   attempt to click the field that has this as its title.
#
# Returns nothing.
When(/^I set the "(.*?)" option to "(.*?)" on the search page$/) do |field, option|

  kaiki.get_ready

  approximate_xpath = ["//input[@title = '#{field} - #{option}']"]
  kaiki.click_approximate_field(approximate_xpath)
  
end

# KFS PA004-07 (Verify GL Entry) 

# Public: This step definition compares a specified field on a search page to 
#         the current fiscal year.
#
# Parameters:
#   field - the name of the field to be filled.
#
# Returns nothing.
When(/^I should see "(.*?)" set to the current fiscal year on the search page$/) do |field|

  kaiki.get_ready
  
  value = current_fiscal_year

  special_case_field = {
    "fiscal year" => "//input[@name='universityFiscalYear']",
    }

  if special_case_field[field.downcase]
    field = special_case_field[field.downcase]
    factory0 =[field]
  else
    factory0 =
      ApproximationsFactory.transpose_build(
        "//%s[@title = '#{field}')]",
        ['input'],
        ['select' ])
  end
  approximate_xpath = factory0
  element = kaiki.get_approximate_field(approximate_xpath)
  
  if element != value
    raise Capybara::ExpectationNotMet
  end
end

# KFS PA004-07 (Verify GL Entry) 

# Public: This step definition will read the table from the page (after
#         verifying that we are on the correct lookup/search page), then
#         verifies that the rows of data read from the feature file exists
#         somewhere in the rows of data on the page.
#
# Parameters:
#   lookup_name - the name of the lookup being performed.
#   table       - A Cucumber::AST table that contains the information to be
#                 verified.
#
# Returns nothing.
When(/^I should see the (.*?) results table on the search page filled with:$/) do |lookup_name, table|

  kaiki.get_ready
  
  kaiki.should(have_content(lookup_name))
  page_header_row, page_table, page_table_columns, page_table_rows = read_page_table
  show_table(page_header_row, page_table)
  
  data_table = table.raw
  data_header_row = data_table[0]
  max_data_rows = data_table.size - 1
  max_data_columns = data_header_row.size - 1

  (1..max_data_rows).each do |data_row_counter|
    data_row         = data_table[data_row_counter]
    data_row_match   = false
    (1..page_table_rows).each do |page_row_counter|
      page_row   = page_table[page_row_counter]
        row_match = true
  
      (0..max_data_columns).each do |data_column_counter|
        data_column_name = data_header_row[data_column_counter]
        data_value       = data_row[data_column_counter]
        page_value       = page_row[data_column_name]
        match = false        
        match = true if data_value == page_value
        row_match = false if data_value != page_value
      end

      if row_match == true
        data_row_match = true
        break
      end
    end
    
    if data_row_match == false
      raise Capybara::ExpectationNotMet
    end    
  end
end

# KFS PA004-07 (Verify GL Entry) 

# Public: This function is used to get the current fiscal year. The way to
#         determine this need to be clarified to be implemented. Currently, this
#         assumes the following:
#
#   Assumption #1:  A fiscal year starts and ends with the calendar year.
#                   (January 1 to December 31)
#   Assumption #2:  The current fiscal year to be returned is the next calendar
#                   year.
#                   (January 1, 2013 to December 31, 2013 is 2014)
#
# Returns: Integer (current year + 1)
def current_fiscal_year
  year = kaiki.record[:year]
end

# KFS PA004-07 (Verify GL Entry) 

# Public: This function is used to print the data in a table, stored as either an
#         array of arrays or a hash of hashes.
#
# Returns: Nothing.
def show_table (header_data, table_data)
  data_columns = header_data.size
  data_rows = table_data.size

  (1..data_columns).each do |column|
  end

  (1..data_rows).each do |row|
    (1..data_columns).each do |column|
      row_key = row
      column_key = column
      column_key = header_data[column] if table_data.class.to_s == "Hash"
    end
  end
end

# KFS PA004-07 (Verify GL Entry) 

# Public: This function will add spaces to the end of a string until it contains
#         a number of characters equal to the specified width.
#
# Parameters:
#   width  - The desired minimum width for the string.
#   string - The string to be modified.
#
# Returns: String (with added spaces at the end).
def pad_to(width, string)
  while string.length < width
    string = "#{string} "
  end
  string
end

# KFS PA004-07 (Verify GL Entry) 

# Public: This method reads in a table that is on the web page and determines
#         the number of columns it has.
# 
# Parameters:
#   table_location - the xpath to the table on the web page
#
# Returns: Integer (the number of columns on the page)
def find_table_columns (table_location)
  column_counter = 0
  begin
    while true do
      column_counter  = column_counter + 1
      header_xpath    = "descendant::tr[1]/th[#{column_counter}]"
      header_location = "#{table_location}/#{header_xpath}"
      header_element  = kaiki.find(:xpath, header_location)
    end
  rescue
    column_counter  = column_counter - 1
    return column_counter.to_i
  end
end

# KFS PA004-07 (Verify GL Entry) 

# Public: This method reads in a table that is on the web page and determines
#         the number of rows it has.
# 
# Parameters:
#   table_location - the xpath to the table on the web page
#
# Returns: Integer (the number of rows on the page)
def find_table_rows(table_location)
  row_counter = 0
  begin
    while true do
      row_counter     = row_counter + 1
      row_xpath       = "tbody/tr[#{row_counter}]"
      row_location    = "#{table_location}/#{row_xpath}"
      row_element     = kaiki.find(:xpath, row_location)
    end
  rescue
    row_counter     = row_counter - 1
    return row_counter.to_i
  end
end

# KFS PA004-07 (Verify GL Entry) 

# Public: This method reads in a table that is on the web page and stores the
#         contents into a Hash in memory. This assumes you are interested in the
#         results of a search.
# 
# Returns: 
#   Hash  (the column names of the table)
#   Hash  (the data of the table)
#   Integer (the number of columns of data)
#   Integer (the number of rows of data)
def read_page_table

  header_row = Hash.new
  page_table = Hash.new
  data_row   = Hash.new

  table_location     = "//p[contains(., 'items retrieved')]/following-sibling::table"
  page_table_element = kaiki.find_approximate_element([table_location])
  table_columns      = find_table_columns(table_location)
  table_rows         = find_table_rows(table_location)
  
  (1..table_columns).each do |page_column_counter|
    header_xpath    = "thead/tr[1]/th[#{page_column_counter}]"
    header_location = "#{table_location}/#{header_xpath}"
    header_element  = page_table_element.find(header_xpath)
    header_value    = header_element.text.strip

    kaiki.highlight(:xpath, header_location)
    header_row.store(page_column_counter, header_value)
  end

  (1..table_rows).each do |row_counter|
    row_xpath       = "tbody/tr[#{row_counter}]"
    row_location    = "#{table_location}/#{row_xpath}"
    row_element     = page_table_element.find(row_xpath)
    
    kaiki.highlight(:xpath, row_location)
    (1..table_columns).each do |column_counter|
      field_xpath    = "td[#{column_counter}]"
      field_location = "#{row_location}/#{field_xpath}"
      field_element  = row_element.find(field_xpath)
      field_value    = field_element.text.strip
      kaiki.highlight(:xpath, field_location)
      data_row.store(header_row[column_counter], field_value)
    end

    page_table.store(row_counter, data_row.clone)
    data_row.clear
  end
  return header_row, page_table, table_columns, table_rows
end
