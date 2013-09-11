#
# Description: A file that grabs login information and starts and stops
#              video recording to a file path;
#              also sets up a screenshot on fail.
# Original Date: August 20, 2011
#

require File.join(File.dirname(__FILE__), '..', '..', 'lib', 'kaiki')
#require File.join(File.dirname(__FILE__), 'english_numbers')
require 'rspec'
require 'headless'
require 'highline/import'
require 'active_support/inflector'
require 'yaml'

STDOUT.sync = true

# Public: This method sets up the environment for the test.
#
# Returns nothing
class KaikiWorld
  username   = ENV["KAIKI_NETID"]
  password   = ENV["KAIKI_PASSWORD"]
  env        = ENV["KAIKI_ENV"]
  env.split(',') if env

#   SHARED_PASSWORDS_FILE = \
#     '/home/vagrant/code/katt-kaiki/features/support/shared_passwords.yml'
# #
#   if File.exist? SHARED_PASSWORDS_FILE
#    shared_passwords = YAML::load_file(File.join(File.dirname( \
#      File.expand_path(__FILE__)), 'shared_passwords.yml'))
#    # #print shared_passwords
#    if password.nil? and username and shared_passwords.keys.any? { |user|    \
#      username[user] }
#      user_group = shared_passwords.keys.select { |user| username[user] }[0]
#      password = shared_passwords[user_group]
#    end
#   end
  if password.nil? && username
    password = Kaiki::CapybaraDriver::Base.shared_password_for username     \
      if password.nil? && username
  end
  username ||=       ask("NetID:  ")           { |q| q.echo = true }
  password ||=       ask("Password:  ")        { |q| q.echo = "*" }
  env      ||= [] << ask("Environment/URL:  ") { |q| q.echo = true;           \
                                                     q.default='cdf' }

  is_headless = true
  if ENV['KAIKI_IS_HEADLESS']
    is_headless = ENV['KAIKI_IS_HEADLESS'] =~ /1|true|yes/i
  end

  firefox_profile = ENV['KAIKI_FIREFOX_PROFILE']
  firefox_path    = ENV['KAIKI_FIREFOX_PATH']

  @@kaiki = Kaiki::CapybaraDriver::Base.new(username, password, :envs => env, \
                                            :is_headless => is_headless,      \
                                            :firefox_profile => firefox_profile,\
                                            :firefox_path => firefox_path)
  @@kaiki.mk_screenshot_dir(File.join(Dir::pwd, 'features', 'screenshots'))
  @@kaiki.start_session
  @@kaiki.maximize_ish
  @@kaiki.login_via_webauth_with(username, password)

  @@kaiki.record[:document_number] = ENV['KAIKI_DOC_NUMBER']                  \
                                     if ENV['KAIKI_DOC_NUMBER']
  @@kaiki.record[:document_numbers] = ENV['KAIKI_DOC_NUMBERS'].split(',')     \
                                      if ENV['KAIKI_DOC_NUMBERS']

  at_exit do
    @@kaiki.headless.destroy if is_headless
  end

  def kaiki
    @@kaiki
  end
end

# Public: Creates new instance of the KaikiWorld class.
#
# Returns a new environment
World do
  KaikiWorld.new
end

# Public: Takes a screenshot of the browser window on test failure.
#
# Parameters:
#	  scenario - set of tests or tasks.
#
# Returns nothing
After do |scenario|
  if scenario.failed?
    screenshot_file = scenario.file_colon_line.file_safe + '_' +              \
                      Time.now.strftime("%Y%m%d%H%M%S")
    kaiki.screenshot(screenshot_file)
  end

  if ENV['KAIKI_REPORT_RECORD'] =~ /1|true|yes/i
    STDOUT.puts "      Recorded Values:"
    kaiki.record.each do |k,v|
      STDOUT.puts "        #{k.to_s.titleize}: #{v}"
    end
  end
end

# Public: Creates a video of the headless browser, before each scenario.
#
# Returns nothing
Before do
  kaiki.headless.video.start_capture if kaiki.is_headless
  kaiki.puts_method = method(:puts)
end

# Public: Stops video recording after each scenario.
#
# Parameters:
#   scenario - current running test.
#
# Returns nothing
After do |scenario|
#  if scenario.failed?
    kaiki.headless.video.stop_and_save(video_path(scenario))                  \
      if kaiki.is_headless
#  else
#    headless.video.stop_and_discard
#  end
end
# end

# Public: Defines where the video is being saved.
#
# Parameters:
#   scenario - current running test.
#
# Returns file path of video
def video_path(scenario)
  #f=File.new('tmp.txt', 'w')
  #f.puts scenario.instance_variables.sort
  #f.puts scenario.methods.sort
  #f.puts scenario.file_colon_line
  #f.close
  #"features/videos/#{scenario.file_colon_line.split(':')[0]}.mov"
  #basename = File.basename(scenario.file_colon_line.split(':')[0])
  basename = File.basename(scenario.file_colon_line)
  if basename =~ /^(.+):(\d+)$/
    basename = "#{$1}__%04d" % $2.to_i
  end
  File.join(Dir::pwd, 'features', 'videos', basename+".mov")
end
