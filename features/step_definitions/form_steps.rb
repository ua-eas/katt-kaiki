#
# Description: Step methods for feature files 
# 
# Original Date: August 20, 2011
#

# Public: Defines what is to be printed into a given field
#
# Parameters:
#	  field- name of text field
#	  value-a text or numeral value
#
# Example:
#	  And I set the "Description" to "testing: KFSI-4479"
#
# Returns nothing
When /^I set the "([^"]*)" to "([^"]*)"$/ do |field, value|
  kaiki.pause
  kaiki.switch_default_content
  kaiki.select_frame "iframeportlet"
  kaiki.set_approximate_field(
    ApproximationsFactory.transpose_build(
      "//%s[contains(text()%s, '#{field}')]/../following-sibling::td/%s",
      ['th/label',    '',       'select[1]'],
      ['th/div',      '[1]',    'input[1]'],
      [nil,           '[2]',    nil]
    ) +
    ApproximationsFactory.transpose_build(
      "//th[contains(text()%s, '#{field}')]/../following-sibling::tr/td/div/%s[contains(@title, '#{field}')]",
      ['',       'select'],
      ['[1]',    'input'],
      ['[2]',    nil]
    ),
    value
  )
end

# Public: Defines what is to be printed into a given field
#
# Parameters:
#	  field- name of text field
#	  value-a text or numeral value
#
# Example:
#	  And I set the "Description" to "testing: KFSI-4479"
#
# Returns nothing
When /^I set "([^"]*)" to "([^"]*)"$/ do |field, value|
  kaiki.pause
  kaiki.switch_default_content
  kaiki.select_frame "iframeportlet"
  kaiki.set_approximate_field(
    ApproximationsFactory.transpose_build(
      "//%s[contains(text()%s, '#{field}')]/../following-sibling::td/%s",
      ['th/label',    '',       'select[1]'],
      ['th/div',      '[1]',    'input[1]'],
      [nil,           '[2]',    nil]
    ) +
    ApproximationsFactory.transpose_build(
      "//th[contains(text()%s, '#{field}')]/../following-sibling::tr/td/div/%s[contains(@title, '#{field}')]",
      ['',       'select'],
      ['[1]',    'input'],
      ['[2]',    nil]
    ) + 
    ApproximationsFactory.transpose_build(
      "//th/div[contains(text()%s, '#{field}')]/../following-sibling::td/span/%s[contains(@title, '#{field}')]",
      ['',       'input'],
      ['[1]',    nil],
      ['[2]',    nil]
    ),
    value
  )
end


  # Public: takes Prj Location and inputs the value
  #
  # Why hardcoded: as the html lable id dos not match the html field id 
  #                we must tell it what to fill in  
  #
  # Parameters: 
  #	  value: text value, from feature file
  #
  # Example:  And I set Prj Location to "0211-0124-"
  # 	0211-0124- will be filled in
  #
  # Returns nothing
	When /^I set Prj Location to "(.*)"$/ do |value|
	  kaiki.fill(value)
	end
  
  # Public: takes R&A Rate and inputs the value
  #
  # Why hardcoded: as the html lable id dos not match the html field id 
  #                we must tell it what to fill in
  #
  # Parameters 
  #	  value: text value, from feature file
  #
  # Example:   And I set F&A Rate to "51.500"
  #	           51.500 will be filled in
  #
  # Returns nothing
	When /^I set F&A Rate to "(.*?)"$/ do |value|
	  kaiki.fill2(value)
	end
  
  # Public: Defines what is to be printed into a given field
  #
  # Parameters:
  #	  field- name of text field
  #	  value-a text or numeral value
  #
  # Example:
  #	  And I set the "Description" to something like "testing: KFSI-4479"  
  #
  # Returns nothing  
When /^I set the "([^"]*)" to something like "([^"]*)"$/ do |field, value|
  kaiki.pause
  kaiki.switch_default_content
  kaiki.select_frame "iframeportlet"
  # value = value + ' ' + Time.now.strftime("%Y%m%d%H%M%S") # If these 2 lines are commented out, the program works and doesn't skip.
  # puts value
  kaiki.set_approximate_field(
    ApproximationsFactory.transpose_build(
      "//%s[contains(text()%s, '#{field}')]/../following-sibling::td/%s",
      ['th/label',    '',       'select[1]'],
      ['th/div',      '[1]',    'textarea[1]'],
      ['th/div',      '[2]',    'input[1]']
    ),
    value
  )
end

# Public: Sets the dropdown to the given value in the found in the 
#         cucumber file
#
# field - name of the dropdown
# value - data to be used
#
# Returns: nothing  
  When /^I set the field "([^"]*)" to "([^"]*)"$/ do |field, value|
  kaiki.pause
  kaiki.switch_default_content
  kaiki.select_frame "iframeportlet"
  if field == "Type"
    kaiki.set_field('//*[@id="specialReviewHelper.newSpecialReview.specialReviewTypeCode"]',value)
  elsif field == "Approval Status"
    kaiki.set_field('//*[@id="specialReviewHelper.newSpecialReview.approvalTypeCode"]',value)
  end
end

# Public: Sets the dropdown to the given value in the found in the 
#         cucumber file
#
# Parameters:
#   field - name of the dropdown
#   name  - name of the person 
#   value - data to be used
#
# Returns: nothing    
When /^I set "(.*?)" for "(.*?)" as "(.*?)"$/ do |field, name, value|
  kaiki.pause
  kaiki.switch_default_content
  kaiki.select_frame "iframeportlet"
  if field == "Percentage Effort" && name == "Linda L Garland"
    kaiki.set_field('//*[@id="document.developmentProposalList[0].proposalPersons[0].percentageEffort"]', value)
  elsif field == "Percentage Effort" && name == "Amanda F Baker"
    kaiki.set_field('//*[@id="document.developmentProposalList[0].proposalPersons[1].percentageEffort"]', value)
  end
end

# Public: Defines what is to be printed into a given field
#
# Parameters:
#	  field- name of text field
#	  value-a text or numeral value
#
# Example:
#	  And I set the "Description" to "testing: KFSI-4479"
#
# Returns nothing
#When /^I set the "([^"]*)" to "([^"]*)" if blank$/ do |field, value|
  #current_value = kaiki.get_approximate_field(
    #ApproximationsFactory.transpose_build(
      #"//%s[contains(text()%s, '#{field}')]/../following-sibling::td/%s",
      #['th/label',    '',       'select[1]'],
      #['th/div',      '[1]',    'input[1]'],
      #[nil,           '[2]',    nil]
    #) +
    #ApproximationsFactory.transpose_build(
      #"//th[contains(text()%s, '#{field}')]/../following-sibling::tr/td/div/%s[contains(@title, '#{field}')]",
      #['',       'select'],
      #['[1]',    'input'],
      #['[2]',    nil]
    #))

  #if current_value.empty?
    #puts "#{field} was blank."

    #kaiki.set_approximate_field(
      #ApproximationsFactory.transpose_build(
        #"//%s[contains(text()%s, '#{field}')]/../following-sibling::td/%s",
        #['th/label',    '',       'select[1]'],
        #['th/div',      '[1]',    'input[1]'],
        #[nil,           '[2]',    nil]
      #) +
      #ApproximationsFactory.transpose_build(
        #"//th[contains(text()%s, '#{field}')]/../following-sibling::tr/td/div/%s[contains(@title, '#{field}')]",
        #['',       'select'],
        #['[1]',    'input'],
        #['[2]',    nil]
      #),
      #value)

  #else
    #puts "#{field} already had a value: '#{current_value}'."

  #end
#end

# Public: Defines what is needed for a selected field and what else todo via an identifier
#
# Parameters:
#	  field- name of text field
#	  identifier-unique id
#
# Returns nothing 
#When /^I set the "([^"]*)" to that "([^"]*)"$/ do |field, identifier|
  #kaiki.set_approximate_field(
    #ApproximationsFactory.transpose_build(
      #"//%s[contains(text()%s, '#{field}')]/../following-sibling::td/%s",
      #['th/label',    '',       'select[1]'],
      #['th/div',      '[1]',    'input[1]'],
      #[nil,           '[2]',    nil]
    #) +
    #ApproximationsFactory.transpose_build(
      #"//th[contains(text()%s, '#{field}')]/../following-sibling::tr/td/div/%s[contains(@title, '#{field}')]",
      #['',       'select'],
      #['[1]',    'input'],
      #['[2]',    nil]
    #),
    #kaiki.record[identifier]
  #)
#end

# Public: Sets input to correct time format
#
# Parameters:
#	  field- name of text field
#	  time format-i.e. 12:30:00
#
# Returns nothing 
#When /^I set the "([^"]*)" to now \(([^)]+)\)$/ do |field, time_format|
  #kaiki.set_approximate_field(
    #ApproximationsFactory.transpose_build(
      #"//%s[contains(text()%s, '#{field}')]/../following-sibling::td/%s",
      #['th/label',    '',       'select[1]'],
      #['th/div',      '[1]',    'input[1]'],
      #[nil,           '[2]',    nil]
    #) +
    #ApproximationsFactory.transpose_build(
      #"//th[contains(text()%s, '#{field}')]/../following-sibling::tr/td/div/%s[contains(@title, '#{field}')]",
      #['',       'select'],
      #['[1]',    'input'],
      #['[2]',    nil]
    #),
    #Time.now.strftime(time_format)
  #)
#end

# Public: Defines a new vendor and sets to default
#
# Parameters:
#	  field- name of text field
#	  value-a text or numeral value
#
# Example
#	  Vendor > create new; the Vendor Name through Default Payment Method fields
#
# Returns nothing
#When /^I set the new "([^"]*)" to "([^"]*)"$/ do |field, value|
  #kaiki.set_approximate_field(
    #[
      #"//div[contains(text(), '#{field}:') and contains(@id, '.newMaintainableObject.')]/../following-sibling::*/select[1] |" +
        #" //div[contains(text(), '#{field}:')]/../following-sibling::*/input[1]",
      ## The following are for horrible places in KFS where the text in a th might not be the first text() node.
      #"//th[contains(text(), '#{field}') and contains(@id, '.newMaintainableObject.')]",     # INCOMPLETE
      #"//th[contains(text()[1], '#{field}') and contains(@id, '.newMaintainableObject.')]",  # INCOMPLETE
      #"//th[contains(text()[2], '#{field}') and contains(@id, '.newMaintainableObject.')]/../following-sibling::*//*[contains(@title, '#{field}')]", # Group > create new > Chart Code
      #"//th[contains(text()[3], '#{field}') and contains(@id, '.newMaintainableObject.')]",  # INCOMPLETE
      ## The following appear on lookups like the Person Lookup. Like Group > create new > Assignee Lookup (find a shorter path to Person Lookup)
      #"//th/label[contains(text(), '#{field}') and contains(@id, '.newMaintainableObject.')]/../following-sibling::td/select[1]",
      #"//th/label[contains(text(), '#{field}') and contains(@id, '.newMaintainableObject.')]/../following-sibling::td/input[1]"
    #],
    #value)
#end

# Public: Defines a new vendor and then outputs to the Tax Number Field
#
# Parameters:
#	  field- name of text field
#	  value-a text or numeral value
#
# Example Vendor create new; the Tax Number Type field
#
# Returns nothing
#When /^I set the new "([^"]*)" radio to "([^"]*)"$/ do |field, value|
  #kaiki.set_approximate_field(
    #[
      #"//div[contains(text(), '#{field}:') and contains(@id, '.newMaintainableObject.')]/../following-sibling::*/input[@value='#{value}']",
      ## The following are for horrible places in KFS where the text in a th might not be the first text() node.
      #"//th[contains(text(), '#{field}') and contains(@id, '.newMaintainableObject.')]",     # INCOMPLETE
      #"//th[contains(text()[1], '#{field}') and contains(@id, '.newMaintainableObject.')]",  # INCOMPLETE
      #"//th[contains(text()[2], '#{field}') and contains(@id, '.newMaintainableObject.')]/../following-sibling::*//*[contains(@title, '#{field}')]", # Group > create new > Chart Code
      #"//th[contains(text()[3], '#{field}') and contains(@id, '.newMaintainableObject.')]",  # INCOMPLETE
      ## The following appear on lookups like the Person Lookup. Like Group > create new > Assignee Lookup (find a shorter path to Person Lookup)
      #"//th/label[contains(text(), '#{field}') and contains(@id, '.newMaintainableObject.')]/../following-sibling::td/input[@value='#{value}']"
    #],
    #value)
#end

# Public: Defines a what happens when something is set as new
#
# Parameters:
#	  field- name of text field
#	  value-a text or numeral value
#	  tab-a frame, panel or window
#
# Returns nothing
#When /^I set a new ([^']*)'s "([^"]*)" to "([^"]*)"$/ do |tab, field, value|
  ##object =
  ##  case tab
  ##  when 'Address' then 'Address'
  ##  else                tab.pluralize  # Assignee  -->  Assignees
  ##  end
  ##div = "tab-#{object}-div"
  #div = tab_id_for(tab)
  #row =
    #case tab
    #when 'Item' then 'tr[2]'  # Specifically for a Requisition...
    #else             'tr'
    #end
  #title =
    #case field
    #when 'UOM' then 'Unit Of Measure'  # On Requisition Items, it's actually Item Unit Of Measure Code
    #else            field
    #end
  #kaiki.set_approximate_field(
    #ApproximationsFactory.transpose_build(
      #"//*[@id='#{div}']//%s[contains(text()%s, '#{field}')]/../following-sibling::td//%s",
      #['div',       '',       'select[1]'],
      #['th/label',  '[1]',    'input[1]'],
      #[nil,         '[2]',    nil]
    #) +
    #ApproximationsFactory.build(
      #"//*[@id='#{div}']//#{row}//th[contains(text()%s, '#{field}')]/../following-sibling::tr//*[contains(@title, '#{title}')]",
      #['', '[1]', '[2]', '[3]']
    #),
    #value)
#end

# Public: Defines what a document number is when saved
#
# Parameters:
#	  field- name of text field
#
# Returns nothing
#When /^I set the "([^"]*)" to the given document number$/ do |field|
  #doc_nbr = kaiki.record[:document_number]
  #kaiki.set_approximate_field(
    #ApproximationsFactory.transpose_build(
      #"//%s[contains(text()%s, '#{field}')]/../following-sibling::td/%s",
      #['th/label',    '',       'select[1]'],
      #['th/div',      '[1]',    'input[1]'],
      #[nil,           '[2]',    nil]
    #) +
    #ApproximationsFactory.transpose_build(
      #"//th[contains(text()%s, '#{field}')]/../following-sibling::tr/td/div/%s[contains(@title, '#{field}')]",
      #['',       'select'],
      #['[1]',    'input'],
      #['[2]',    nil]
    #),
    #doc_nbr
  #)
#end

# Public: Defines if something is checked or not checked in a field
#
# Parameters:
#	  field- name of text field
#	  check- tracker
#
# Example: checks progress via xpath
#
# Returns nothing
#When /^I (check|uncheck) "([^"]*)"$/ do |check, field|
  #method = (check+'_approximate_field').to_sym

  #if field == 'Immediate Pay'
    #kaiki.send(check, :xpath, "//input[@name='document.immediatePaymentIndicator']")
  #else
    #kaiki.send(method,
      #ApproximationsFactory.transpose_build(
        #"//%s[contains(text()%s, '#{field}')]/../following-sibling::td/input[1]",
        #['th/label',    ''],
        #['th/div',      '[1]'],
        #[nil,           '[2]']
      #) +
      #ApproximationsFactory.transpose_build(
        #"//th[contains(text()%s, '#{field}')]/../following-sibling::tr/td/div/input[1][contains(@title, '#{field}')]",
        #[''],
        #['[1]'],
        #['[2]']
      #)
    #)
  #end
#end

# Public: Defines if something is checked or not checked in a field and againsst its xpath
#
# Parameters:
#	  field- name of text field
#	  value-a text or numeral value
#	  child- sub of a parent class or object
#
# Returns nothing
#When /^I (check|uncheck) the "([^"]*)" for the new "([^"]*)"$/ do |check, field, child|
  #div = case
        #when child == 'Search Alias' then 'tab-SearchAlias-div'
        #else                              "tab-#{child.pluralize}-div"
        #end
  #xpath = "//*[@id='#{div}']//th/label[contains(text(), '#{field}') and contains(@id, '.newMaintainableObject.')]/../following-sibling::td/input[1]"
  #kaiki.send((check+'_by_xpath').to_sym, xpath)
#end

# Public:Defines what happens when you add things from a parent to a chiled 
#
# Parameters:
#	  child- sub of a parent class or object
#
# Example: Group > create new > Assignees
#
# Returns nothing
#When /^I add that "([^"]*)"$/ do |child|
  #case
  #when child =~ /Vendor Address|vendorAddress/  # A new vendor fieldset has no id.
    #kaiki.click_and_wait :id, 'methodToCall.addLine.vendorAddresses.(!!org.kuali.kfs.vnd.businessobject.VendorAddress!!)'
  #else
    #div = tab_id_for(child)

    ## click the (only) add button in the right tab. Example: Group > create new > Assignees
    ## hard-coding add1.gif until we need another image. I don't just want to rely on 'add' yet...
    #add_button = case
      ## The first 'input[contains(@src, 'add1.gif')] is the hidden 'import lines' add button.
      #when child == 'Item' then "//div[@id='#{div}']//input[@title='Add an Item']"
      #else                      "//div[@id='#{div}']//input[contains(@src, 'add1.gif')]"
      #end
    #kaiki.click_and_wait :xpath, add_button
  #end
#end

# Public: Defines what number style is to be used
#
# Parameters:
#	  ordinal-are numbers representing the rank of a number with respect to sequential order
#
# Example:
#	  first 	second 	third
#
# Returns nothing
#When /^I add that ([0-9a-z]+) Item's new Source Line$/i do |ordinal|
  #numeral = EnglishNumbers::ORDINAL_TO_NUMERAL[ordinal]
  #xpath = "//td[contains(text(), 'Item #{numeral}')]" +                                # The cell that contains only "Item 1"
          #"/../following-sibling::tr//div[contains(text()[2], 'Accounting Lines')]" +  # Back up, drop down a row, find the "Acounting Lines" div
          #"/../../following-sibling::tr//td[contains(text(), 'Source')]" +             # Back up, drop down a row, find the "Source" cell
          #"/../following-sibling::tr/td/div/input[contains(@src, 'add1.gif')]"         # Back up, drop down a row, find the "add" button
  ##retries = 3
  ##while true
    #kaiki.click_and_wait :xpath, xpath

    ## NEED SOME STUFF TO DOUBLE CHECK THAT IT WAS ADDED. POSSIBLE ERRORS
    ## "4 error(s) found on page" or "2 error(s) found on page"
    ## * Chart was not selected ("Chart Code (Chart) is a required field.")
    ## * Chart AZ was selected  ("The specified Account Number does not exist.")
    ## Also, take screenshot? record errors?
  ##  break unless kaiki.is_text_present("error(s) found on page")
  ##  retries -= 1
  ##  if retries < 0
  ##    kaiki.log.error "The #{ordinal} item's new Source Lines didn't add so well. No more retries."
  ##    false.should == true  # break out of the scenario?
  ##    break  # did i not break out of the scenario?
  ##  else
  ##    kaiki.log.warn "The #{ordinal} item's new Source Lines didn't add so well. Trying again..."
  ##  end
  ##end
#end

# Public: Defines when vendor is set to default
#
# Parameters:
#	  value-a text or numeral value
#
# Returns nothing
#When /^I set the first Vendor Address as the campus default for "([^"]*)"$/ do |value|
  #kaiki.set_field("document.newMaintainableObject.add.vendorAddresses[0].vendorDefaultAddresses.vendorCampusCode", value)
  #kaiki.record['current_vendor_address'] = 'vendorAddresses[0]'
#end

## WD
#When /^I add that Default Address and wait/i do
  #vendor_address = kaiki.record['current_vendor_address']
  #kaiki.click_and_wait :id, "methodToCall.addLine.#{vendor_address}.vendorDefaultAddresses.(!!org.kuali.kfs.vnd.businessobject.VendorDefaultAddress!!)"
#end

# Public: Defines a prefix for a default item
# 
#	Returns nothing
#When /^I fill out a new Item with default values$/ do
  #prefix = "newPurchasingItemLine."
  #kaiki.set_field(prefix+'itemTypeCode', 'QUANTITY TAXABLE')
  #kaiki.set_field(prefix+'itemQuantity', '42')            # Meaning of Life, the Universe, and Everything
  #kaiki.set_field(prefix+'itemUnitOfMeasureCode', 'BDL')  # Bundle
  #kaiki.set_field(prefix+'itemDescription', 'Surprises')
  #kaiki.set_field(prefix+'itemUnitPrice', '3.14')
#end

# Public: Records an ID for an assignment
# 
# Parameters:
#	  table-form with fields
#	  identifier-unique id
#
# Returns nothing
#When /^I fill out the following for that "([^"]*)":$/ do |identifier, table|
  #fields = table.rows_hash
  #id_value = kaiki.record[identifier]
  #header_text = case identifier
    #when "Requisition #" then "Requisition Number"
    #else                      identifier
    #end
  #header_xpath = "//div[@id='workarea']//th[contains(text(), '#{header_text}')]"
  #header_xpath = kaiki.get_xpath(:xpath, header_xpath)
  ## This will look something like:  id("tab-assignacontractmanager-div")/div[2]/table[1]/tbody[1]/tr[1]/th[2]
  ## So lets take of the digits in the last brackets.
  #column = ''
  #if header_xpath =~ /(\[\d+\])$/
    #column = $1
  #end
  #id_value_xpath = header_xpath + "/../following-sibling::tr/td#{column}"
  #fields_xpath = nil
  #if kaiki.find_element(:xpath, id_value_xpath+"[contains(text(), '#{id_value}')]", :no_raise => true)
    #fields_xpath = id_value_xpath+"[contains(text(), '#{id_value}')]/../td"
  #elsif kaiki.find_element(:xpath, id_value_xpath+"//*[contains(text(), '#{id_value}')]")
    #fields_xpath = id_value_xpath+"//*[contains(text(), '#{id_value}')]/ancestor::tr/td"
  #end

  ## Now fields_xpath contains the xpath for all of the cells in the appropriate row. Now for each field, we find the appropriate column, and set the value!
  #fields.each do |key, value|
    #key_xpath = "//div[@id='workarea']//th[contains(text(), '#{key}')]"
    #key_xpath = kaiki.get_xpath(:xpath, key_xpath)
    #if key_xpath =~ /(\[\d+\])$/
      #field_column = $1
      #field_xpath = fields_xpath + field_column + "//input[1]"
      #kaiki.set_field(field_xpath, value)
    #else
      #raise StandardError
    #end
  #end
#end

# Public: Takes Ordinal numbers and converts to numerals
#
# Parameters:
#	  table-form with fields
#	  ordinal-are numbers representing the rank of a number with respect to sequential order
#	  tab-a frame, panel or window
#
# Returns nothing
#When /^I fill out the ([0-9a-z]+) Item's "([^"]*)" with the following new Source Line:$/ do |ordinal, tab, table|
  #numeral = EnglishNumbers::ORDINAL_TO_NUMERAL[ordinal]
  #xpath = "//td[contains(text(), 'Item #{numeral}')]" +                      # The cell that contains only "Item 1"
          #"/../following-sibling::tr//div[contains(text()[2], '#{tab}')]" +  # Back up, drop down a row, find the "Acounting Lines" div
          #"/../../following-sibling::tr//td[contains(text(), 'Source')]" +   # Back up, drop down a row, find the "Source" cell
          #"/../following-sibling::tr/th[contains(text(), '%s')]" +           # Back up, drop down a row, find the "Chart" header
          #"/../following-sibling::tr/td//%s[contains(@title, '%s')]"         # Back up, drop down a row, find the "Chart" select
  #fields = table.rows_hash

  #retries = 3
  #while true
    #fields.each do |key, value|
      #kaiki.set_approximate_field(
        #ApproximationsFactory::build(
          #xpath,
          #[key],
          #['select[1]', 'input[1]'],
          #[key]
        #),
      #value)
    #end

    ## NEED SOME STUFF TO DOUBLE CHECK THAT ITS ALL FILLED OUT.
    ##break unless (kaiki.is_text_present("account not found") or  # Chart 'AZ' was selected
    ##              kaiki.is_text_present("chart code is empty"))  # No Chart was selected
    #break unless (kaiki.has_content? "account not found" or  # Chart 'AZ' was selected
                  #kaiki.has_content? "chart code is empty")  # No Chart was selected
    #retries -= 1
    #if retries < 0
      #kaiki.log.error "The #{ordinal} item's new Source Lines didn't fill out so well. No more retries."
      #false.should == true  # break out of the scenario?
      #break  # did i not break out of the scenario?
    #else
      #kaiki.log.warn "The #{ordinal} item's new Source Lines didn't fill out so well. Trying again..."
    #end
  #end

  ##fields.each do |key, value|
  ##  kaiki.set_approximate_field(
  ##    ApproximationsFactory::build(
  ##      xpath,
  ##      [key],
  ##      ['select[1]', 'input[1]'],
  ##      [key]
  ##    ),
  ##  value)
  ##end
#end

# Public: Defines ordinal numerals and then puts in a field
#
# Parameters:
#	  ordinal-are numbers representing the rank of a number with respect to sequential order
#	  field- name of text field
#	  value-a text or numeral value
#
# Returns nothing
#When /^I set the ([0-9a-z]+) Item's "([^"]*)" to "([^"]*)"/ do |ordinal, field, value|
  #numeral = EnglishNumbers::ORDINAL_TO_NUMERAL[ordinal]
  #title = case field
    #when "Qty Invoiced"  then "Quantity Invoiced"
    #when "Extended Cost" then "Extended Price"                # Facepalm
    #when "Qty Received"  then "Item Received Total Quantity"  # Facepalm
    #else                      field
    #end
  #xpath = "//th[contains(text(), '%s')]" +                                       # The table that contains the Line Items
          #"/../th[contains(text()%s, '#{field}')]" +                             # Back up, find the label
          #"/../following-sibling::tr/td[1]/b[contains(text(), '#{numeral}')]" +  # Back up, find the nth row
          #"/../following-sibling::td//%s[contains(@title, '#{title}')]"       # Back up, find the input
  #kaiki.set_approximate_field(
    #ApproximationsFactory.transpose_build(
      #xpath,
      #['Item Line #', '',       'select'],
      #['Line #',      '[1]',    'input'],
      #[nil,           '[2]',    nil]
    #),
    #value
  #)
#end

#Transform /#\{\d+i\}/ do |v|
  #v.gsub(/#\{(\d+)i\}/) do |m|
    #m =~ /(\d+)/
    #d = $1.to_i-1
    #(rand*(9*10**d) + 10**d).to_i
  #end
#end

# Public: Defines Tab name
#
# Parameters:
#	  tab name- is the title of a window or panel
#
# Returns nothing
#def tab_id_for(tab_name)
  #singlulars = [
    ## Vendor -> create new
    #'Address',                     'Contact',              'Supplier Diversity',
    #'Shipping Special Conditions', 'Search Alias',         'Vendor Phone Number',
    #'Customer Number',             'Additional Attributes'
               #]
  #object =
    #case
    #when singlulars.include?(tab_name) then tab_name.gsub(' ', '')
    #else                                    tab_name.pluralize  # Assignee  -->  Assignees
    #end
  #return "tab-#{object}-div"
#end
