# Description: This file contains all of the information pertaining to the
#              runtime environment of the application. Things such as
#              the kuali application, the application environment, and the
#              user's username and password are defined here.
#              The World object for the entire cucumber test is created here
#              using the KaikiWorld class.
#
# Original Date: August 20, 2011

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', '..', 'lib'))
# require File.join(File.dirname(__FILE__), '..', '..', 'lib', 'kaiki')
#require File.join(File.dirname(__FILE__), 'english_numbers')
require 'rspec'
require 'headless'
require 'highline/import'
require 'active_support/inflector'
require 'yaml'
require 'require_all'

require_all 'lib'

STDOUT.sync = true

# Public: This class sets up the environment for the test. It asks for your
#         NETID username and password if they aren't already preset, along
#         with the application and environment you wish to run your tests in.
#         It then creates an instance of the CapybaraDriver for the specified
#         application and kicks off the test.
#
# Returns nothing
class KaikiWorld

  username     = ENV["KAIKI_NETID"]
  password     = ENV["KAIKI_PASSWORD"]
  application  = ENV["KAIKI_APP"]
  env          = ENV["KAIKI_ENV"]

  env.split(',') if env

  if password.nil? && username
    password = Kaiki::CapybaraDriver::Base.shared_password_for(username)
  end
  username    ||=       ask("NetID: ")           { |q| q.echo = true }
  password    ||=       ask("Password: ")        { |q| q.echo = "*" }
  application ||=       ask("Application: ")     { |q| q.echo = true;          \
                                                    q.default = 'kfs' }
  env         ||=       ask("Environment/URL: ") { |q| q.echo = true;          \
                                                    q.default='cdf' }

  is_headless = true
  if ENV['KAIKI_IS_HEADLESS']
    is_headless = ENV['KAIKI_IS_HEADLESS'] =~ /1|true|yes/i
  end

  highlight_on = true
  if ENV['KAIKI_HIGHLIGHT']
    highlight_on = ENV['KAIKI_HIGHLIGHT'] =~ /1|true|yes/i
  end

  firefox_profile = ENV['KAIKI_FIREFOX_PROFILE']
  firefox_path    = ENV['KAIKI_FIREFOX_PATH']

  all_apps = JSON.parse(IO.readlines('apps.json').map{ |l| l.gsub(/[\r\n]/, '') }.join(""))
  apps = all_apps.select { |k,v| application.eql?(k) }
  raise "InvalidApplication" unless all_apps.key?(application)
  application = apps[application.downcase]['code']

  options = {:envs => env, :application => application,
             :is_headless => is_headless, :highlight_on => highlight_on,
             :firefox_profile => firefox_profile, :firefox_path => firefox_path}

  app = "Kaiki::CapybaraDriver::#{application.upcase}".split('::').inject(Object)\
    { |o,c| o.const_get c }

  @@kaiki = app.new(username, password, options)
  @@kaiki.mk_screenshot_dir(File.join(Dir::pwd, 'features', 'screenshots'))
  @@kaiki.start_session
  @@kaiki.maximize_ish
  @@kaiki.find(:xpath, "//a[@title='Main Menu']").click if application.eql?("kfs")
  @@kaiki.login_via_webauth_with(username, password)


  @@kaiki.record[:document_number] = ENV['KAIKI_DOC_NUMBER']                 \
                                      if ENV['KAIKI_DOC_NUMBER']
  @@kaiki.record[:document_numbers] = ENV['KAIKI_DOC_NUMBERS'].split(',')    \
                                      if ENV['KAIKI_DOC_NUMBERS']

  @@search_page = Kaiki::Search_Page::Base.new

  at_exit do
    @@kaiki.headless.destroy if is_headless
  end

  # Public: Gives subclasses access to the class variable @@kaiki
  #
  # Returns nothing.
  def kaiki
    @@kaiki
  end

  # Public: Gives access to @@kaiki for other classes that are not subclasses of
  #         KaikiWorld
  #
  # Returns nothing.
  def self.kaiki
    @@kaiki
  end

  # Public: Gives subclasses access to the class variable @@current_page
  #
  # Returns nothing.
  def current_page
    @@current_page
  end

  # Public: Sets the class variable @@current_page for use by KaikiWorld's
  #         subclasses.
  #
  # Parameters:
  #   page - page to be set to @@current_page
  #
  # Returns nothing.
  def self.set_current_page(page)
    @@current_page = page
  end

  # Public: Gives subclasses access to the class variable @@search_page
  #
  # Returns nothing.
  def search_page
    @@search_page
  end

  # Public: Gives access to @@search_page for other classes that are not
  #         subclasses of KaikiWorld
  #
  # Returns nothing.
  def self.search_page
    @@search_page
  end
end

# Public: Creates new instance of the KaikiWorld class.
#
# Returns a new environment
World do
  KaikiWorld.new
end

# Public: First sets the instance variable @scenario for the CapybaraDriver,
#         then creates the logger for logging debug lines. It then starts
#         video capture if the browser is headless. Lastly it loads recorded
#         numbers from a specified text file.
#
# Returns nothing
Before do |scenario|
  kaiki.scenario = scenario
  kaiki.setup_logger

  scenario_file_name = File.basename(scenario.file)
  if not scenario_file_name.include?('BAT') and kaiki.is_headless
    kaiki.log.debug "Starting video..."
    kaiki.headless.video.start_capture
  end

  @record_file = "features/support/recorded_numbers.yaml"
  kaiki.record = YAML.load_file(@record_file) if File::exists? @record_file
  kaiki.record = {} if kaiki.record.eql?(false)

  kaiki.get_date("today")
  kaiki.puts_method = method(:puts)
end

# Public: Closes the current driver in preparation for the next scenario.
#
# Return nothing.
After do |scenario|
  Capybara.current_session.driver.reset!
  kaiki.visit(kaiki.base_path)
end

# Public: Writes recorded numbers to a text file, as well takes a screenshot of
#         the browser window on test failure.
#
# Parameters:
#	  scenario - set of tests or tasks.
#
# Returns nothing
After do |scenario|
  record_file = File.open(@record_file, "w")
  record_file.puts kaiki.record.to_yaml
  record_file.close
  if scenario.failed?
    screenshot_file = File.basename(scenario.file_colon_line) + '_' +          \
                      scenario.name.gsub(/\s/, '-').gsub('/', '').gsub(':', '.')\
                      + '_' +      \
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

# Public: Stops video recording after each scenario.
#
# Parameters:
#   scenario - current running test.
#
# Returns nothing
After do |scenario|
  #if scenario.failed?
    path = video_path(scenario)
    if kaiki.is_headless
      kaiki.headless.video.stop_and_save(path)
      print "Saved video file to #{path}\n"
      kaiki.log.debug "Stopping video..."
    end
    #else
    #kaiki.headless.video.stop_and_discard
  #end
end

# Public: Defines where the video is being saved.
#
# Parameters:
#   scenario - current running test.
#
# Returns file path of video
def video_path(scenario)
  basename = File.basename(scenario.file_colon_line)
  if basename =~ /^(.+):(\d+)$/
    basename = "#{$1}_%04d" % $2.to_i
  end
  basename += "_#{scenario.name.gsub(/\s/,'-').gsub('/', '')}"
  File.join(Dir::pwd, 'features', 'videos', basename+".mov")
end