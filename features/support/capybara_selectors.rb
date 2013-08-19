#
# Description: Selects Capybara Path
#
# Original Date: August 20, 2011
#
require 'capybara'

# Public: Selects Cabybara via Xpath
#
# Paramerters:
#   name-The name of the selector to add
#
# Returns nothing
Capybara.add_selector(:name) do
  xpath { |name| XPath.descendant[XPath.attr(:name) == name.to_s] }
end
