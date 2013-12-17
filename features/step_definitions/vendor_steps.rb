# Description: This file contains everything pertaining to creating and/or
#              filling out vendor forms.
#
# Original Date: August 20, 2011

# The following Ruby code defines a set of default data for testing purposes.
TabsFields = {
  'Address' => {
    'Address Type'           => 'PURCHASE ORDER',
    'Address 1'              => '123 Main St.',
    'City'                   => 'Tucson',
    'State'                  => 'AZ',
    'Postal Code'            => '85719',
    'Country'                => 'UNITED STATES',
    'Set as Default Address' => 'Yes'
  },
  'Address (Foreign)' => {
    'Address Type'           => 'PURCHASE ORDER',
    'Address 1'              => '123 Main St.',
    'City'                   => 'Berlin',
    'Postal Code'            => '12345-6789',
    'Country'                => 'GERMANY',
    'Set as Default Address' => 'Yes'
  },
  'Contact' => {
    'Contact Type'  => 'ACCOUNTS RECEIVABLE',
    'Name'          => 'Samuel Smith',
    'Email Address' => 'samuel.smith@beer.com',
    'Address 1'     => '123 Main St.',
    'City'          => 'Berlin',
    'State'         => '--',
    'Postal Code'   => '12345-6789',
    'Province'      => 'Berlin',
    'Attention'     => 'Sammy',
    'Comments'      => 'Commenty comment comment'
  },
  'Shipping Special Conditions' => {
    'Shipping Special Condition' => 'LIVE ANIMAL'
  }
}

# Public: The following Webdriver code tells kaikifs to fill in fields of the
#         new address using the provided tabular data.
#
# Parameters:
#   table - the tabular data to be used.
#
# Returns nothing.
When(/^I fill out a new (?:Vendor Address|vendorAddress) with the following:$/)\
  do |table|
  fields = table.rows_hash
  prefix = "document.newMaintainableObject.add.vendorAddresses."
  fields.each do |key, value|
    kaiki.set_approximate_field(prefix+key, value)
  end
end

# Public: The following Webdriver code tells kaikifs to fill in fields of the
#         specified tab using the default tabular data.
#
# Parameters:
#   tab - the tab specified to fill with default data.
#
# Returns nothing.
When(/^I fill out a new Vendor (.*) with default values$/) do |tab|
 fields = TabsFields[tab]
  case tab
  when 'Address (Foreign)'
    tab = 'Address'
  else
    tab = tab
  end
  div = tab_id_for(tab)
  put_table_title(fields, tab)
  fields.each do |field, value|
    factory1 =
      ApproximationsFactory.transpose_build(
        "//div[@id='#{div}']//%s[contains(text(), '#{field}')]"                \
          "/../following-sibling::td/%s",
        ['th/label',    'select[1]'],
        ['th/div',      'input[1]'],
        [nil,           'textarea[1]'])
    factory2 =
      ApproximationsFactory.transpose_build(
        "//div[@id='#{div}']//th[contains(text(), '#{field}')]"                    \
          "/../following-sibling::tr/td/div/%s[contains(@title, '#{field}')]",
        ['select'],
        ['input'])
    approximate_xpath = factory1 + factory2
    element = kaiki.find_approximate_element(approximate_xpath)
    element.set(value)
    put_fv_as_row(fields, field)
  end
end

# Public: The following Webdriver code tells kaikifs to fill in fields of the
#         specified tab using the provided tabular data.
#
# Parameters:
#   tab - the tab specified to fill with data.
#   table - the tabular data to be used.
#
# Returns nothing.
When(/^I fill out a new Vendor (.*) with default values, and the following:$/) \
  do |tab, table|
  div = tab_id_for(tab)
  fields = TabsFields[tab].merge table.rows_hash
  put_table_title(fields, tab)
  fields.each do |field, value|
    factory1 =
      ApproximationsFactory.transpose_build(
        "//div[@id='#{div}']//%s[contains(text(), '#{field}')]"                \
          "/../following-sibling::td/%s",
        ['th/label',    'select[1]'],
        ['th/div',      'input[1]'],
        [nil,           'textarea[1]'])
    factory2 =
      ApproximationsFactory.transpose_build(
        "//div[@id='#{div}']//th[contains(text(), '#{field}')]"                    \
          "/../following-sibling::tr/td/div/%s[contains(@title, '#{field}')]",
        ['select'],
        ['input'])
    approximate_xpath = factory1 + factory2
    element = kaiki.find_approximate_element(approximate_xpath)
    element.set(value)
    put_fv_as_row(fields, field) unless table.rows_hash.keys.include?(field)
  end
