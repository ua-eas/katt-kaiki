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
#              but can also increase the pause tiem by a specified amount.
#
# Parameters:
#   how_much - either "a lot" or a specific number of seconds
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

# Description: Changes focus to the most recent browser window that is opened
#
# Returns nothing.
Then(/^a new browser window appears$/) do
	kaiki.pause
	kaiki.change_window_focus(:last)
  kaiki.switch_default_content
end

# Description: Changes focus to the browser window of your choice
#
# Parameters:
#   win_num - number of the window you wish to switch to. (1st, 2nd, 3rd, etc.)
#
# Returns nothing.
When(/^I switch to the (.*?) browser window$/) do |win_num|
	kaiki.pause
  win_num = win_num[/\d+/]
	kaiki.change_window_focus(win_num)
  kaiki.switch_default_content
end

# Description: Calls the close_extra_windows method. This closes all windows that are
#         not the base window at program startup.
#
# Returns nothing.
When (/^I close all extra browser windows$/) do
  kaiki.close_extra_windows
end

# Public: This step records the appropriate number from the document to be used
#         later on.
#
# Parameters:
#   field - which number to record
#
# Returns nothing.
When(/^I record this "([^"]*)" number in the document header$/) do |field|
  kaiki.get_ready

  doc_header_numbers = {
    "document"                    => "//th[contains(text(), 'Doc Nbr')]/following-sibling::td",
    "requisition"                 => "//th[contains(text(), 'Requisition #')]/following-sibling::td",
    "purchase order"              => "//th[contains(text(), 'Purchase Order #')]/following-sibling::td",
    "payment request"             => "//th[contains(text(), 'Payment Request')]/following-sibling::td",
    "vendor credit memo"          => "//th[contains(text(), 'Vendor Credit Memo')]/following-sibling::td",
    "po document"                 => "//th[contains(text(), 'Doc Nbr')]/following-sibling::td",
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

# Public: This step finds the specified label on the page and records the text
#         on the page in the field next to it. It is then stored in the
#         kaiki.record() hash to be used elsewhere.
#
# Parameters:
#   amount_label - label of the field you want to keep track of the text from
#
# Returns nothing.
When (/^I record the "(.*?)" amount$/) do |amount_label|
  @amount_label = amount_label.downcase.gsub(/\s/, '_').to_sym
  kaiki.get_ready

  factory0 =
    ApproximationsFactory.transpose_build(
      "//h2[contains(., '#{@tab}')]/../../../../following-sibling::div/"       \
      "descendant::%s[contains(., '#{amount_label}')]/../following-sibling::td/div",
      ['td/div'])
  approximate_xpath = factory0
  element = kaiki.find_approximate_element(approximate_xpath)

  print "#{element.text.strip}\n"

  kaiki.record[@amount_label] = element.text.strip
end