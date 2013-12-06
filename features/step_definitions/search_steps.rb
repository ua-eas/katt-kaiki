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
    "vendor #"                            => "methodToCall.performLookup.(!!org.kuali.kfs.vnd.businessobject.VendorDetail!!).(((vendorHeaderGeneratedIdentifier:document.newMaintainableObject.vendorHeaderGeneratedIdentifier,vendorDetailAssignedIdentifier:document.newMaintainableObject.vendorDetailAssignedIdentifier,vendorNumber:document.newMaintainableObject.vendorNumber,))).((#document.newMaintainableObject.vendorHeaderGeneratedIdentifier:vendorHeaderGeneratedIdentifier,document.newMaintainableObject.vendorDetailAssignedIdentifier:vendorDetailAssignedIdentifier,document.newMaintainableObject.vendorNumber:vendorNumber,#)).((<>)).(([])).((**)).((^^)).((&&)).((/vendorDetail/)).((~~)).(::::;https://kf-cdf.mosaic.arizona.edu/kfs-cdf/kr/lookup.do;::::).anchor1",
    "1099 payee id"                       => "methodToCall.performLookup.(!!com.rsmart.kuali.kfs.tax.businessobject.Payee!!).(((id:document.newMaintainableObject.payeeId,))).((#document.newMaintainableObject.payeeId:id,#)).((<>)).(([])).((**)).((^^)).((&&)).((/payee/)).((~~)).(::::;https://kf-cdf.mosaic.arizona.edu/kfs-cdf/kr/lookup.do;::::).anchor1"
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
      approximate_xpath = factory0                                             \
                        + factory1
      @element = kaiki.find_approximate_element(approximate_xpath)
  end
  @element.click
end

# KFS PA004-01
# KFS PA004-02
# KFS PA004-0304
# KFS PA004-05
# KFS PA004-06
# KC Feat. 1  (Search Page (Person Lookup))
# KC Feat. 3  (Search Page (Person Lookup))
# KC Feat. 4  (Search Page (Award Lookup))
# KC Feat. 7  (Search Page (Award Lookup))
# KC Feat. 8  (Search Page (Proposal Lookup), Search Page (Institutional Proposal Lookup))
# KC Feat. 13 (Search Page (Institutional Proposal Lookup))

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
    "the recorded document number"                    => kaiki.record[:document_number],                  # lined up with other items in the hash
    "the recorded requisition number"                 => kaiki.record[:requisition_number],               # lined up with other items in the hash
    "the recorded purchase order number"              => kaiki.record[:purchase_order_number],            # lined up with other items in the hash
    "the recorded requisition document number"        => kaiki.record[:requisition_document_number],      # ADDED for PA004-07
    "the recorded purchase order document number"     => kaiki.record[:purchase_order_document_number],   # ADDED for PA004-07
    "the recorded payment request document number"    => kaiki.record[:payment_request_document_number],  # ADDED for PA004-07
    "the recorded vendor credit memo document number" => kaiki.record[:vendor_credit_memo_document],      # ADDED for PA004-07
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

#Description: Orders records in descending order for the selected column
#
#Returns nothing.
When (/^I sort by ([^"]*) on the search page$/) do |column|
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

# Description: Used to open a saved document that has a given descriptive number,
#         i.e. document number, requisition number, etc.
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