end

# Public: The following Ruby code sets the max key size and value size used for
#         displaying the table of data in the console.
#
# Parameters:
#   fields - the group of data that creates the table.
#   field  - the individual field to be displayed.
#
# Returns nothing.
def put_fv_as_row(fields, field)
  max_ksize =   fields.keys.map(&:size).max
  max_vsize = fields.values.map(&:size).max
  puts "| %#{max_ksize}s | %#{max_vsize}s |" % [field, fields[field]]
end

# Public: The following Ruby code displays the title of the data at the top of
#         the table in the console.
#
# Parameters:
#   fields - the group of data that creates the table.
#   tab    - the table to be modified.
#
# Returns nothing.
def put_table_title(fields, tab)
  max_ksize =   fields.keys.map(&:size).max
  max_vsize = fields.values.map(&:size).max
  puts "| #{tab.center(max_ksize + max_vsize + 3)} |"
end

# Public: This method uses location awareness and takes in a field name to
#         return the associated element/xpath identification. This does not
#         include the path to get to the field, only element type with its
#         identifier in xpath notation. This is necessary because
#         almost none of the fields on the Vendor page contains a title 
#         or other identifier that matches the name given to the element
#         on the displayed page.
#
# Parameters:
#   field_name - This is the name as it appears on the screen.
#   subsection - This is the subsection the field falls under, this field
#                is optional.
#
# Example:
#   field_element = vendor_page_field_location("Vendor Type")
#
# Returns String (the element identifier for the field)
def vendor_page_field_location(field_name, subsection=nil)
  if subsection == nil
    subsection = @subsection
  end
  case @tab.downcase
  when "notes and attachments"
    key = "#{@tab} | #{@section} | #{field_name}".downcase
  when "ad hoc recipients"
    key = "#{@tab} | #{@section} | #{subsection} | #{field_name}".downcase
  else
    key = "#{@tab} | #{subsection} | #{field_name}".downcase
  end
  
  vendor_fields_by_name = {
    "document overview | document overview | description"                       =>  "input[@title = 'Document Description']",
    "document overview | document overview | explanation"                       =>  "textarea[@title = 'Explanation']",
    "vendor | general information | vendor name"                                => "input[@name='document.newMaintainableObject.vendorName']",
    "vendor | corporate information | vendor type"                              => "select[@name='document.newMaintainableObject.vendorHeader.vendorTypeCode']",
    "vendor | corporate information | is this a foreign vendor"                 => "select[@name='document.newMaintainableObject.vendorHeader.vendorForeignIndicator']",
    "vendor | corporate information | tax number type"                          => "", #This is a radio button, requires a value to be added to the name and cannot be used by itself.
    "vendor | corporate information | tax number type - *none"                  => "input[@title='Tax Number Type - NONE']",  #This is a radio button with the name added.
    "vendor | corporate information | ownership type"                           => "select[@name='document.newMaintainableObject.vendorHeader.vendorOwnershipCode']",
    "vendor | corporate information | ownership type category"                  => "select[@name='document.newMaintainableObject.vendorHeader.vendorOwnershipCategoryCode']",
    "vendor | detail information | payment terms"                               => "select[@name='document.newMaintainableObject.vendorPaymentTermsCode']",
    "vendor | detail information | shipping title"                              => "select[@name='document.newMaintainableObject.vendorShippingTitleCode']",
    "vendor | detail information | shipping payment terms"                      => "select[@name='document.newMaintainableObject.vendorShippingPaymentTermsCode']",
    "vendor | detail information | vendor url"                                  => "input[@name='document.newMaintainableObject.vendorUrlAddress']",
    "vendor | detail information | confirmation"                                => "select[@name='document.newMaintainableObject.vendorConfirmationIndicator']",
    "vendor | detail information | restricted"                                  => "select[@name='document.newMaintainableObject.vendorRestrictedIndicator']",
    "vendor | detail information | active indicator"                            => "input[@name='document.newMaintainableObject.activeIndicator']", #Note, this is a checkbox
    "vendor | detail information | conflict of interest"                        => "select[@name='document.newMaintainableObject.extension.conflictOfInterest']",
    "vendor | detail information | default payment method"                      => "select[@name='document.newMaintainableObject.extension.defaultB2BPaymentMethodCode']",
    "address | new address | address type"                                      => "select[@name='document.newMaintainableObject.add.vendorAddresses.vendorAddressTypeCode']",
    "address | new address | address 1"                                         => "input[@name='document.newMaintainableObject.add.vendorAddresses.vendorLine1Address']",
    "address | new address | address 2"                                         => "input[@name='document.newMaintainableObject.add.vendorAddresses.vendorLine2Address']",
    "address | new address | city"                                              => "input[@name='document.newMaintainableObject.add.vendorAddresses.vendorCityName']",
    "address | new address | postal code"                                       => "input[@name='document.newMaintainableObject.add.vendorAddresses.vendorZipCode']",
    "address | new address | country"                                           => "select[@name='document.newMaintainableObject.add.vendorAddresses.vendorCountryCode']",
    "address | new address | url"                                               => "input[@name='document.newMaintainableObject.add.vendorAddresses.vendorBusinessToBusinessUrlAddress']",
    "address | new address | email address"                                     => "input[@name='document.newMaintainableObject.add.vendorAddresses.vendorAddressEmailAddress']",
    "address | new address | set as default address"                            => "select[@name='document.newMaintainableObject.add.vendorAddresses.vendorDefaultAddressIndicator']",
    "address | new address | active indicator"                                  => "input[@name='document.newMaintainableObject.add.vendorAddresses.active']", #Note, this is a checkbox
    "address | new address | add"                                               => "input[@id='methodToCall.addLine.vendorAddresses.(!!org.kuali.kfs.vnd.businessobject.VendorAddress!!)']",
    "contact | new contact | contact type"                                      => "select[@name='document.newMaintainableObject.add.vendorContacts.vendorContactTypeCode']", 
    "contact | new contact | name" 	                                            => "input[@name='document.newMaintainableObject.add.vendorContacts.vendorContactName']",
    "contact | new contact | email address" 	                                  => "input[@name='document.newMaintainableObject.add.vendorContacts.vendorContactEmailAddress']",
    "contact | new contact | address 1" 	                                      => "input[@name='document.newMaintainableObject.add.vendorContacts.vendorLine1Address']",
    "contact | new contact | city" 	                                            => "input[@name='document.newMaintainableObject.add.vendorContacts.vendorCityName']",
    "contact | new contact | postal code" 	                                    => "input[@name='document.newMaintainableObject.add.vendorContacts.vendorZipCode']",
    "contact | new contact | country"                                           => "select[@name='document.newMaintainableObject.add.vendorContacts.vendorCountryCode']",
    "contact | new contact | attention"	                                        => "input[@name='document.newMaintainableObject.add.vendorContacts.vendorAttentionName']",
    "contact | new contact | comments"	                                        => "textarea[@name='document.newMaintainableObject.add.vendorContacts.vendorContactCommentText']",
    "contact | new contact | active indicator" 	                                => "input[@name='document.newMaintainableObject.add.vendorContacts.active']", #This is a checkbox.
    "contact | new contact | add"                                               => "input[@id='methodToCall.addLine.vendorContacts.(!!org.kuali.kfs.vnd.businessobject.VendorContact!!)']",
    "supplier diversity | new supplier diversity | supplier diversity"          => "select[@name='document.newMaintainableObject.add.vendorHeader.vendorSupplierDiversities.vendorSupplierDiversityCode']",
    "supplier diversity | new supplier diversity | active indicator"            => "input[@name='document.newMaintainableObject.add.vendorHeader.vendorSupplierDiversities.active']", #This is a checkbox.
    "supplier diversity | new supplier diversity | add"                         => "input[@id='methodToCall.addLine.vendorHeader.vendorSupplierDiversities.(!!org.kuali.kfs.vnd.businessobject.VendorSupplierDiversity!!)']",
    "shipping special conditions | new shipping special condition | shipping special condition"        => "select[@name='document.newMaintainableObject.add.vendorShippingSpecialConditions.vendorShippingSpecialConditionCode']",
    "shipping special conditions | new shipping special condition | active indicator"                  => "input[@name='document.newMaintainableObject.add.vendorShippingSpecialConditions.active']", #This is a checkbox.
    "shipping special conditions | new shipping special condition | add"                               => "input[@id='methodToCall.addLine.vendorShippingSpecialConditions.(!!org.kuali.kfs.vnd.businessobject.VendorShippingSpecialCondition!!)']",
    "vendor phone number | new phone numbers | phone type"	                    =>  "select[@name='document.newMaintainableObject.add.vendorPhoneNumbers.vendorPhoneTypeCode']",
    "vendor phone number | new phone numbers | phone number"	                  =>  "input[@name='document.newMaintainableObject.add.vendorPhoneNumbers.vendorPhoneNumber']",
    "vendor phone number | new phone numbers | active indicator"                =>  "input[@name='document.newMaintainableObject.add.vendorPhoneNumbers.active']", #This is a checkbox.
    "vendor phone number | new phone numbers | add"                             =>  "input[@id='methodToCall.addLine.vendorPhoneNumbers.(!!org.kuali.kfs.vnd.businessobject.VendorPhoneNumber!!)']",
    "notes and attachments | notes and attachments | note text"                 => "textarea[@title='* Note Text']",
    "notes and attachments | notes and attachments | attached file"             => "input[@name='attachmentFile']",
    "notes and attachments | notes and attachments | cancel"                    => "input[@title='Cancel Attachment']",
    "notes and attachments | notes and attachments | add"                       => "input[@title='Add a Note']",
    }

  vendor_fields_by_xpath = {
    #vendor (tab) | general information (subsection)
    "vendor | general information | vendor #"                         => "th[contains(., 'Vendor #:')]/following-sibling::td/span", 
    "vendor | general information | vendor parent indicator"          => "th[contains(., 'Vendor Parent Indicator:')]/following-sibling::td/span",
    }

  if vendor_fields_by_name[key]
    return vendor_fields_by_name[key]
  elsif vendor_fields_by_xpath[key]
    return vendor_fields_by_xpath[key]
  else
    return nil
  end
