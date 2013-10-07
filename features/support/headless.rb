#
# Description: This file sets up the browser to be headless
#              and does iteration by build.
# Original Date: August 20, 2011
#

# Public: If the test is being run by Jenkins, this file will set up the
#         headless environment for said test.
#
# Parameters:
#	  display - which desktop environment to create the display on.
#
# Returns nothing
unless ENV['BUILD_NUMBER'].nil?
  require 'headless'

  #headless = Headless.new(:display => SERVER_PORT)
  headless = Headless.new(:display => 98)
  headless.start

  at_exit do
    headless.destroy
  end

  # Public: Creates a video of the headless browser, before each scenario.
  #
  # Returns nothing
  Before do
    kaiki.log.debug "Starting video for Jenkins build..."
    headless.video.start_capture
  end

  # Public: Stops video recording after each scenario.
  #
  # Parameters:
  #   scenario - current running test.
  #
  # Returns nothing
  After do |scenario|
    #if scenario.failed?
      headless.video.stop_and_save("/var/opt/toolkit/jenkins/jobs/Kaiki - KC All CI Scenarios - development/workspace/features/videos/#{scenario.name.split.join("_")}.mov")
    #else
      #headless.video.stop_and_discard
    #end
  end
  #After do |scenario|
    #if scenario.failed?
      #path = video_path(scenario)
      #headless.video.stop_and_save(path)
      #print "Saved video file to #{path}\n"
      #kaiki.log.debug "Stopping video for Jenkins build..."
    #else
      #headless.video.stop_and_discard
    #end
  #end

  # Public: Defines where the video is being saved.
  #
  # Parameters:
  #   scenario - current running test.
  #
  # Returns file path of video
  def video_path(scenario)
    basename = File.basename(scenario.file_colon_line)
    if basename =~ /^(.+):(\d+)$/
      basename = "#{$1}__%04d" % $2.to_i
    end
    File.join(Dir::pwd, 'features', 'videos', basename+".mov")
  end
end
