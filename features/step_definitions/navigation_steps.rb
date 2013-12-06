# Description: This file holds all of the step_definitions pertaining
#              to navigating the browser webpage; i.e. clicking buttons and
#              links, moving to different parent tabs and toggling Show/Hide
#              tabs.
#
# Original Date: August 20th, 2011

# KC & KFS all features

# Description: Starts up the video if the test is being run headless and then
#         switches focus to the outermost page content.
#
# Returns nothing.
Given(/^I am up top$/) do
  kaiki.switch_default_content
end

# KC & KFS all features

# Description: Changes to the given parent tab at the top of the page
#
# Parameters:
#   sys_tab - title of tab to be switched to
#
# Returns nothing.
Given(/^I am on the "([^"]*)" system tab$/) do |sys_tab|
  kaiki.pause
  kaiki.switch_default_content
  kaiki.find_approximate_element(["//a[@title='#{sys_tab}']"]).click
end

# KC  all features

# Description: Changes to the given child tab at the top of the document
#
# Parameters:
#   tab - title of tab to be switched to
#
# Returns nothing.
When(/^I am on the "([^"]*)" document tab$/) do |tab|
  kaiki.get_ready
  kaiki.find_approximate_element(["//input[@alt='#{tab}']"]).click
end

# KC all features

# Description: Clicks the appropriate portal link on the page
#
# Parameters:
#   link - Portal link to be clicked
#
# Returns nothing.
When(/^I (?:click|click the) "([^"]*)" portal link$/) do |link|
  kaiki.get_ready
  element = kaiki.find_approximate_element(
    ["//td[contains(text(), '#{link}')]/following-sibling::td/a[1]"])
  element.click
end

# Description: Takes the name of the button and clicks on the button with that name
#
# Parameters:
#   item  - name of the item to be clicked
#   field - name of the field a particular button/link associated with said
#           field may have
#   subsection - subsection of the page the radio should be in
#
# Returns nothing.
# Modified the buttons to all use find_approximate_element so that highlighting works
When(/^I (?:click|click the) "(.*?)" (?:button|(?:on|to) "(.*?)")(?:| (?:under|in) the "(.*?)" subsection)$/)\
  do |button, field, subsection|

  kaiki.get_ready

  unless field == nil
    field = field.gsub(/\s/,'') unless button.downcase == "open"
    field = field.chop
  end
  item = button_title_match(button)
  downcase_alt_buttons = [
      "return to proposal",
      "refresh",
      "refresh account summary"
    ]
  specific_buttons_hash = {
    "get document"       => "//input[@name='methodToCall.#{button.downcase.gsub(/\s/, '_')}']",
    "yes"                => "//input[@name='methodToCall.processAnswer.button0']",
    "no"                 => "//input[@name='methodToCall.processAnswer.button1']",
    "add person"         => "//input[contains(@name,'methodToCall.insertProposalPerson')]",
    "recalculate"        => "//input[contains(@name,'methodToCall.recalculate')]",
    "turn on validation" => "//input[@name='methodToCall.activate']",
    "document search"    => "/html/body/div[5]/div/div/a[3]",
    "document link"      => "/html/body/form/table/tbody/tr/td[2]/table/tbody/tr/td/a",
    "time & money"       => "//input[@name='methodToCall.timeAndMoney']",
    "return to award"    => "//input[@name='methodToCall.returnToAward']",
    "edit"               => "//input[@name='methodToCall.editOrVersion']",
    "delete selected"    => "//input[@name='methodToCall.deletePerson']",
    "open proposal"      => "//img[@title = '#{button}']",
    "create new"         => "//img[@alt = '#{button.downcase}']",
    "copy proposal"      => "//input[@name='methodToCall.copyProposal.anchorCopytoNewDocument']",
    "unlock selected"    => "//input[@name='methodToCall.unlockSelected.anchorFundedAwards']",
    "collapse all"       => "//input[@name='methodToCall.hideAllTabs']",
    "apply"              => "//input[contains(@name, 'methodToCall.apply#{field}')]",
    "delete"             => "//th[contains(text(), '#{field}')]/following-sibling::td/div/input[contains(@name, 'methodToCall.delete')]",
    "open existing"      => "//input[@name='methodToCall.openExisting']",        
    "add final deposit"  => "//input[@name='methodToCall.addFinalDeposit']"      
    }

  if not item.eql?(nil)
    @element = kaiki.find_approximate_element(["//input[@title='#{item}']"])
  elsif downcase_alt_buttons.include?(button.downcase)
    factory0 =
      ApproximationsFactory.transpose_build(
        "//input[%s]",
        ["@alt='#{button.downcase}'"],
        ["contains(@alt, '#{button}')"])
    approximate_xpath = factory0
    @element = kaiki.find_approximate_element(approximate_xpath)
  elsif specific_buttons_hash.key?(button.downcase)
    @element = kaiki.find_approximate_element([specific_buttons_hash[button.downcase]])
  else
    case button.downcase
    when 'add'
      if subsection
