# Description: This file contains everything pertaining to the visual aspect of
#              kuali webpages; highlighting tabs, sections and toggling
#              show/hide for users to follow either during live test runs
#              or later on while watching video playback.
#
# Original Date: August 20, 2011

# KC and KFS all features

# Description: This step sets the variable @tab and @section to the given input
#              so the following steps after it, can look in a certain area of
#              the page. It's common that the initial section after a tab
#              matches that tab's name.
#
# Parameters:
#	  tab - Area of the page you want to be in. (LIGHT GREY manila file folder tab)
#
# Returns nothing.
When (/^I am in the "(.*?)" tab$/) do |tab|
  kaiki.get_ready
  @tab = tab
  @section = tab
  @subsection = nil
  factory0 =
    ApproximationsFactory.transpose_build(
    "//%s[contains(text(), '#{tab}')]",
    ['h2'])
  kaiki.find_approximate_element(factory0)
  @sec_type = "h3"
end

# KC and KFS all features

# Description: This step sets the variable @section to the given input so the
#              following steps after it, can look in a certain area of the page.
#
# Parameters:
#	  section - Area of the page you want to be in. (DARK GREY banners)
#
# Example:
#	  When I am in the "Document Overview" section
#
# Returns nothing.
When (/^I am in the "(.*?)" section$/) do |section|
  kaiki.get_ready
  @section = section
  @subsection = nil
  begin
    kaiki.find_approximate_element(["//h3[contains(text(), '#{section}')]"])
    @sec_type = "h3"
  rescue Capybara::ElementNotFound
    begin
      kaiki.find_approximate_element(["//span[contains(text(), '#{section}')]"])
      @sec_type = "span"
    rescue Capybara::ElementNotFound
      kaiki.find_approximate_element(["//tbody/tr/td[contains(text(), '#{section}')]"])
      @sec_type = "td"
    end
  end
end

# KC and KFS all features - will be used in the future

# Description: This step sets the variable @subsection to the given input so the
#              following steps after it, can look in a certain area of the page.
#
# Parameters:
#	  subsection - Area of the page you want to be in. (GREY banners)
#
# Example:
#	  When I am in the "Detail Information" subsection
#
# Returns nothing.
When (/^I am in the "(.*?)" subsection$/) do |subsection|
  kaiki.get_ready
  @subsection = subsection
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

# KC and KFS all features

# Description: This step clicks the show/hide on the specified tab
#
# Parameters:
#	  option – The option should contain show/hide.
#	  value  - Which tab is being toggled.
# 	extra – OPTIONAL - Placeholder for extraneous text that may be after the value.
#
# Example:
#	  When I click "Show" on the "Document Overview" tab
#
# Returns nothing.
When (/^I click "([^"]*)" (?:on the "([^"]*)" (?:tab|for "([^"]*)"))$/)         \
  do |option, tab, extra|

  kaiki.get_ready
  @tab = tab
  @section = tab
  @subsection = nil
  special_case = {
    "Future Action Requests" => {:link => "//a[contains(@href, 'RouteLog.do?showFuture')]",
                                 :frame =>"routeLogIFrame"}
  }
  if special_case.key?(tab)
    special_case.each do |key,value|
      if key == tab
        @xpath = value[:link]
        @frame = value[:frame]
      end
    end
    unless @frame.nil?
      kaiki.select_frame(@frame)
    end
    element = kaiki.find_approximate_element([@xpath])
    element.click
  elsif option == "Show"
    kaiki.show_tab(tab)
  elsif option == "Hide"
    kaiki.hide_tab(tab)
  else
    raise NotImplementedError
  end
  @sec_type = "h3"
end

# Description: This step clicks on the show/hide button for a section
#	             or subsection within a tab.
#
# Parameters:
#    option     - This is the action we want to perform.
#    section    - This is the section we want to show/hide.
#    subsection - OPTIONAL - This is the subsection we want to show/hide.
#    person     - OPTIONAL - This is the specific person/section we want to be under.
#
# Example:
#	  When I click "Show" on the "Additional Charges" section
#
# Returns nothing.
When (/^I click "([^"]*)"(?: on the| on) (?:"([^"]*)" section|"([^"]*)" subsection)(?:| under "([^"]*)")$/)\
  do |option, section, subsection, person|

  kaiki.get_ready

  section_hash = {"show" => "open #{section}", "hide" => "close #{section}"}
  subsection_hash = {"show" => "open #{subsection}", "hide" => "close #{subsection}"}
  if subsection
    action = subsection_hash[option.downcase]
  elsif section
    action = section_hash[option.downcase]
  end

  if person
