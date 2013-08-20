#
# Description: Functional step methods for feature files, the idea is 
#              that when things are recorded they are tracked
#
# Original Date: August 20, 2011
#

# Public: Records the doc number via xpath
#
# Parameters:
#   xpath - html path
#	
# Returns nothing
#
When /^I record this document number$/ do
  doc_nbr = kaikifs.find_element(:xpath, "//th[contains(text(), 'Doc Nbr')]/following-sibling::td").text.strip
  kaikifs.record[:document_number] = doc_nbr
  puts doc_nbr
end

# Public: Checks to see if data is recorded in field via xpath
#
# Parameters: 
#   field - name of text field
#
# Returns nothing
#
When /^I record this "([^"]*)"$/ do |field|
  value = kaikifs.find_element(:xpath, "//th[contains(text(), '#{field}')]/following-sibling::*").text.strip
  kaikifs.record[field] = value.strip
  puts "#{field} = #{value}"
end

# Public: Checks and iterates two values in a field via xpath
#
# Parameters: 
#   field - name of text field
#
# Returns nothing
#
When /^I record this "([^"]*)" \(the number\)$/ do |field|
  value = kaikifs.find_element(:xpath, "//th[contains(text(), '#{field}')]/following-sibling::*").text.strip
  value = value.to_i.to_s
  kaikifs.record[field] = value
  puts "#{field} = #{value}"
end

# Public: Checks and records values into a field and verifies content
#
# Parameters: 
#   field - name of text field
#
# Returns nothing
#
When /^I set the "([^"]*)" to that one$/ do |field|
  value = kaikifs.record[field]
  kaikifs.set_approximate_field(
    [
      "//th/label[contains(text(), '#{field}:')]/../following-sibling::*/input[1] | //th/label[contains(text(), '#{field}:')]/../following-sibling::*/select[1]",
      "//th[contains(text(), '#{field}')]",
      "//th[contains(text()[1], '#{field}')]",
      "//th[contains(text()[2], '#{field}')]/../following-sibling::*//*[contains(@title, '#{field}')]", # Group > create new > Chart Code
      "//th[contains(text()[3], '#{field}')]"
    ],
    value)
end

# Public: Saves the screen shot to a file with a name and time
#
# Parameters:
#   name - id of item saved
#
# Returns nothing
#
When /^I save a screenshot as "([^"]*)"$/ do |name|
  kaikifs.screenshot(name.file_safe + '_' + Time.now.strftime("%Y%m%d%H%M%S"))
end

#Public: Highlights a button based on its name
#
# Parameters:
#   action - the name of the button
#
# Returns nothing
#
When /^I highlight the "([^"]*)" submit button$/ do |action|
    kaikifs.highlight :name, "methodToCall.#{action.gsub(/ /, '').camelize(:lower)}"
end

# Public: Scroll the page to the object with the specified alt text
#
# Parameters: 
#   text - the alt text of an object
#
# Returns nothing
#
When /^I scroll to the image with alt text "([^"]*)"$/ do |text|
  kaikifs.find_element(:xpath, "//*[@alt='#{text}']").location_once_scrolled_into_view
end

# Public: Defines how the text will be viewed when something is enlarged
#
# Parameters: 
#   text - information type used or stored
#
# Returns nothing
#
When /^I enlargen "([^"]*)"$/ do |text|
  kaikifs.enlargen :xpath, "//*[contains(text(), '#{text}')]"
end

# Public: Requeue all the pending documents
#
# Returns nothing
#
When /^I requeue all of the documents$/ do
  kaikifs.record[:document_numbers].each do |document|
    kaikifs.record[:document_number] = document
    steps %{
    And I set the "Document ID" to the given document number
    And I click "get document"
    And I highlight the "Queue Document Requeuer" submit button
    And I sleep for "2" seconds
    And I click the "Queue Document Requeuer" submit button
    And I scroll to the image with alt text "Workflow"
    Then I should see "Document Requeuer was successfully scheduled"
    And I enlargen "Document Requeuer was successfully scheduled"
    }
  end
end