# factory0 - KFS PA004-0304 (Purchase Order)
        factory0 =
          ApproximationsFactory.transpose_build(
            "//h2[contains(., '#{@tab}')]/../../../../following-sibling::"     \
            "div/descendant::%s/descendant::tr[contains(., '#{subsection}')]/" \
            "following-sibling::tr/descendant::input[contains(@title, 'Insert')]",
            ["h3[contains(., '#{@section}')]/following-sibling::table"],
            ["span[contains(., '#{@section}')]/../../following-sibling::tr"])
# factory1 - KC Feat. 7 (Key Personnel)
        factory1 =
          ApproximationsFactory.transpose_build(
            "//h2[contains(., '#{@tab}')]/../../../../following-sibling::"     \
            "div/descendant::h3[contains(., '#{@section}')]/"                  \
            "following-sibling::table/descendant::div[text()[contains(., '#{subsection}')]]/"\
            "following-sibling::div/descendant::%s[contains(@title, 'Add Unit')]",\
            ['input'])
# factory2 - KFS DI003-01 (Initiate DI)
# factory2 - KFS PRE001-01 (Initiate Pre-Encumbrance)
# factory2 - KFS TF001-01  (Initiate Transfer of Funds)
        factory2 =                                                              
        ApproximationsFactory.transpose_build(
          "//h2[contains(., '#{@tab}')]/../../../../following-sibling::"       \
          "div/descendant::span[contains(., '#{@section}')]/../../"            \
          "following-sibling::tr/td[contains(text(), '#{subsection}')]/../"    \
          "following-sibling::tr/descendant::%s[contains(@title, 'Add')]",
          ['input'])                                                            
        @approximate_xpath = factory0                                          \
                           + factory1                                          \
                           + factory2
      else
# factory0 - KC Feat. 1 (Special Review)
# factory0 - KC Feat. 2 (Award, Commitments, Time & Money)
# factory0 - KC Feat. 3 (Special Review)
# factory0 - KC Feat. 7 (Special Review)
# factory0 - KC Feat. 7 (Budget Versions)
        factory0 =
          ApproximationsFactory.transpose_build(
            "//%s[contains(@name, 'methodToCall.add#{field}')]",
            ['input'])
# factory1 - KFS PA004-01   (Create Requisition)
# factory1 - KFS PA004-0304 (Purchase Order)
# factory1 - KC Feat. 4     (Time and Money, Commitments)
# factory1 - KC Feat. 6     (Special Review)
        factory1 =
          ApproximationsFactory.transpose_build(
            "//h2[contains(., '#{@tab}')]/../../../../following-sibling::div/" \
            "descendant::%s/descendant::input[contains(@title, 'Add')]",
            ["h3[contains(., '#{@section}')]/following-sibling::table"],
            ["span[contains(., '#{@section}')]/../../following-sibling::tr"])
        @approximate_xpath = factory0                                          \
                           + factory1
      end
      @element = kaiki.find_approximate_element(@approximate_xpath)
    when 'open'
