# Description: This file holds all of the step definitions pertaining
#              to navigating the browser webpage; such as clicking buttons and
#              links and moving to different parent tabs.
#
# Original Date: August 20th, 2011

# KC & KFS all features

# Description: This step sets the focus to the outermost page content.
#
# Returns nothing.
Given (/^I am up top$/) do
  kaiki.switch_default_content
end

# KC & KFS all features

# Description: This step opens the given parent tab at the top of the page.
#
# Parameters:
#   sys_tab - The title of the system tab to be opened.
#
# Example: (taken from KC 1_proposal_new)
#   Given I am on the "Central Admin" system tab
#
# Returns nothing.
Given (/^I am on the "([^"]*)" system tab$/) do |sys_tab|
  kaiki.pause
  kaiki.switch_default_content
  kaiki.find_approximate_element(["//a[@title='#{sys_tab}']"]).click
end

# KC all features

# Description: This step opens the given document tab at the top of the
#              document.
#
# Parameters:
#   tab - The title of the document tab to be opened.
#
# Example (taken from KC 1_proposal_new)
#   When I am on the "Key Personnel" document tab
#
# Returns nothing.
When (/^I am on the "([^"]*)" document tab$/) do |tab|
  kaiki.get_ready
  kaiki.find_approximate_element(["//input[@alt='#{tab}']"]).click
end

# KC all features

# Description: This step clicks the given portal link on the page. This is the
#              blue circular button with the white + on it next to its name.
#
# Parameters:
#   link - The portal link to be clicked.
#
# Example: (taken from KC 1_proposal_new)
#   When I click the "Proposal Development" portal link
#
# Returns nothing.
When (/^I (?:click|click the) "([^"]*)" portal link$/) do |link|
  kaiki.get_ready
  element = kaiki.find_approximate_element(
    ["//td[contains(text(), '#{link}')]/following-sibling::td/a[1]"])
  element.click
end

# Description: This step clicks on the button with the given name.
#
# Parameters:
#   item       - The name of the item to be clicked.
#   field      - OPTIONAL - The name of the field a button is associated with.
#   subsection - OPTIONAL - The subsection of the page the button is in.
#
# Example: (taken from 7_proposal_renewal)
#   And I click the "Add" button in the "Unit Details" subsection
#
# Returns nothing.
When (/^I (?:click|click the) "(.*?)" (?:button|(?:on|to) "(.*?)")(?:| (?:under|in) the "(.*?)" subsection)$/)\
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
      "refresh account summary",
      "refresh from account lines",
      "fyi"
    ]
  specific_buttons_hash = {
    "get document"        => "//input[@name='methodToCall.#{button.downcase.gsub(/\s/, '_')}']",
    "yes"                 => "//input[@name='methodToCall.processAnswer.button0']",
    "no"                  => "//input[@name='methodToCall.processAnswer.button1']",
    "add person"          => "//input[contains(@name,'methodToCall.insertProposalPerson')]",
    "recalculate"         => "//input[contains(@name,'methodToCall.recalculate')]",
    "turn on validation"  => "//input[@name='methodToCall.activate']",
    "document search"     => "/html/body/div[5]/div/div/a[3]",
    "document link"       => "/html/body/form/table/tbody/tr/td[2]/table/tbody/tr/td/a",
    "time & money"        => "//input[@name='methodToCall.timeAndMoney']",
    "return to award"     => "//input[@name='methodToCall.returnToAward']",
    "edit"                => "//input[@name='methodToCall.editOrVersion']",
    "delete selected"     => "//input[@name='methodToCall.deletePerson']",
    "open proposal"       => "//img[@title = '#{button}']",
    "create new"          => "//img[@alt = '#{button.downcase}']",
    "copy proposal"       => "//input[@name='methodToCall.copyProposal.anchorCopytoNewDocument']",
    "unlock selected"     => "//input[@name='methodToCall.unlockSelected.anchorFundedAwards']",
    "collapse all"        => "//input[@name='methodToCall.hideAllTabs']",
    "expand all"          => "//input[@name='methodToCall.showAllTabs']",
    "apply"               => "//input[contains(@name, 'methodToCall.apply#{field}')]",
    "delete"              => "//th[contains(text(), '#{field}')]/following-sibling::td/div/input[contains(@name, 'methodToCall.delete')]",
    "open existing"       => "//input[@name='methodToCall.openExisting']",
    "add final deposit"   => "//input[@name='methodToCall.addFinalDeposit']",
    "return selected"     => "//input[@title='Return selected results']",
    "send ad hoc request" => "//input[@title='Send AdHoc Requests']"
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
            "following-sibling::div/descendant::%s[contains(@title, 'Add Unit')]",
            ['input'])
# factory2 - KFS PVEN002-01 (Foreign PO Vendor)
        vendor_item_locator = vendor_page_field_location(button, subsection)
        factory2 =
          ApproximationsFactory.transpose_build(
            "//h2[contains(., '#{@tab}')]/../../../../following-sibling::div/" \
            "descendant::tr[contains(., '#{subsection}')]/%s",
            ["following-sibling::tr/td/#{vendor_item_locator}"],
            ["../../following-sibling::table/descendant::#{vendor_item_locator}"])
