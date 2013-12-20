# Description: This file contains everything pertaining to steps that perform
#              actions that happen in a more behind-the-scenes manner;
#              slowing down and speeding up the test speed as well as
#              interacting with multiple browser windows.
#
# Original Date: August 20, 2011

# Description: This step set the pause time back to the default pause time.
#
# Returns nothing.
When (/^I am fast$/) do
  kaiki.log.debug "I am fast (pause_time = #{kaiki.default_pause_time})"
  kaiki.pause_time = kaiki.default_pause_time
end

# Description: This step increases the pause time by 4 seconds by default,
#              but can also increase the pause time by a specified amount.
#
# Parameters:
#   how_much - OPTIONAL - The number of seconds to increase the pause time by.
#                       - OPTIONAL VALUE - "a lot" for 15 seconds.
# Example: (taken from KC 1_proposal_new)
#   And I slow down by a lot
#
# Returns nothing.
When (/^I slow down(?:| by (.*?))$/) do |how_much|
  if how_much == "a lot"
    kaiki.log.debug "I slow down (pause_time = #{kaiki.pause_time + 15})"
    kaiki.pause_time += 15
  elsif how_much == nil
    kaiki.log.debug "I slow down (pause_time = #{kaiki.pause_time + 4})"
    kaiki.pause_time += 4
  else
    kaiki.log.debug "I slow down (pause_time = #{kaiki.pause_time + how_much.to_f})"
    kaiki.pause_time += how_much.to_f
  end
end

# Description: Will pause the test for the specified time in seconds
#
# Returns nothing.
When (/^I sleep for "?([^"]*)"? seconds$/) do |seconds|
  kaiki.log.debug "Sleeping for #{seconds} seconds"
  sleep(seconds.to_i)
end

# Description: This step changes focus to the most recent browser window that
#              has been opened by a previous step.
#
# Returns nothing.
Then (/^a new browser window appears$/) do
	kaiki.pause
	kaiki.change_window_focus(:last)
  kaiki.switch_default_content
end

# Description: This step changes focus to the browser window of your choice.
#
# Parameters:
#   win_num - The ordinal number of the window you wish to switch to. (1st, 2nd,
#             3rd, etc.)
#
# Example: (taken from PA004-0304)
#   Then I switch to the 2nd browser window
#
# Returns nothing.
When (/^I switch to the (.*?) browser window$/) do |win_num|
	kaiki.pause
  win_num = win_num[/\d+/]
	kaiki.change_window_focus(win_num)
  kaiki.switch_default_content
end

# Description: Calls the close_extra_windows method. This closes all windows
#              that are not the base window at program startup.
#
# Returns nothing.
When (/^I close all extra browser windows$/) do
  kaiki.close_extra_windows
end

# KFS PA004-01   (Create Requisition)
# KFS PA004-0304 (Purchase Order)
# KFS PA004-05   (Payment Request)
# KFS PA004-06   (Vendor Credit Memo)
# KFS CASH001-01 (Open Cash Drawer)
# KFS 1099001-01 (Search for Payee)

# Description: This step records the appropriate number from the document to be
#              used later on.
#
# Parameters:
#   field - The number to be recorded.
#
# Example: (taken from PA004-01)
#   When I record this "document" number in the document header
#
# Returns nothing.
When (/^I record this "([^"]*)" number in the document header$/) do |field|
  kaiki.get_ready
  doc_header_numbers = {
    "document"                    => "//th[contains(text(), 'Doc Nbr')]/following-sibling::td",
    "requisition"                 => "//th[contains(text(), 'Requisition #')]/following-sibling::td",
    "purchase order"              => "//th[contains(text(), 'Purchase Order #')]/following-sibling::td",
    "payment request"             => "//th[contains(text(), 'Payment Request')]/following-sibling::td",
    "vendor credit memo"          => "//th[contains(text(), 'Vendor Credit Memo')]/following-sibling::td",
    "requisition document"        => "//th[contains(text(), 'Doc Nbr')]/following-sibling::td",
    "purchase order document"     => "//th[contains(text(), 'Doc Nbr')]/following-sibling::td",
    "payment request document"    => "//th[contains(text(), 'Doc Nbr')]/following-sibling::td",
    "vendor credit memo document" => "//th[contains(text(), 'Doc Nbr')]/following-sibling::td"
  }

  if doc_header_numbers.key?(field.downcase)
    record_number = kaiki.find_approximate_element([doc_header_numbers[field.downcase]]).text.strip
    record_key = "#{field.downcase.gsub(/\s/, '_')}_number".to_sym
    kaiki.record[record_key] = record_number
  else
    other_nbr =
      kaiki.find_approximate_element(
        ["//th[contains(text(), '#{field}')]/following-sibling::td"]).text.strip
    kaiki.record[:other_number] = other_nbr
  end
