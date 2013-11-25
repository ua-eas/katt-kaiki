# Description: This file contains everything pertaining to debugging
#              feature files.
#
# Original Date: August 20, 2011

# Description: Evaluates the kaiki log result
#
# Parameters:
#   ruby - programming language specs
#
# Returns nothing.
Then(/^I print "([^"]*)"$/) do |ruby|
  result = eval(ruby)
  pp result
  kaiki.log.debug(result.inspect)
end

# Description: Prints the kaiki log result
#
# Parameters:
#   ruby - programming language specs
#
# Returns nothing.
Then(/^I print (?:all|each) "([^"]*)"$/) do |ruby|
  result = eval(ruby)
  result.each do |e|
    pp e
  end
  kaiki.log.debug(result.inspect)
end
