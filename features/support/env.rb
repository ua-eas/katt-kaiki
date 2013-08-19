#
# Description: A file that grabs login information and starts and stops 
#              video recording to a file path, also sets up a screenshot on fail
#
# Original Date: August 20, 2011
#

require File.join(File.dirname(__FILE__), '..', '..', 'lib', 'kaiki')
#require File.join(File.dirname(__FILE__), 'english_numbers')
require 'rspec'
require 'highline/import'
require 'active_support/inflector'
require 'yaml'

STDOUT.sync = true

# Public: Collects user info and password for a yml file
#
# Parameters: 
#	  username- name used to login
#	  password- special combination to gain access to something
#	  env- env path
#	  yml- a text file that stores information 
#
# Returns nothing
class KaikiWorld  
  # username   = ENV["KAIKI_NETID"]
  username = "ahaberer" # Until the 'export KAIKI_NETID=username' works, this
                       # will do for auto login
                       # Each user will have to manually change this for now
                       # until the test user is set up
  password   = ENV["KAIKI_PASSWORD"]
  env        = ENV["KAIKI_ENV"]
  env.split(',') if env
    
  # There is a symbolic link in the /katt-kaiki/features/support folder,
  # pointing to the folder encompassing /katt-kaiki.
  # Place your shared_password.yml file here so our passwords are not
  # accidentally sent to each other.
  # For example, my actual shared_password.yml file is 
  # ~/code/shared_password.yml and the symbolic link points to here.
  SHARED_PASSWORDS_FILE = \
    '/home/vagrant/code/katt-kaiki/features/support/shared_passwords.yml'
  
  if File.exist? SHARED_PASSWORDS_FILE
   shared_passwords = YAML::load_file(File.join(File.dirname( \
     File.expand_path(__FILE__)), 'shared_passwords.yml'))
   # print shared_passwords
   if password.nil? and username and shared_passwords.keys.any? { |user| username[user] }
     user_group = shared_passwords.keys.select { |user| username[user] }[0]
     password = shared_passwords[user_group]
   end
  end
  if password.nil? && username
    password = Kaiki::CapybaraDriver::Base.shared_password_for username  if password.nil? && username
  end
  username ||=       ask("NetID:  ")           { |q| q.echo = true }
  password ||=       ask("Password:  ")        { |q| q.echo = "*" }
  env      ||= [] << ask("Environment/URL:  ") { |q| q.echo = true; q.default='cdf' }
  
  is_headless = false
  if ENV['KAIKI_IS_HEADLESS']
    is_headless = ENV['KAIKI_IS_HEADLESS'] =~ /1|true|yes/i
  end

  firefox_profile = ENV['KAIKI_FIREFOX_PROFILE']
  firefox_path    = ENV['KAIKI_FIREFOX_PATH']

  @@kaiki = Kaiki::CapybaraDriver::Base.new(username, password, :envs => env, :is_headless => is_headless, :firefox_profile => firefox_profile, :firefox_path => firefox_path)
  @@kaiki.mk_screenshot_dir(File.join(Dir::pwd, 'features', 'screenshots'))
  @@kaiki.start_session
  @@kaiki.maximize_ish
  @@kaiki.login_via_webauth_with username, password

  @@kaiki.record[:document_number] = ENV['KAIKI_DOC_NUMBER']  if ENV['KAIKI_DOC_NUMBER']
  @@kaiki.record[:document_numbers] = ENV['KAIKI_DOC_NUMBERS'].split(',')  if ENV['KAIKI_DOC_NUMBERS']

  at_exit do
    # This quit has been commented out, because Capybara does it itself, in an at_exit:
    # /home/sam/.rvm/gems/ruby-1.9.3-p125/gems/capybara-1.1.2/lib/capybara/selenium/driver.rb:21
    # This is an open bug, unrelated to [#763](https://github.com/jnicklas/capybara/issues/763).
    #@@kaiki.quit
    @@kaiki.headless.destroy if is_headless
  end

  def kaiki
    @@kaiki
  end
end

# Public: Sets new world or browser 
#
# Parameters: 
# 	KaikiFSWorld.new- new browser
#
# Returns New Environment 
World do
  KaikiWorld.new
end

# Public: Sets up a screen shot on fail after a scenario runs and fails
#
# Parameters: 
#	  scenario- set of tests or tasks 
#
# Returns a Screenshot for a record 
After do |scenario|
  if scenario.failed?
    screenshot_file = scenario.file_colon_line.file_safe + '_' + Time.now.strftime("%Y%m%d%H%M%S")
    kaiki.screenshot(screenshot_file)
  end

  if ENV['KAIKI_REPORT_RECORD'] =~ /1|true|yes/i
    STDOUT.puts "      Recorded Values:"
    kaiki.record.each do |k,v|
      STDOUT.puts "        #{k.to_s.titleize}: #{v}"
    end
  end
end

# Public: Records video while running tests
#
# Parameters:
#	  video- record feature set to run
#	  puts_method- separate function to be called 
#
# Returns a Recorded Video for trace
#Before do
  #kaiki.headless.video.start_capture if kaiki.is_headless
  #kaiki.puts_method = method(:puts)
#end

# Public: Stops recording if failed and saves to a file path "scenario"
#
# Parameters: 
#	  scenario- set of tests or tasks 
#
# Returns a video that shows where it failed
#After do |scenario|
##  if scenario.failed?
    #kaiki.headless.video.stop_and_save(video_path(scenario)) if kaiki.is_headless
##  else
##    headless.video.stop_and_discard
##  end
#end

# Public: Defines where the recorded video is being saved and saved too
#
# Parameters: 
#	  scenario- set of tests or tasks 
#
# Returns a recorded video to a file path
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
