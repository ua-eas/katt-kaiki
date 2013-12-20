# Description: This file houses the interpretation of visual steps used by
#              Cucumber features.
#
# Original Date: August 20, 2011

#===============================================================================
# Added for KFS PA004-01

# Description: If necessary, the appropriate document tab is clicked in the
#              browser and the corresponding page object is created.
#
# Returns nothing.
When (/^I am on the "(.*?)" page$/) do |page|
  kaiki.get_ready
  if kaiki.application.eql?('kc')
    unless page.eql?('Proposal') || page.eql?('Award') || page.eql?('Parameters')
      kaiki.click_approximate_field(["//input[@alt='#{page}']"])
    end
  end
  PageFactory.create_page(page, kaiki.application)
end



# Description: Sets the variable @tab and @section for the current page to
#              the given input so the following steps after it, can look in a
#              certain area of the page.
#
# Parameters:
#   tab - area of the page you want to be in
#
# Returns nothing.
When (/^I am in the "(.*?)" tab$/) do |tab|
  kaiki.get_ready
  current_page.tab = tab
  current_page.section = tab
  kaiki.find_approximate_element(["//h2[contains(text(), '#{tab}')]"])
  @sec_type = "h3"
end

# Description: Sets the variable @section for the current page to
#              the given input so the following steps after it, can look in a
#              certain area of the page.
#
# Parameters:
#   section - area of the page you want to be in (DARK GREY banners)
#
# Returns nothing.
When (/^I am in the "(.*?)" section$/) do |section|
  kaiki.get_ready
  current_page.section = section
  begin
    kaiki.find_approximate_element(["//h3[contains(text(), '#{section}')]"])
    @sec_type = "h3"
  rescue Capybara::ElementNotFound
    begin
      kaiki.find_approximate_element(["//span[contains(text(), '#{section}')]"])
      @sec_type = "span"
    rescue Capybara::ElementNotFound
      kaiki.find_approximate_element(["//td[contains(text(), '#{section}')]"])
      @sec_type = "td"
    end
  end
end

# Description: Sets the variable @subsection for the current page to
#              the given input so the following steps after it, can look in a
#              certain area of the page.
#
# Parameters:
#   subsection - area of the page you want to be in (LIGHT GREY banners)
#
# Returns nothing.
When (/^I am in the "(.*?)" subsection$/) do |subsection|
  kaiki.get_ready
  current_page.subsection = subsection
  factory0 = ["//div[text()[contains(., '#{@subsection}')]]"]
  factory1 =
    ApproximationsFactory.transpose_build(
    "//h2[contains(text(), '#{@tab}')]/../../../../following-sibling::"        \
    "div/descendant::%s[contains(text(), '#{@section}')]/"                     \
    "%s[contains(., '#{@subsection}')]",
    ['h3',          '../../following-sibling::tr/td'],
    ['span',        nil ])
  approximate_xpath = factory0                                                 \
                    + factory1
  kaiki.find_approximate_element(approximate_xpath)
end
#===============================================================================

#===============================================================================
# Modified for KFS PA004-01

# Public: Clicks on "Show/Hide" on the specific tab on the current page
#
# Parameters:
#   option - "Show" or "Hide"
#   value  - Which tab is being toggled
#
# Returns nothing.
When(/^I click "([^"]*)" (?:on the "([^"]*)" (?:tab|for "([^"]*)"))$/)         \
  do |action, tab, extra|

  kaiki.get_ready
  current_page.tab = tab
  current_page.section = tab
  current_page.click_show_hide(tab, action)
end
  # special_case = Hash[
    # "Future Action Requests" => Hash[:link => "//a[contains(@href, 'RouteLog.do?showFuture')]",
                                     # :frame =>"routeLogIFrame"]
  # ]
  # if special_case.key?(tab)
    # special_case.each do |key,value|
      # if key == tab
        # @xpath = value[:link]
        # @frame = value[:frame]
      # end
    # end
    # unless @frame.nil?
      # kaiki.select_frame(@frame)
    # end
    # element = kaiki.find_approximate_element([@xpath])
    # element.click
  # elsif action == "Show"
    # kaiki.show_tab(tab)
  # elsif action == "Hide"
    # kaiki.hide_tab(tab)
  # else
    # raise NotImplementedError
  # end
  # @sec_type = "h3"
# end
#===============================================================================

# Public: This function is to click on the show/hide button for a section
#         within a tab.
#
# Parameters:
#    section    - this is the section we want to show/hide
#    subsection - this is the subsection we want to show/hide
#    person     - this is the specific person/section we want to be under
#    option     - this is the action we want to perform
#
# Returns nothing.
When(/^I click "([^"]*)"(?: on the| on) (?:"([^"]*)" section|"([^"]*)" subsection)(?:| under "([^"]*)")$/)\
  do |action, section, subsection, person|

  kaiki.get_ready
  tab = section
  tab = subsection unless subsection.nil?
  current_page.click_show_hide(tab, action, person)
