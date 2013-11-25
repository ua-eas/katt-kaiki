# Description: This is the top level file for Kaiki that should be required
#              in order to load all of the Kaiki module and its inner
#              components. This file also loads some monkey-patching for
#              File and String, as well as the following gems:
#              headless and json.
#
# Original Date: August 20th 2011

$LOAD_PATH << File.expand_path(File.dirname(__FILE__))

module Kaiki
end

require 'headless'
require 'json'

require 'string'
require 'file'
require 'kaiki/capybara_driver_base'
require 'kaiki/capybara_driver_kc'
require 'kaiki/capybara_driver_kfs'
require 'kaiki/errors'
require 'approximations_factory'