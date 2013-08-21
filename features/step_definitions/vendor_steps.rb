# Description: This file houses the interpretation of steps used by Cucumber
#              Vendor features.
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
When /^I fill out a new (?:Vendor Address|vendorAddress) with the following:$/ do |table|
  fields = table.rows_hash
  prefix = "document.newMaintainableObject.add.vendorAddresses."
  fields.each do |key, value|
    kaikifs.set_field(prefix+key, value)
  end
end

# Public: The following Webdriver code tells kaikifs to fill in fields of the 
#         specified tab using the default tabular data.
#
# Parameters:
#   tab - the tab specified to fill with default data.
#
# Returns nothing.
When /^I fill out a new Vendor (.*) with default values$/ do |tab|
  # largely borrowed from When /^I set a new ([^']*)'s "([^"]*)" to "([^"]*)"$/ in form_steps.rb
  fields = TabsFields[tab]
  tab = case tab
        when 'Address (Foreign)' then 'Address'
        else                           tab
        end
  div = tab_id_for(tab)
  put_table_title(fields, tab)
  fields.each do |field, value|
    kaikifs.set_approximate_field(
      approximations_for_field_inside_div(field, div),
      value
    )
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
When /^I fill out a new Vendor (.*) with default values, and the following:$/ do |tab, table|
  # largely borrowed from When /^I set a new ([^']*)'s "([^"]*)" to "([^"]*)"$/ in form_steps.rb
  div = tab_id_for(tab)

  fields = TabsFields[tab].merge table.rows_hash
  put_table_title(fields, tab)
  fields.each do |field, value|
    kaikifs.set_approximate_field(
      approximations_for_field_inside_div(field, div),
      value
    )
    put_fv_as_row(fields, field) unless table.rows_hash.keys.include?(field)
  end
end

# Public: The following Ruby code utilizes the ApproximationsFactory methods to  
#         access fields in a table.
#
# Parameters:
#   field - the field to be accessed.
#   div   - the table that the field is in.
#
# Returns nothing.
def approximations_for_field_inside_div(field, div)
  ApproximationsFactory.transpose_build(
    "//div[@id='#{div}']//%s[contains(text()%s, '#{field}')]/../following-sibling::td/%s",
    ['th/label',    '',       'select[1]'],
    ['th/div',      '[1]',    'input[1]'],
    [nil,           '[2]',    'textarea[1]']
  ) +
  ApproximationsFactory.transpose_build(
    "//div[@id='#{div}']//th[contains(text()%s, '#{field}')]/../following-sibling::tr/td/div/%s[contains(@title, '#{field}')]",
    ['',       'select'],
    ['[1]',    'input'],
    ['[2]',    nil]
  )
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
