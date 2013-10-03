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
    print "\n"
    print "Starting video for Jenkins...\n"
    headless.video.start_capture
  end

  After do |scenario|
    #if scenario.failed?
      headless.video.stop_and_save(video_path(scenario))
      print "Stopping video for Jenkins...\n"
    #else
    #  headless.video.stop_and_discard
    #end
  end

  def video_path(scenario)
    #print "#{scenario}\n"
    #print "#{scenario.name.split.join("_")}.mov\n"
    #"#{scenario.name.split.join("_")}.mov"
    basename = File.basename(scenario.file_colon_line)
    print "#{basename}\n"
    if basename =~ /^(.+):(\d+)$/
      basename = "#{$1}__%04d" % $2.to_i
    end
    print File.join(Dir::pwd, 'features', 'videos', basename+".mov")
    print "\n"
    File.join(Dir::pwd, 'features', 'videos', basename+".mov")
  end
end