end
  # section_hash = {"show" => "open #{section}", "hide" => "close #{section}"}
  # subsection_hash = {"show" => "open #{subsection}", "hide" => "close #{subsection}"}
  # if subsection
    # action = subsection_hash[option.downcase]
  # elsif section
    # action = section_hash[option.downcase]
  # end
#
  # if person
    # factory0 =
      # ApproximationsFactory.transpose_build(
      # "//h2[contains(., '#{@tab}')]/../../../../following-sibling::div/"       \
        # "descendant::h3[contains(., '#{@section}')]/following-sibling::div/"   \
        # "descendant::div[text()[contains(., '#{person}')]]/../../"             \
        # "following-sibling::tr/descendant::div[text()[contains(., '#{subsection}')]]/%s",
        # ['input'])
    # approximate_xpath = factory0
    # @element = kaiki.find_approximate_element(approximate_xpath)
  # else
    # factory0 =
      # ApproximationsFactory.transpose_build(
      # "//h2[contains(., '#{@tab}')]/../../../../following-sibling::div/"       \
        # "descendant::h3[contains(., '#{@section}')]/following-sibling::"       \
        # "%s/descendant::input[@title='#{action}']",
      # ['table'],
      # ['div'])
    # factory1 =
      # ApproximationsFactory.transpose_build(
        # "//h2[contains(text(), '#{@tab}')]/../../%s",
        # ["../../following-sibling::div/descendant::div[text()[contains(., '#{section}')]]/input"],
        # ["../../following-sibling::div/descendant::span[contains(text(), '#{section}')]/following-sibling::input"],
        # ["following-sibling::tr/td/div[text()[contains(., '#{section}')]]'"])
    # factory2 =
      # ApproximationsFactory.transpose_build(
        # "//td/div[contains(text(), '#{@tab}')]/../../%s",
        # ["../../following-sibling::div/descendant::div[text()[contains(., '#{section}')]]/input"],
        # ["../../following-sibling::div/descendant::span[contains(text(), '#{section}')]/following-sibling::input"],
        # ["following-sibling::tr/td/div[text()[contains(., '#{section}')]]'"])
#
    # approximate_xpath = factory0                                               \
                      # + factory1                                               \
                      # + factory2
    # @element = kaiki.find_approximate_element(approximate_xpath)
  # end
  # @element.click
# end

# Public: The following Webdriver code tells the kaikifs show an Item's
#         sub-item based on its ordered position.
#
# Parameters:
#   ordinal - this is the ordinal provided by the user (1,2,3,4,etc).
#   tab     - this is the sub-item specified.
#
# Returns nothing.
When(/^I show the ([0-9a-z]+) Item's "([^"]*)"/i) do |ordinal, tab|
  numeral = EnglishNumbers::ORDINAL_TO_NUMERAL[ordinal]
  xpath =
    "//td[contains(text(), 'Item #{numeral}')]" \
      "/../following-sibling::tr//div[contains(text()[2], '#{tab}')]//input"
  showHide = kaiki.find(:xpath, xpath)
  if showHide[:alt] == 'hide'
    # It's already shown!
  else
    showHide.click
  end
  sleep(3)
end

# Public: The following Webdriver code tells the kaikifs to click on a form
#         item that is within another element.
#
# Parameters:
#   button  - this is the item to be clicked on.
#   tab     - this is the element that the button is inside.
#
# Returns nothing.
When(/^I click "([^"]*)" under (.*)$/) do |button, tab|
  case
  when button =~ /inactive/
    kaiki.click_and_wait(
      :xpath,
      "//h2[contains(text(), '#{tab}')]"                                       \
        "/../following-sibling::*//input[contains(@title, 'inactive')]")
  end
end

# Public: This function is to click on the show/hide button for a section
#         within a tab.
#
# Parameters:
#    option  - this is the action we want to perform
#    section - this is the section we want to show/hide
#    table   - this is the table to look into
#    row     - this is the row on where the action should occur
#
# Returns nothing.
When(/^I click "(.*?)" on the "(.*?)" section under the "(.*?)" table for row "(.*?)"$/)\
  do |option, section, table, row|

  kaiki.get_ready
  if option == "Show"
    action = "'open #{section}'"
  elsif option == "Hide"
    action = "'close #{section}'"
  else
    raise NotImplementedError
  end
  factory1 =
    ["//tbody/tr/td/h2[contains(text(), '#{table}')]/../../../.."              \
    "/following-sibling::div/div/table/tbody/tr/th[contains(text(), '#{row}')]"\
    "/../following-sibling::tr/td/div[text()[contains(., '#{section}')]]/input"\
    "[contains(@title, #{action})]"]

  approximate_xpath = factory1
  element = kaiki.find_approximate_element(approximate_xpath)
  element.click
end
