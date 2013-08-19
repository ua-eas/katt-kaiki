#
# Description: Debug logger file.
#
# Original Date: August 20, 2011
#


# Public: Evaluates the kaikifs log result
#
# Parameters:
#	  ruby: programming language specs
#
# Returns nothing
Then /^I print "([^"]*)"$/ do |ruby|
  result = eval(ruby)
  pp result
  kaikifs.log.debug result.inspect
end

# Public: Prints the kaikifs log result
#
# Parameters
#	  ruby: programming language specs
#
# Returns nothing
Then /^I print (?:all|each) "([^"]*)"$/ do |ruby|
  result = eval(ruby)
  result.each do |e|
    pp e
  end
  kaikifs.log.debug result.inspect
end