end

# Description: This step finds the specified label on the page and records the
#              text on the page or in the field next to it. It is then stored
#              in the kaiki.record[] hash to be used elsewhere.
#
# Parameters:
#   amount_label - The label of the field or text to be recorded.
#
# Example: (taken from PA004-05)
#   And I record the "[Vendor Remit Amount]" amount
#
# Returns nothing.
When (/^I record the "(.*?)" amount$/) do |amount_label|
  @amount_label = amount_label.downcase.gsub(/\s/, '_').gsub(':', '').to_sym
  kaiki.get_ready
# factory0 - KFS PA004-05 (Payment Request)
# factory0 - KFS PA004-06 (Vendor Credit Memo)
  factory0 =
    ApproximationsFactory.transpose_build(
      "//h2[contains(., '#{@tab}')]/../../../../following-sibling::div/"       \
        "descendant::%s[contains(., '#{amount_label}')]/../following-sibling::td/div",
      ['td/div'])
# factory1 - KFS PA004-03-04 (Purchase Order)
  factory1 =
    ApproximationsFactory.transpose_build(
      "//h2[contains(., '#{@tab}')]/../../../../following-sibling::div"        \
        "/descendant::h3[contains(., '#{@section}')]/following-sibling::table" \
        "/descendant::%s[text()[contains(.,'#{amount_label}')]]/.."            \
        "/following-sibling::td",
      ['th/label' ])
# factory2 - KFS DV001-01 (Check ACH)
  factory2 =
    ApproximationsFactory.transpose_build(
      "//h2[contains(., '#{@tab}')]/../../../../following-sibling::div"        \
        "/descendant::h3[contains(., '#{@section}')]/following-sibling::table" \
        "/descendant::%s[contains(@title,'#{amount_label}')]",
      ['input' ],
      ['select'])
  approximate_xpath = factory0                                                 \
                    + factory1                                                 \
                    + factory2
  element = kaiki.get_approximate_field(approximate_xpath)
  kaiki.record[@amount_label] = element
end

# KFS - PVEN002-01 (Foreign PO Vendor)

# Description: This step will find the specified date in the document header
#              and record it for later use.
#
# Parameters:
#   field - The identifying header next to the date to be recorded.
#
# Example: (taken from PVEN002-01)
#   When I record this "Created" date in the document header
#
# Returns nothing.
When (/^I record this "(.*?)" date in the document header$/) do |field|
  kaiki.get_ready
  field_symbol = field.downcase.gsub(/\s/, '_').gsub(':', '').to_sym
  approximate_xpath = [
    "//th[contains(text(), '#{field}')]/following-sibling::td"
    ]
  value = kaiki.find_approximate_element(approximate_xpath).text.strip
  kaiki.record[field_symbol] = value
end

# Description: This step is used to record the value of a field on the Vendor
#              page. This is necessary due to the structure of the Vendor page.
#
# Parameters:
#   field       - This is the name of the field to be recorded.
#   subsection  - This is the subsection that contains the field.
#
# Example: (taken from @KFSI1021)
#   When I record the "Vendor Name" vendor field in the "General Information" subsection
#
# Returns: nothing.
When(/^I record the "(.*?)" vendor field in the "(.*?)" subsection$/) do |field, subsection|
  kaiki.get_ready
    location = vendor_page_field_location(field, subsection)
    record = kaiki.get_approximate_field(["//#{location}"])
    record_key = "#{field.downcase.gsub(/\s/, '_')}".to_sym
    kaiki.record[record_key] = record
end

# Public: Takes in the original value and a hash containing options for
#         modification and performs the modification that applies to the
#         specific option.
#         If :type = "digit" the {Xi} part of the original value will be
#         replaced with a random string of digits with the length of X.
#
# Parameters:
#   value   - item to be modified
#   options - hash that contains options of modification
#
# Returns modified value.
def mod_value(value, options = {})
  length = value[/{\d+i}/][/\d+/].to_i
  output = ""
  case options[:type]
  when "digit"
    length.times do
      digit = rand(0..9)
      output += "#{digit}"
    end
  when "string"
    #TODO: if needed in the future for string replacement
  end
  value = value.gsub(/{\d+i}/, output)
  return value
end