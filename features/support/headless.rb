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
    @base_path = File.join(Dir::pwd, 'features', 'videos')
    @video_dir = mk_video_dir(@base_path)
    headless.video.start_capture
  end

  After do |scenario|
    #if scenario.failed?
      path = video_path(scenario, @video_dir)
      headless.video.stop_and_save(path)
      print "Saved video to #{path}"
    #else
    #  headless.video.stop_and_discard
    #end
  end

  def mk_video_dir(base_path)
    @video_dir = File.join(base_path, Time.now.strftime("%Y-%m-%d.%H"))
    return if Dir::exists? @video_dir
    Dir::mkdir(@video_dir)
  end

  def video_path(scenario, video_dir)
    #"#{scenario.name.split.join("_")}.mov"
    basename = File.basename(scenario.file_colon_line)
    print "\n"
    print "#{basename}\n"
    if basename =~ /^(.+):(\d+)$/
      basename = "#{$1}__%04d" % $2.to_i
    end
    File.join(video_dir, "#{basename}.mov")
  end
end