# factory3 - KFS DI003-01  (Initiate DI)
# factory3 - KFS PRE001-01 (Initiate Pre-Encumbrance)
# factory3 - KFS TF001-01  (Initiate Transfer of Funds)
        factory3 =
        ApproximationsFactory.transpose_build(
          "//h2[contains(., '#{@tab}')]/../../../../following-sibling::"       \
          "div/descendant::span[contains(., '#{@section}')]/../../"            \
          "following-sibling::tr/td[contains(text(), '#{subsection}')]/../"    \
          "following-sibling::tr/descendant::%s[contains(@title, 'Add')]",
          ['input'])
        @approximate_xpath = factory0                                          \
                           + factory1                                          \
                           + factory2                                          \
                           + factory3
      else
# factory0 - KC  Feat. 1  (Special Review)
# factory0 - KC  Feat. 2  (Award, Commitments, Time & Money)
# factory0 - KC  Feat. 3  (Special Review)
# factory0 - KC  Feat. 7  (Special Review)
# factory0 - KC  Feat. 7  (Budget Versions)
# factory0 - KFS DV001-01 (Check ACH)
        factory0 =
          ApproximationsFactory.transpose_build(
            "//h2[contains(., '#{@tab}')]/../../../../following-sibling::div/" \
            "descendant::%s/descendant::input[contains(@title, 'Add')]",
            ["h3[contains(., '#{@section}')]/following-sibling::table"],
            ["td[contains(., '#{@section}')]/../following-sibling::tr"],
            ["span[contains(., '#{@section}')]/../../following-sibling::tr"])
# factory1 - KFS PA004-01   (Create Requisition)
# factory1 - KFS PA004-0304 (Purchase Order)
# factory1 - KFS CASH001-01 (Open Cash Drawer)
# factory1 - KFS DV001-01   (Check ACH)
# factory1 - KC Feat. 4     (Time and Money, Commitments)
# factory1 - KC Feat. 6     (Special Review)
        factory1 =
          ApproximationsFactory.transpose_build(
            "//%s[contains(@name, 'methodToCall.add#{field}')]",
            ['input'])
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
      factory0 =
        ApproximationsFactory.transpose_build(
          "//%s[contains(text(), '#{field}')]"                                 \
            "/following-sibling::td/div/input[contains(@alt, 'open budget')]",
          ['td'],
          ['th'])
      approximate_xpath = factory0
      @element = kaiki.find_approximate_element(approximate_xpath)
# KFS PA004-0304 (Purchase Order)     - Continue
# KFS PA004-06   (Vendor Credit Memo) - Continue
# KC  Feat. 3     (Proposal Actions)   - continue
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
# KFS SET001-01 (Initiate SET)
    when "copy"
      if subsection
        approximate_xpath =
          ApproximationsFactory.transpose_build(
          "//h2[contains(., '#{@tab}')]/../../../../following-sibling::"       \
          "div/descendant::span[contains(., '#{@section}')]/../../"            \
          "following-sibling::tr/td[contains(text(), '#{subsection}')]/../"    \
          "following-sibling::tr/descendant::%s[contains(@title, 'Copy')]",
          ['input'])
        @element = kaiki.find_approximate_element(approximate_xpath)
      end
    else
      raise "NotImplementedError"
    end
  end
  @element.click
end

# Public: This method contains an array of the button titles that are
#         interacted with. This is necessary because certain button titles are
#         case sensitive.
#
# Parameters:
#   button_name - The title of the button to be clicked. This is not case
#                 sensitive.
#
# Example: (used in step 'When I (?:click|click the) "(.*?)" (?:button|(?:on|to) "(.*?)")(?:| (?:under|in) the "(.*?)" subsection)')
#   item = button_title_match(button)
#
# Returns the case sensitive button name to be used. (String)
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

# Description: This step clicks the radio button next to the given option.
#
# Parameters:
#   field      - The name of the label next to the radio button.
#   subsection - OPTIONAL - subsection of the page the radio should be in.
#
# Example: (taken from KC 3_proposal_continuation)
#   And I click the "Generate a new Institutional Proposal" radio button
#
# Returns nothing.
When (/^I click the "([^"]*)" radio button(?:| (?:under|in) the "(.*?)" subsection)$/)\
  do |field, subsection|

  kaiki.get_ready
# factory0 - KFS PA004-01 (Create Requisition)
# factory0 - KC  Feat. 8  (Proposal Actions)
  factory0 =
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

# Description: This step locates and clicks the link on the page.
#
# Parameters:
#   link - The text of the link to be clicked.
#
# Example: (taken from PA004-01)
#   When I click the "Requisition" link
#
# Returns nothing.
When (/^I (?:click|click the) "([^"]*)" link$/) do |link|
  kaiki.get_ready
  approximate_xpath = [
    "//a[@title = '#{link}']",
    "//a/font[contains(.,'#{link}')]"
    ]
  kaiki.find_approximate_element(approximate_xpath).click
end