end

# Public: This step will fill out a tab within the Vendor document using
#         location awareness. If the value begins with a *, this indicates
#         this is a radio button and needs a special mode
#         to set the field. The vendor_tab_field_location method stores the
#         element type with xpath identification and performs the lookup based
#         on the field_name that it is given.
#
# Parameters:
#   subsection  - This is the subsection of the tab to be filled.
#   table       - This is a vertical Cucumber::AST::Table:
#                   <column 1> is the field name.
#                   <column 2> is the value.
#
# Example: (taken from PVEN002-01)
#   When I fill out the new Vendor "Corporate Information" subsection with:
#     | Vendor Type              | Purchase Order                    |
#     | Is this a foreign vendor | Yes                               |
#     | Tax Number Type          | *NONE                             |
#
# Returns nothing.
When(/^I fill out the new Vendor "(.*?)" subsection with:$/) do |subsection, table|
  kaiki.get_ready
  @subsection = subsection
  data_table    = table.raw
  max_data_rows = data_table.size - 1

  (0..max_data_rows).each do |data_row_counter|
    field_name     = data_table[data_row_counter][0]
    value          = data_table[data_row_counter][1]
    if value[0] == "*"
      field_name   = "#{field_name} - #{value}"
      value        = "checked"
    end
    field_element = vendor_page_field_location(field_name)
    option1 = "../following-sibling::tr/td/#{field_element}"
    option2 = "../../../following-sibling::table/descendant::#{field_element}"
    factory0      =
      ApproximationsFactory.transpose_build(
        "//h2[contains(., '#{@tab}')]/../../../../following-sibling::div"      \
          "/descendant::td[contains(., '#{@subsection}')]/%s",
        [option1],
        [option2])
    if value == "checked"
      kaiki.click_approximate_field(factory0)
    else
      kaiki.set_approximate_field(factory0, value)
    end
  end
end