# KC Feat. 1 (Budget Versions)
# KC Feat. 3 (Budget Versions)
# KC Feat. 4 (Search Page (Award Lookup))
# KC Feat. 7 (Budget Versions)
# KC Feat. 8 (Budget Versions)
      approximate_xpath =
        ApproximationsFactory.transpose_build(
          "//%s[contains(text(), '#{field}')]"                                 \
            "/following-sibling::td/div/input[contains(@alt, 'open budget')]",
          ['td'],
          ['th'])
      @element = kaiki.find_approximate_element(approximate_xpath)
# KFS PA004-0304 (Purchase Order)     - Continue
# KFS PA004-06   (Vendor Credit Memo) - Continue
# KC Feat. 3     (Proposal Actions)   - continue
    when 'continue'
      if kaiki.application.eql?("kfs")
        button = "Continue"
      else
        button = "continue"
      end
     approximate_xpath = [                                                      
      "//input[@title='#{button}']",
      "//input[@name='methodToCall.continueFormat']"
      ]
      @element = kaiki.find_approximate_element(approximate_xpath)
    else
      raise NotImplementedError
    end
  end
  @element.click
end

# Public: Contains an array which holds all of the button we interact with by
#         their title. Certain button titles are cased in certain ways.
#
# Parameters:
#   button_name - title of the button being clicked
#
# Returns the buttons name to be used.
def button_title_match(button_name)
  title_buttons =
    [
      "create_new",
      "approve",
      "cancel",
      "disapprove",
      "search",
      "submit",
      "close",
      "reload",
      "Calculate",
      "blanket approve",
      "save",
      "clear",
      "Print",
      "Submit To Sponsor",
      "Clear all tax",
      "begin format",                                                            
      "Open Cash Drawer",                                                        
      "create"                                                                   
    ]
  title_buttons.each do |value|
    if value.casecmp(button_name) == 0
      return value
    end
  end
  return nil
end

# Description: Selects the radio button next to the option that is given by
#         using the approximation factory to find the xpath to the radio
#         button.
#
# Parameters:
#   field      - name of the label next to the radio button
#   subsection - subsection of the page the radio should be in
#
# Returns nothing.
When (/^I click the "([^"]*)" radio button(?:| (?:under|in) the "(.*?)" subsection)$/)\
  do |field, subsection|

  kaiki.get_ready
# factory0 - KFS PA004-01 (Create Requisition)
# factory0 - KC  Feat. 8  (Proposal Actions)
  factory0=
    ApproximationsFactory.transpose_build(
    "//h2[contains(., '#{@tab}')]/../../../../following-sibling::div/"         \
      "descendant::h3[contains(., '#{@section}')]/following-sibling::table/"   \
      "descendant::%s[contains(@title, '#{field}')]",
      ['input'])
# factory 1 - KC Feat. 3 (Proposal Actions)
  factory1 =
    ApproximationsFactory.transpose_build(
      "//h2[contains(., '#{@tab}')]/../../../../following-sibling::div/"       \
      "descendant::h3[contains(., '#{@section}')]/following-sibling::table/"   \
      "descendant::td[contains(text(), '#{field}')]/preceding-sibling::th/%s",
      ['input'])
  approximate_xpath = factory0                                                 \
                    + factory1
  element = kaiki.find_approximate_element(approximate_xpath)
  button_type = element[:type]
  kaiki.click_approximate_field(approximate_xpath, button_type)
end

# KFS all features

# Description: Locates and clicks the link on the page
#
# Parameters:
#   link - name of the link to click
#
# Returns nothing.
When(/^I (?:click|click the) "([^"]*)" link$/) do |link|
  kaiki.get_ready
  kaiki.find_approximate_element(["//a[@title='#{link}']"]).click
end