# KFS BAT001-01 (Batch)

# Description: This step clicks the button on the page if the specified message
#              is not displayed.
#
# Parameters:
#   button  - The name of the button to be clicked.
#   message - The conditional message to check for.
#
# Example: (taken from BAT001-01)
#   And I click the "Continue" button if the "There are no payments that match your selection for format process." message is not displayed
#
# Returns nothing.
When (/^I click the "(.*?)" button if the "(.*?)" message is not displayed$/)   \
  do |button, message|

  kaiki.get_ready
  kaiki.wait_for(:xpath, "//div[@class='left-errmsg']")
  element = kaiki.find(:xpath, "//div[@class='left-errmsg']")
  unless element.text.include?(message)
    steps %{
      And I click the "#{button}" button
    }
  end
end

# Not used currently, but could be eventually

# Description: This step clicks the button on the page if the specified message
#              is displayed.
#
# Parameters:
#   button  - The name of the button to be clicked.
#   message - The conditional message to check for.
#
# Example: This step is not used in any current feature, though could be used in
#          PA004-05 if the test needs to be run a second time using the same PO
#          number.
#   When I click the "Yes" button if the "" message is displayed
#
# Returns nothing.
When (/^I click the "(.*?)" button if the "(.*?)" message is displayed$/)   
  do |button, message|

  kaiki.get_ready
  element = kaiki.find(:xpath, "//*[text()[contains(., '#{message}')]]")
  if element.text.include?(message)
    steps %{
      And I click the "#{button}" button
    }
  end  
end

# Public: This step set the pause time back to 0.5 seconds.
#
# Returns nothing.
When (/^I am fast$/) do
  kaiki.log.debug "I am fast (pause_time = #{kaiki.default_pause_time})"
  kaiki.pause_time = kaiki.default_pause_time
end

# Public: This step increases the pause time by 4 seconds by default, but can
#         also increase the pause tiem by a specified amount.
#
# Parameters:
#   how_much - placeholder for conditional "a lot" text
#
# Returns nothing.
When (/^I slow down(?:| by (.*?))$/) do |how_much|
  if how_much == "a lot"
    kaiki.log.debug "I slow down (pause_time = #{kaiki.pause_time + 10})"
    kaiki.pause_time += 10
  elsif how_much == nil
    kaiki.log.debug "I slow down (pause_time = #{kaiki.pause_time + 4})"
    kaiki.pause_time += 4
  else
    kaiki.log.debug "I slow down (pause_time = #{kaiki.pause_time + how_much.to_f})"
    kaiki.pause_time += how_much.to_f
  end
end

# Public: Locates and clicks the link on the page, and must be under the
#         specified heading.
#
# Parameters:
#   link    - name of the link to click
#   heading - name of the tab to look under.
#
# Example: (taken from @KFSI5460-01-09)
#   When I click the "Receiving" link under the "Transactions" heading
#
# Returns nothing.
When(/^I (?:click|click the) "(.*?)" link under the "(.*?)" heading$/) do |link, heading|
  kaiki.get_ready
  approximate_xpath = [
    "//h2[text()[contains(.,'#{heading}')]]/../../following-sibling::div/descendant::a[@title = '#{link}']",
    ]
  kaiki.find_approximate_element(approximate_xpath).click
end

# Description: Opens the current user's action list
#
# Returns nothing.
When (/^I open my Action List$/) do
  kaiki.pause
  kaiki.switch_default_content
  kaiki.click_approximate_field(["//a[@class='portal_link' and @title='Action List']"])
end

# Description: Makes calls to the steps that open the current user's action
#              list and waits for the most recent docsument to appear.
#
# Returns nothing.
When (/^I open my Action List, refreshing until that document appears$/) do
  steps %{
    When I open my Action List
    And  I wait for that document to appear in my Action List
  }
end

# Description: Clicks the refresh button in the user's action list until
#              the most recent document appears
#
# Returns nothing.
When (/^I wait for that document to appear in my Action List$/) do
  kaiki.get_ready
  doc_nbr = kaiki.record[:document_number]
  attempts  = 8
  wait_time = 2

  loop do
    break if kaiki.has_selector?(:xpath, "//a[contains(text(), '#{doc_nbr}')]")
    raise Capybara::ElementNotFound if attempts <= 0
    attempts -= 1
    puts "#{attempts} retries left... #{Time.now}"
    kaiki.click_approximate_field(["//input[@alt='refresh']"])
    kaiki.pause(wait_time)
  end
end

# Description: Clicks a button and fills in a reason for buttons where
#              applicable.
#
# Example:
#   When I click "disapprove" with reason "Don't leave a doc hanging."
#
# Returns nothing.
When (/^I click "([^"]*)" with reason "([^"]*)"$/) do |link, reason|
  if ['disapprove'].include?(link)
    kaiki.click_approximate_field(["//input[@title='#{link}']"])
  end
  kaiki.set_approximate_field(["//*[@name='reason']"], reason)
  kaiki.pause(5)
  kaiki.click_approximate_field(["//input[@name='methodToCall.processAnswer.button0']"])
end
