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
    base_path = File.join(Dir::pwd, 'features', 'videos')
    print "\n"
    print "base_path before mk_video_dir: #{base_path}\n"
    @video_dir = mk_video_dir(base_path)
    print "@video_dir after mk_video_dir: #{@video_dir}\n"
    headless.video.start_capture
  end

  After do |scenario|
    #if scenario.failed?
      print "@video_dir: #{@video_dir}\n"
      path = video_path(scenario, @video_dir)
      print "#{path}\n"
      headless.video.stop_and_save(path)
      print "Saved video to #{path}\n"
    #else
    #  headless.video.stop_and_discard
    #end
  end

  def mk_video_dir(base_path)
    print "base_path in mk_video_dir: #{base_path}\n"
    video_dir = File.join(base_path, Time.now.strftime("%Y-%m-%d.%H"))
    print "video_dir in mk_video_dir: #{video_dir}\n"
    print "video_dir exist?: #{Dir::exists? video_dir}\n"
    return if Dir::exists? video_dir
    print "returned from mk_video_dir: #{Dir::mkdir(video_dir)}"
    Dir::mkdir(video_dir)
  end

  def video_path(scenario, video_dir)
    #"#{scenario.name.split.join("_")}.mov"
    basename = File.basename(scenario.file_colon_line)
    print "basename: #{basename}\n"
    if basename =~ /^(.+):(\d+)$/
      basename = "#{$1}__%04d" % $2.to_i
    end
    print "video_dir in video_path: #{video_dir}\n"
    print "#{File.join('#{video_dir}', '#{basename}.mov')}\n"
    File.join('#{video_dir}', '#{basename}.mov')
  end
end