# factory0 - KC Feat. 2 (Contacts)
    factory0 =
      ApproximationsFactory.transpose_build(
      "//h2[contains(., '#{@tab}')]/../../../../following-sibling::div/"       \
        "descendant::h3[contains(., '#{@section}')]/following-sibling::div/"   \
        "descendant::div[text()[contains(., '#{person}')]]/../../"             \
        "following-sibling::tr/descendant::div[text()[contains(., '#{subsection}')]]/%s",
        ['input'])
    approximate_xpath = factory0
    @element = kaiki.find_approximate_element(approximate_xpath)
  else
# factory0 - KC Feat. 1 (Key Personnel)
# factory0 - KC Feat. 7 (Key Personnel)
# factory0 - KC Feat. 8 (Key Personnel)
    factory0 =
      ApproximationsFactory.transpose_build(
      "//h2[contains(., '#{@tab}')]/../../../../following-sibling::div/"       \
        "descendant::h3[contains(., '#{@section}')]/following-sibling::"       \
        "%s/descendant::input[@title='#{action}']",
      ['table'],
      ['div'])
# factory1 - KFS PA004-01   (Create Requisition)
# factory1 - KFS PA004-0304 (Purchase Order)
    factory1 =
      ApproximationsFactory.transpose_build(
        "//h2[contains(text(), '#{@tab}')]/../../%s",
        ["../../following-sibling::div/descendant::div[text()[contains(., '#{section}')]]/input"],
        ["../../following-sibling::div/descendant::span[contains(text(), '#{section}')]/following-sibling::input"],
        ["following-sibling::tr/td/div[text()[contains(., '#{section}')]]'"])
# factory2 - KC Feat. 6 (Key Personnel)
    factory2 =
      ApproximationsFactory.transpose_build(
        "//td/div[contains(text(), '#{@tab}')]/../../%s",
        ["../../following-sibling::div/descendant::div[text()[contains(., '#{section}')]]/input"],
        ["../../following-sibling::div/descendant::span[contains(text(), '#{section}')]/following-sibling::input"],
        ["following-sibling::tr/td/div[text()[contains(., '#{section}')]]'"])
    approximate_xpath = factory0                                               \
                      + factory1                                               \
                      + factory2
    @element = kaiki.find_approximate_element(approximate_xpath)
  end
  @element.click
end

# KFS PA004-01 (Create Requisition)

# Description: This step clicks on the show/hide buttons specifically for the
#              Accounting Lines in PA004-05 Requisition page.
#
# Parameters:
#    subsection - This is the subsection we want to show/hide.
#    option     - This is the action we want to perform.
#
# Example:
#	  When I click "Show" on the Accounting Lines under the "Item1" subsection
#
# Returns nothing.
When (/^I click "([^"]*)" on Accounting Lines under the "([^"]*)" subsection$/)\
  do |option, subsection|

  kaiki.get_ready

  factory0 =
    ApproximationsFactory.transpose_build(
      "//h2[contains(text(), '#{@tab}')]/../../../.."                          \
      "/following-sibling::div/descendant::span[contains(text(), '#{@section}')]/../.." \
      "/following-sibling::tr/td[text()[contains(., '#{subsection}')]]/../following-sibling::tr" \
      "/descendant::%s[contains(@title, 'toggle')]",
      ['input'])
  approximate_xpath = factory0
  @element = kaiki.find_approximate_element(approximate_xpath)
  @element.click
end