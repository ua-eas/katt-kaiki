# Description: It is currently used to set up various methods for each instance
#              of the CapybaraDriver Base. It has access to the envs.json file
#              and a sharedpasswords.yaml file (if created).
#
# Original Date: August 20th 2011

require 'base64'
require 'capybara'
require 'capybara/dsl'
require 'json'
require 'log4r'
begin
  require 'chunky_png'
rescue
end
require 'rspec'
require 'selenium-webdriver'
require 'uri'

module Kaiki
end

module Kaiki::CapybaraDriver
end

# This file is currently incomplete, due to the migration from the
# Selenium WebDriver to Capybara.
class Kaiki::CapybaraDriver::Base
  include Log4r
  include Capybara::DSL

  # The basename of the json file that contains all environment information
  ENVS_FILE = "envs.json"
  
  # The default timeout for Waits
  DEFAULT_TIMEOUT = 8
  
  # The default dimensions for the headless display
  DEFAULT_DIMENSIONS = "1024x768x24"

  # The file that contains shared passwords for test users
  SHARED_PASSWORDS_FILE = "shared_passwords.yaml"

  # Public:
  # Gets/Sets the driver used to power the browser
  # Gets/Sets whether the browser is headless
  # Gets/Sets the overridden puts method
  attr_accessor :driver, :is_headless, :puts_method

  # Public: Initilize a CapybaraDriver instance
  #
  # Parameters:
  #   username - name used by the user to log in with
  #   password - password for said user
  #
  # Returns nothing
  def initialize(username, password, options={})
    @username = username
    @password = password

    # Reads in necessary variables from the envs file
    @standard_envs = JSON.parse(IO.readlines(ENVS_FILE).map{ |l|          \
                     l.gsub(/[\r\n]/, '') }.join(""))
    @envs = options[:envs] ?
      @standard_envs.select { |k,v| options[:envs].include? k } :
      @standard_envs

    if @envs.empty?
      @envs = {
        options[:envs].first => { "code" => options[:envs].first, "url"   \
        => options[:envs].first }
      }
    end

    if @envs.keys.size == 1
      @env = @envs.keys.first
    end

    # Sets variables for each instance of CapybaraDriver
    @pause_time           = options[:pause_time] || 6
    @is_headless          = options[:is_headless]
    @firefox_profile_name = options[:firefox_profile] # nil means make a new one
    @firefox_path         = options[:firefox_path]


    # record is a hash containing notes that the "user" needs to keep, like the
    # document number he just created.
    @record = {}

    # Writes to an external log file with information about certain steps
    # through the feature files
    @log = Logger.new 'debug_log'
    file_outputter = FileOutputter.new 'file', :filename => File.join(Dir::pwd,\
                     'features', 'logs', Time.now.strftime("%Y.%m.%d-%H.%M.%S"))
    @log.outputters = file_outputter
    @log.level = DEBUG
  end

  # Public: Desired url for the browser to navigate to
  #
  # Returns: nothing
  def url
    @envs[@env]['url'] || "https://kr-#{@env}.mosaic.arizona.edu/kra-#{@env}"
    #@envs[@env]['url'] || "https://kr-cdf.mosaic.arizona.edu/kra-cdf"
  end

  # Public: Changes focus to the outermost page element
  #
  # Returns: nothing
  def switch_default_content
    driver.switch_to.default_content
  end
  
  # Public: Changes focus to the given frame by frameid
  #
  # Returns: nothing
  def select_frame(id)
    driver.switch_to.frame id
  end

  # Public: Changes focus to the most recent window opened
  #
  # Returns: nothing
  def change_last_window
    driver.switch_to.window(driver.browser.window.last)
  end

  # Public: Switch to the default tab/window/frame, and backdoor login as `user`
  #
  # Parameters:
  #   user - the user to be backdoored as
  #
  # Returns: nothing
  def backdoor_as(user)
    switch_default_content
    retries = 2
    begin
      @log.debug "   backdoor_as: Waiting up to #{DEFAULT_TIMEOUT} "       \
                    "seconds to find(:name, 'backdoorId')..."
      fill_in('backdoorId', :with => "#{user}")

    rescue Selenium::WebDriver::Error::TimeOutError => error
      raise error if retries == 0
      @log.debug "   backdoor_as: Page is likely boned. Navigating back home..."
      visit base_path
      retries -= 1
      retry
    end
    click_button 'login'
  end

  # Public: Logs in to the Coeus system using the backdoor method 
  #         for the given user
  #
  # Parameters:
  #   user - the user to be logged in as
  #
  # Returns: nothing
  def login_as(user)
    if @login_method == :backdoor
      backdoor_as(user)
    else # log out and log back in as user
      logout
      visit base_path
      login_via_webauth_with user
    end
  end

  # Public: Logs out
  #
  # Returns: nothing
  def logout
    switch_default_content
    click_button 'logout'
  end

  # Public: Defines the base path for url navigation
  #
  # Returns: nothing
  def base_path
    uri = URI.parse url
    uri.path
  end

  # Public: Check the field that is expressed with `selectors`
  #         (the first one that is found). `selectors` is typically
  #         an Array returned by `ApproximationsFactory`, but it 
  #         could be hand-generated.
  #
  # Parameters:
  #   selectors - the identifier of the fields you're looking at
  #
  # Returns: nothing
  def check_approximate_field(selectors)
    timeout = DEFAULT_TIMEOUT
    selectors.each do |selector|
      begin
        return check_by_xpath(selector)
      rescue Selenium::WebDriver::Error::NoSuchElementError,              \
             Selenium::WebDriver::Error::TimeOutError, Capybara::ElementNotFound
        timeout = 0.5
        # Try the next selector
      end
    end

    @log.error "Failed to check approximate field. Selectors are:\n "     \
               "#{selectors.join("\n") }"
    raise Selenium::WebDriver::Error::NoSuchElementError
  end

  # Public: Uncheck the field that is expressed with `selectors`
  #         (the first one that is found). 'selectors` is typically
  #         an Array returned by `ApproximationsFactory`, but it
  #         could be hand-generated.
  #
  # Parameters:
  #   selectors - the identifier of the fields you're looking at
  #
  # Returns: nothing
  def uncheck_approximate_field(selectors)
    selectors.each do |selector|
      begin
        return uncheck_by_xpath(selector)
      rescue Selenium::WebDriver::Error::NoSuchElementError,              \
             Selenium::WebDriver::Error::TimeOutError, Capybara::ElementNotFound
        # Try the next selector
      end
    end

    @log.error "Failed to uncheck approximate field. Selectors are:\n "   \
               "#{selectors.join("\n") }"
    raise Selenium::WebDriver::Error::NoSuchElementError
  end

  # Public: Check a field, selecting by xpath
  #
  # Parameters:
  #  xpath - xpath of the item you're looking for
  #
  # Returns: nothing
  def check_by_xpath(xpath)
    find(:xpath, xpath).set(true)
  end

  # Public: Uncheck a field, selecting by xpath
  #
  # Parameters:
  #   xpath - spath of the item you're looking for
  #
  # Returns: nothing
  def uncheck_by_xpath(xpath)
    find(:xpath, xpath).set(false)
  end

  # Public: Hide a visual vertical tab inside a document's layout.
  #         Accepts the "name" of the tab. Find the name of the tab
  #         by looking up the `title` of the `input` that is the close
  #         button. The title is everything after the word "close."
  #
  # Parameters:
  #   name - name of the tab to toggle
  #
  # Returns: nothing
  def hide_tab(name)
    find(:xpath, "//input[@title='close #{name}']").click
    pause
  end

  # Public: Show a visual vertical tab inside a document's layout. 
  #         Accepts the "name" of the tab. Find the name of the tab
  #         by looking up the `title` of the `input` that is the open
  #         button. The title is everything after the word "open."
  #
  # Parameters:
  #   name - name of the tab to toggle
  #
  # Returns: nothing
  def show_tab(name)
    find(:xpath, "//input[@title='open #{name}']").click
    pause
  end

  # Public - 'host' attribute of {#url}
  #
  # Returns: nothing
  def host
    uri = URI.parse url
    "#{uri.scheme}://#{uri.host}"
  end

  # Public: Login via Webauth with a specific username, and optional password.
  #         If no password is given, it will be retrieved from the shared
  #         passwords file.
  #
  # Parameters:
  #   username - username to log in with
  #   password - password to log in with
  #
  # Returns: nothing
  def login_via_webauth_with(username, password=nil)
    password ||= self.class.shared_password_for username
    sleep 1
    fill_in 'NetID', :with => username
    fill_in 'Password', :with => password
    click_button('LOGIN')
    sleep 1

   # Check if we logged in correctly
    begin
      status = @driver.find_element(:id, 'status')
      if has_content? "You entered an invalid NetID or password"
        raise WebauthAuthenticationError.new
        execute_script "window.close()"
      elsif has_content? "Password is a required field"
        raise WebauthAuthenticationError.new
        execute_script "window.close()"
      end
    rescue Selenium::WebDriver::Error::NoSuchElementError
    end

    begin
      expiring_password_link = @driver.find_element(:link_text, "Go there now")
      if expiring_password_link
        expiring_password_link.click
      end
    rescue Selenium::WebDriver::Error::NoSuchElementError
      return
    end
  end

  # Public: Highlights the current elements being interacted with.
  #
  # Parameters:
  #   method - actual id, name, title, etc.
  #   locator - by id, name, title, etc. or the element
  #
  # Returns: nothing
  def highlight(method, locator, ancestors=0)
    @log.debug "    highlight: Waiting up to #{DEFAULT_TIMEOUT} "         \
                   "seconds to find_element(#{method}, #{locator})..."
    wait = Selenium::WebDriver::Wait.new(:timeout => DEFAULT_TIMEOUT)
    wait.until { find(method, locator) }
    element = find(method, locator)
    driver.execute_script("hlt = function(c) { c.style.border='solid 1px       \
                    rgb(255, 16, 16)'; }; return hlt(arguments[0]);", element)
    parents = ""
    red = 255

    ancestors.times do
      parents << ".parentNode"
      red -= (12*8 / ancestors)
      driver.execute_script("hlt = function(c) { c#{parents}.style.border='    \
                      solid 1px rgb(#{red}, 0, 0)'; };                    \
                      return hlt(arguments[0]);", element)
    end
  end

  # Public: "Maximize" the current window using Selenium's
  #         `manage.window.resize_to`. This script does not use the
  #         window manager's "maximize" capability, but rather resizes
  #         the window.  By default, it positions the window 64 pixels
  #         below and to the right of the top left corner, and sizes the
  #         window to be 128 pixels smaller both vretically and horizontally
  #         than the available space.
  #
  # Parameters:
  #   x - pixels from the left edge the window starts
  #   y - pixels from the top edge the window starts
  #   w - how much smaller you want the browser window than the monitor
  #   h - how much smaller you want the browser window than the monitor
  #
  # Returns: nothing
  def maximize_ish(x = 64, y = 64, w = -128, h = -128)
    if is_headless
      x = 0; y = 0; w = -2; h = -2
    end
    width  = w
    height = h
    width  = "window.screen.availWidth  - #{-w}" if w <= 0
    height = "window.screen.availHeight - #{-h}" if h <= 0
    if is_headless
      @driver.manage.window.position= Selenium::WebDriver::Point.new(0,0)
      max_width, max_height = @driver.execute_script("return              \
                        [window.screen.availWidth, window.screen.availHeight];")
      @driver.manage.window.resize_to(max_width, max_height)
    else
      @driver.manage.window.position= Selenium::WebDriver::Point.new(40,30)
      max_width, max_height = @driver.execute_script("return              \
                        [window.screen.availWidth, window.screen.availHeight];")
      @driver.manage.window.resize_to(max_width-90, max_height-100)
    end
    @driver.execute_script %[
      if (window.screen) {
        window.moveTo(#{x}, #{y});
        window.resizeTo(#{width}, #{height});
      };
    ]
  end

  # Public: Set `@screenshot_dir`, and make the screenshot directory
  #         if it doesn't exist
  #
  # Returns: nothing
  def mk_screenshot_dir(base)
    @screenshot_dir = File.join(base, Time.now.strftime("%Y-%m-%d.%H"))
    return if Dir::exists? @screenshot_dir
    Dir::mkdir(@screenshot_dir)
  end

  # Public: Pause for `@pause_time` by default, or for `time` seconds
  #
  # Returns: nothing
  def pause(time = nil)
    @log.debug "  breathing..."
    sleep (time or @pause_time)
  end

  # Public: "Overrides" Cucumbers handling of STDOUT.
  #
  # Returns: nothing
  # def puts(*args)
  # @puts_method.call(*args)
  # end

  # Public: Take a screenshot, and save it to `@screenshot_dir` by the name
  #         `#{name}.png`
  #
  # Returns: nothing
  def screenshot(name)
    # page.save_screenshot SHOULD work... but doesn't appear to be a method.
    @driver.save_screenshot(File.join(@screenshot_dir, "#{name}.png"))
    puts "Screenshot saved to " + File.join(@screenshot_dir, "#{name}.png")
  end

  # Public: Start a browser session by choosing a Firefox profile, 
  #         setting the Capybara driver, and visiting the #base_path.
  #
  # Returns: nothing
  def start_session
    @download_dir = File.join(Dir::pwd, 'features', 'downloads')
    Dir::mkdir(@download_dir) unless Dir::exists? @download_dir
    mk_screenshot_dir(File.join(Dir::pwd, 'features', 'screenshots'))

    if @firefox_profile_name
      @profile = Selenium::WebDriver::Firefox::Profile.from_name          \
                                                          @firefox_profile_name
    else
      @profile = Selenium::WebDriver::Firefox::Profile.new
    end
    @profile['browser.download.dir'] = @download_dir
    @profile['browser.download.folderList'] = 2
    @profile['browser.helperApps.neverAsk.saveToDisk'] = "application/pdf"
    @profile['browser.link.open_newwindow'] = 3

    if @firefox_path
      Selenium::WebDriver::Firefox.path = @firefox_path
    end

    if is_headless
      # Possibly later we can use different video capture options...
      # video_capture_options = {:codec => 'mpeg4', :tmp_file_path => 
      # "/tmp/.headless_ffmpeg_#{@headless.display}.mp4", 
      # :log_file_path => 'foo.log'}
      @headless = Headless.new(:dimensions => DEFAULT_DIMENSIONS)
      @headless.start
    end

    # Set some basic Capybara settings
    Capybara.run_server = false
    Capybara.app_host = host
    Capybara.default_wait_time = DEFAULT_TIMEOUT
    
    # Register the Firefox driver that is going to use this profile
    Capybara.register_driver :selenium do |app|
      Capybara::Selenium::Driver.new(app, :profile => @profile)
    end
    Capybara.default_driver = :selenium

    visit base_path

    @driver = page.driver.browser
    # @driver = Selenium::WebDriver.for(:remote, :http_client => client)
  end

  # Public: If a config/accounts.yaml file is created, 
  #
  # Parameters:
  #   key -
  #
  # Returns: 
  def config(key)
    key_iv = ('@'+key.to_s).to_sym

    if instance_variable_defined? key_iv
      return instance_variable_get key_iv
    end

    config_file = File.join(File.dirname(__FILE__), '..', '..', 'config', \
                                                            key.to_s + '.yaml')
    config_hash = YAML.load(File.read(config_file))
    instance_variable_set key_iv, config_hash
    return instance_variable_get key_iv
  end

  # Public:
  #
  # Parameters:
  #   title - 
  #   account - 
  #
  # Returns: 
  def user_by_singularized_title(title, account=nil)
    if account.nil?
      account = config(:accounts).values.first
    else
      account = config(:accounts)[account]
    end

    account[title.downcase.gsub(/ +/, '_')] || user_by_singularized_team(title)
  end

  # Public:
  #
  # Parameters:
  #   title - 
  #   account - 
  #
  # Returns: 
  def user_by_title(title, account=nil)
    if account.nil?
      account = config(:accounts).values.first
    else
      account = config(:accounts)[account]
    end

    account[title.downcase.gsub(/ +/, '_')] || user_by_team(title)
  end

  # Public:
  #
  # Parameters:
  #   team -  
  #
  # Returns: 
  def user_by_singularized_team(team)
    singularized_teams = config(:arizona_teams).keys.map                  \
                                                     { |e| [e, e.singularize] }
    team_key = singularized_teams.select                                  \
                                    { |p,s| s == team.downcase.gsub(/ /, '_') }

    if team_key.size > 0
      config(:arizona_teams)[team_key.first.first]['user']
    else
      nil
    end
  end

  # Public:
  #
  # Parameters:
  #   team - 
  #
  # Returns: 
  def user_by_team(team)
    config(:arizona_teams)[team.downcase.gsub(/ +/, '_')]['user']
  end

  # Public: Gathers the shared password for test users to use when logging in
  #         via WebAuth
  #
  # Parameters:
  #   username - username for the shared password
  #
  # Returns: returns the shared password
  def self.shared_password_for(username)
    return nil if not File.exist? SHARED_PASSWORDS_FILE

    shared_passwords = File.open(SHARED_PASSWORDS_FILE)                   \
                                                     { |h| YAML::load_file(h) }
    #puts shared_passwords
    if shared_passwords.keys.any? { |user| username[user] }
      user_group = shared_passwords.keys.select { |user| username[user] }[0]
      return shared_passwords[user_group]
    end
    nil
  end
  
  # Public: Clicks on the link or button with the given name
  #
  # Parameters:
  #   text - item to be clicked on
  #
  # Returns: nothing
  def click(text)
    click_on text
    @log.debug "    clicking #{text}"
  end
  
  # Public: Click a link or button, selecting by xpath
  #
  # Parameters:
  #   xpath - xpath of the item you're looking for
  #
  # Returns: nothing
  def click_by_xpath(xpath)
    find(:xpath, xpath).click
  end
  
  # Public: Click a radio button, selecting by xpath
  #
  # Parameters:
  #   xpath - xpath of the item you're looking for
  #
  # Returns: nothing
  def click_radio_xpath(xpath)
    find(:xpath, xpath).set(true)
  end
  
  # Public: Finds the field you are looking for
  #
  # Parameters:
  #   selector - input, text area, select, etc.
  #   options - extra options for narrowing the search
  #
  # Returns: text in the given field
  def get_field(selector, options={})
    timeout = options[:timeout] || DEFAULT_TIMEOUT
    @log.debug "    get_field: Waiting up to #{timeout}                   \
                               seconds to find_element(:xpath, #{selector})..."
    wait = Selenium::WebDriver::Wait.new(:timeout => timeout)
    wait.until { driver.find_element(:xpath, selector) }
    element = @driver.find_element(:xpath, selector)
    @driver.execute_script("return document.evaluate(\"#{selector}\",     \
                            document, null,                               \
                            XPathResult.FIRST_ORDERED_NODE_TYPE,          \
                            null).singleNodeValue.value;", nil)
  end
  
  # Public: Deselect all `<option>s` within a `<select>`, suppressing any
  #         `UnsupportedOperationError` that Selenium may throw
  #
  # Parameters:
  #   el - name of the select block
  #
  # Returns: nothing
  def safe_deselect_all(el)
    el.deselect_all
  rescue Selenium::WebDriver::Error::UnsupportedOperationError
  end
  
  # Public: Utilizes the Approximation Factory to find the selector type of the
  #         adjacent field to the item you wish to fill in. It then calls
  #         set_field with the selector type and value to be filled in.
  #
  # Parameters:
  #   selectors - input, text area, select, etc.
  #   value - text to be filled in or chosen from a drop down
  #
  # Returns: nothing
  def set_approximate_field(selectors, value=nil)
    timeout = 2
    #print "#{selectors}, #{value}"
    selectors.each do |selector|
      begin
        set_field(selector, value)
        return
      rescue Selenium::WebDriver::Error::NoSuchElementError,              \
                                       Selenium::WebDriver::Error::TimeOutError
        sleep timeout
        timeout = 0.2
        # Try the next selector
      end
    end

    @log.error "Failed to set approximate field. Selectors are:"
    selectors.each { |s| @log.error "  #{s}" }
    raise Selenium::WebDriver::Error::NoSuchElementError
  end
  
  # Public: Takes in the id of a selector, i.e. input, text area, select, etc.,
  #         and inputs the value to this field
  #
  # Parameters:
  #   id - input, text area, select, etc.
  #   value - text to be filled in or chosen from a drop down
  #
  # Returns: nothing
  def set_field(id, value=nil)
    @log.debug "  Start set_field(#{id.inspect}, #{value.inspect})"
    if id =~ /@value=/  # I am praying I only use value for radio buttons...
      node_name = 'radio'
      locator = id
    elsif id =~ /^\/\// or id =~ /^id\(".+"\)/
      node_name = nil
      #dont_stdout! do
        begin
          node = driver.find_element(:xpath, id)
          node_name = node.tag_name.downcase
        rescue Selenium::WebDriver::Error::NoSuchElementError
        end
      #end
      locator = id
    elsif id =~ /^.+=.+ .+=.+$/
      node_name = 'radio'
      locator = id
    else
    @log.debug "    set_field: Waiting up to #{DEFAULT_TIMEOUT} "         \
                  "seconds to find_element(:id, #{id})..."
      wait = Selenium::WebDriver::Wait.new(:timeout => DEFAULT_TIMEOUT)
      wait.until { driver.find_element(:id, id) }
      node = @driver.find_element(:id, id)
      node_name = node.tag_name.downcase
      locator = "//*[@id='#{id}']"
    end

    case node_name
    when 'textarea'
      @log.debug "    set_field: node_name is #{node_name.inspect}"
      @log.debug "    set_field: locator is #{locator.inspect}"
      # Make the field empty first
      # REPLACE WITH CLEAR
      if not locator['"']  # @TODO UGLY UGLY workaround for now. 
                           # If an xpath has double quotes in it... 
                           # then I can't check if it's empty just yet.
        unless get_field(locator).empty?
          @driver.execute_script("return document.evaluate(\"#{locator}\",\
                                  document, null,                         \
                                  XPathResult.FIRST_ORDERED_NODE_TYPE,    \
                                  null).singleNodeValue.value = '';", nil)
        end
      else
        @log.warn "  set_field: locator (#{locator.inspect}) "            \
                    "has a \" in it, so... I couldn't check if the input was " \
                    "empty. Good luck!"
      end

      @driver.find_element(:xpath, locator).send_keys(value, :tab)
    when 'input'
      @log.debug "    set_field: node_name is #{node_name.inspect}"
      @log.debug "    set_field: locator is #{locator.inspect}"
      # Make the field empty first
      # REPLACE WITH CLEAR
      if not locator['"']  # @TODO UGLY UGLY workaround for now. 
                           # If an xpath has double quotes in it... 
                           # then I can't check if it's empty just yet.
        unless get_field(locator).empty?
          @driver.execute_script("return document.evaluate(\"#{locator}\",\
                                  document, null,                         \
                                  XPathResult.FIRST_ORDERED_NODE_TYPE,    \
                                  null).singleNodeValue.value = '';", nil)
        end
      else
        @log.warn "  set_field: locator (#{locator.inspect}) "            \
                    "has a \" in it, so... I couldn't check if the input was " \
                    "empty. Good luck!"
      end

      @driver.find_element(:xpath, locator).send_keys(value, :tab)
    when 'select'
      @log.debug "    set_field: Waiting up to #{DEFAULT_TIMEOUT}         \
                                seconds to find_element(:xpath, #{locator})..."
      wait = Selenium::WebDriver::Wait.new(:timeout => DEFAULT_TIMEOUT)
      wait.until { driver.find_element(:xpath, locator) }
      select = Selenium::WebDriver::Support::Select.new(                  \
                                         @driver.find_element(:xpath, locator))
      safe_deselect_all(select)
      select.select_by(:text, value)
    when 'radio'
      @driver.find_element(:xpath, locator).click
    else
      @driver.find_element(:xpath, locator).send_keys(value)
    end    
  end
  
  # Public: Create and execute a `Selenium::WebDriver::Wait` for finding
  #         an element by `method` and `selector`
  #
  # Parameters:
  #   method - actual id, name, title, etc.
  #   locator - by id, name, title, etc. or the element
  #
  # Returns: nothing
  def wait_for(method, locator)
    @log.debug "    wait_for: Waiting up to #{DEFAULT_TIMEOUT} "          \
                   "seconds to find_element(#{method}, #{locator})..."
    sleep 0.1  # based on http://groups.google.com/group/ruby-capybara/
               # browse_thread/thread/5e182835a8293def fixes
               # "NS_ERROR_ILLEGAL_VALUE"
    find(method, locator)
  end
  
  # Public: Finds the xpath of the given element, using locator and
  #         method variables to describe the element. 
  #         i.e. find_element(:name, "username")
  #
  # Parameters:
  #   method - actual id, name, title, etc.
  #   locator - by id, name, title, etc. or the element
  #
  # Returns: nothing
  def get_xpath(method, locator)
    @log.debug "    wait_for: Waiting up to #{DEFAULT_TIMEOUT} "          \
                   "seconds to find_element(#{method}, #{locator})..."
    element = wait_for(method, locator)
    xpath = driver.execute_script("gPt=function(c){if(c.id!=='')                 \
                           {return'id(\"'+c.id+'\")'}if(c===document.body)\
                           {return c.tagName}var a=0;var                  \
                           e=c.parentNode.childNodes;for(var b=0;         \
                           b<e.length;b++){var d=e[b];if(d===c)           \
                           {return gPt(c.parentNode)+'/'+c.tagName        \
                           +'['+(a+1)+']'}if(d.nodeType===1&&d.tagName=== \
                           c.tagName){a++}}};                             \
                           return gPt(arguments[0]);", element)
    # That line used to end with: return gPt(arguments[0]).toLowerCase();
  end
  
 # Public: This fills in a text field, given its xpath
 #
 # Parameters:
 #  selector - xpath of the field
 #  value - data to fill in with
 #
 # Return: nothing
  def fill_under(selector, value)
    if selector == "Name"
      fill_in("newBudgetVersionName", :with => value)
    else
      @driver.find_element(:xpath, selector).clear
      @driver.find_element(:xpath, selector).send_keys(value)
    end
end

 # Hardcoded method for page 4
 # Public: Inputs the Prj Location value into the field 
 #
 # Parameters:
 #  value - 
 #
 # Returns
	def fill(value)
	  fill_in('customAttributeValues(id2)', :with => '0211-0124-')
	end
	
 # Hardcoded method for page 4
 # Public: Inputs the FA value into the field
 #
 # Parameters:
 #  value - 
 #
 # Returns
	def fill2(value)
	  fill_in('customAttributeValues(id1)', :with => '51.500')
	end

end
