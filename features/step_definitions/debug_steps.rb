# Description: This file contains everything pertaining to debugging
#              feature files.
#
# Original Date: August 20, 2011

# Description: This step evaluates a line of ruby code.
#
# Parameters:
#   ruby - The line of ruby code.
#
# Example: (not currently used in any feature)
#   Then I print "item = 1 + 1"
#
# Returns nothing.
Then(/^I print "([^"]*)"$/) do |ruby|
  result = eval(ruby)
  pp result
  kaiki.log.debug(result.inspect)
end

# Description: This step evaluates an array of lines of ruby code.
#
# Parameters:
#   ruby - The lines of ruby code. This is a Cucumber::AST::Table.
#
# Example: (not currently used in any feature, and can't find any examples of
#           use)
#
# Returns nothing.
Then(/^I print (?:all|each) "([^"]*)"$/) do |ruby|
  result = eval(ruby)
  result.each do |e|
    pp e
  end
  kaiki.log.debug(result.inspect)
end

# Public: This method is used to print the data in a table, stored as either an
#         array of arrays or a hash of hashes.
#
# Returns nothing.
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

# Public: This method will add spaces to the end of a string until it contains
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