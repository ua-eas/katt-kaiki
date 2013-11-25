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