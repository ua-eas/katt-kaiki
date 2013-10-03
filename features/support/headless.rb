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
  headless = Headless.new(:display => 99)
  headless.start

  at_exit do
    headless.destroy
  end

  Before do
    headless.video.start_capture
  end

  After do |scenario|
    #if scenario.failed?
      path = video_path(scenario)
      headless.video.stop_and_save(path)
      print "Saved video file to #{path}\n"
    #else
      #headless.video.stop_and_discard
    #end
  end

  def video_path(scenario)
    basename = File.basename(scenario.file_colon_line)
    if basename =~ /^(.+):(\d+)$/
      basename = "#{$1}__%04d" % $2.to_i
    end
    File.join(Dir::pwd, 'features', 'videos', basename+".mov")
  end
end
