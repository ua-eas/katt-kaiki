#
# Description: This file sets up the browser to be headless and does iteration by build
#
# Original Date: August 20, 2011
#

# Public: Iteration will come from the Jenkins Build Number
#
# Parameters:
#	  display - sets what and how to displayed
#
# Returns nothing
if ! ENV['BUILD_NUMBER'].nil?
  require 'headless'

  #headless = Headless.new(:display => SERVER_PORT)
  headless = Headless.new(:display => 99)
  headless.start

  at_exit do
    headless.destroy
  end

  Before do
    headless.video.start_capture
  end

  After do |scenario|
    if scenario.failed?
      headless.video.stop_and_save(video_path(scenario))
    else
      headless.video.stop_and_discard
    end
  end

  def video_path(scenario)
    "#{scenario.name.split.join("_")}.mov"
  end
end
