# Description: This is the file for the Budget_Versions class and applies to
#              the budget versions page on the kuali coeus system.
#
# Original Date: 11 November 2013

class Budget_Versions < Kaiki::KC_Page::Base

  # Public: Defines the hashes inputs, selects and textareas for their
  #         respective fields that are contained on this page that are used
  #         in the current implemented tests.
  #
  # Returns the inputs, selects and textareas hashes.
  def page_fields
    inputs = {
      'name' => "input[@name='newBudgetVersionName']"
    }

    selects = {
      'budget_status' => "select[@title='Budget Status']",
    }

    textareas = {

    }
    return inputs, selects, textareas
  end

  # Public: Defines the hash show_hide_by_title for all the show/hide tabs
  #         that are contained on this page.
  #
  # Returns the show_hide_by_title hash.
  def show_hide_tabs
    show_hide_by_title = {
      'budget_versions' => {'Show' => 'open Budget Versions (02/01/2014 - 01/31/2019)',
                            'Hide' => 'close Budget Versions (02/01/2014 - 01/31/2019)'}
    }
    return show_hide_by_title
  end

  # Public: Defines the hashes that contain all of the checkboxes that are
  #         contained on this page.
  #
  # Returns checkboxes_by_title
  def checkboxes
    checkboxes_by_title = {
      'final?' => 'Final?'
    }
    return checkboxes_by_title
  end

  # Public: Defines the hashes for other buttons that are not search or
  #         show/hides on this page.
  #
  # Returns buttons_by_title, buttons_by_alt, buttons_by_name_and_field
  def other_page_buttons
    buttons_by_title = {
      'save' => 'save',
      'reload' => 'reload',
      'close' => 'close'

    }
    buttons_by_alt = {
      'open' => 'open budget',
      'copy' => 'copy budget'
    }
    buttons_by_name_and_field = {
      'add' => {'Budget Versions' => 'methodToCall.addBudgetVersion',
                'Budget Periods' => 'methodToCall.addBudgetPeriod.anchorBudgetPeriodsTotals'},
      'delete' => {'Budget Periods' => 'methodToCall.deleteBudgetPeriod.line0.anchor11'}
    }
    return buttons_by_title, buttons_by_alt, buttons_by_name_and_field
  end

  # Public: First calls other_page_buttons and modify_field. Then checks each
  #         returned hash to see if any of them contain mod_button as a key.
  #         If it does it calls click_approximate_field in the CapybaraDriver
  #         to find and click said button.
  #
  #         Raises a custom error "ButtonDoesNotExistOnPage" if the specified
  #         button is not contained within the current page object.
  #
  # Parameters:
  #   button_name - button to be clicked
  #   field       - label of field adjacent to button is applicable
  #   line_number - possible line number the field may show up on
  #   subsection  - subsection of the page the field may appear in
  #
  # Returns nothing.
  def click_button(button_name, field, line_number, subsection)
    buttons_by_title, buttons_by_alt, buttons_by_name_and_field = other_page_buttons
    mod_button = modify_field(button_name)

    begin
      if buttons_by_title.key?(mod_button)
        kaiki.click_approximate_field(["//input[@title='#{buttons_by_title[mod_button]}']"])

      elsif buttons_by_alt.key?(mod_button)
        kaiki.click_approximate_field(["//input[@alt='#{buttons_by_alt[mod_button]}']"])

      elsif buttons_by_name_and_field.key?(mod_button)
        name = buttons_by_name_and_field[mod_button][field]
        name["line0"] = "line#{line_number.to_i-1}" if mod_button.eql?('delete') and name.include?('line0')
        kaiki.click_approximate_field(["//input[@name='#{name}']"])
      end
    rescue Capybara::ElementNotFound
      raise "ButtonDoesNotExistOnPage"
    end
  end

  # Public: First calls show_hide_tabs and modify_field. Then checks each
  #         returned hash to see if any of them contain mod_button as a key.
  #         If it does it calls click_approximate_field in the CapybaraDriver
  #         to find and click said button.
  #
  #         Raises a custom error "ShowHideTabDoesNotExistOnPage" if the
  #         show or hide method in CapybaraDriver raises
  #         Capybara::ElementNotFound.
  #
  # Parameters:
  #   tab_name   - name of the tab to be clicked
  #   action     - either show or hide
  #   person     - person the section or subsection may appear under
  #
  # Returns nothing.
  def click_show_hide(tab_name, action, person=nil)
    show_hide_by_title = show_hide_tabs
    tab_name = modify_field(tab_name)

    begin
      if show_hide_tabs.key?(tab_name)
        if action.eql?("Show")
          name = show_hide_by_title[tab_name][action]
          kaiki.show_tab("//input[contains(@title, '#{name}')]")
        elsif action.eql?("Hide")
          name = show_hide_by_title[tab_name][action]
          kaiki.hide_tab("//input[contains(@title, '#{name}')]")
        end
      end
    rescue Capybara::ElementNotFound
      raise "ShowHideTabDoesNotExistOnPage"
    end
  end

  # Public: First calls search_buttons and modify_field. Then checks each
  #         returned hash to see if any of them contain mod_button as a key.
  #         If it does it calls click_approximate_field in the CapybaraDriver
  #         to find and click said button.
  #
  #         Raises a custom error "SearchButtonDoesNotExistOnPage" if the
  #         specified button is not contained within the current page object.
  #
  # Parameters:
  #   button_name - button to be clicked
  #   field       - label of field adjacent to button is applicable
  #   line_number - possible line number the field may show up on
  #   subsection  - subsection of the page the field may appear in
  #
  # Returns nothing.
  def click_search_button(button_name, field, line_number, subsection)
    search_buttons_by_name, search_buttons_by_name_and_field = search_buttons
    mod_button = modify_field(button_name)

    begin
      if search_buttons_by_name.key?(mod_button)
        kaiki.click_approximate_field(["//input[@name='#{search_buttons_by_name[mod_button]}']"])

      elsif search_buttons_by_name_and_field.key?(mod_button)
        @name = search_buttons_by_name_and_field[mod_button][field]
        kaiki.click_approximate_field(["//input[@name='#{@name}']"])
      end
    rescue Capybara::ElementNotFound
      raise "SearchButtonDoesNotExistOnPage"
    end
  end

  # Public: First calls checkboxes and modify_field. Then checks each
  #         returned hash to see if any of them contain mod_button as a key.
  #         If it does it calls click_approximate_field in the CapybaraDriver
  #         to find and click said button.
  #
  #         Raises a custom error "ButtonDoesNotExistOnPage" if the specified
  #         button is not contained within the current page object.
  #
  # Parameters:
  #   option     - check or uncheck
  #   check_name - name of the checkbox to click
  #   field       - label of field adjacent to button is applicable
  #   line_number - possible line number the field may show up on
  #   subsection  - subsection of the page the field may appear in
  #
  # Returns nothing.
  def check_uncheck_box(option, check_name, field, line_number, subsection)
    checkboxes_by_title = checkboxes
    mod_check = modify_field(check_name)

    begin
      if checkboxes_by_title.key?(mod_check)
        if option.eql?("check")
          kaiki.check_approximate_field(["//h2[contains(text(), '#{@tab}')]"     \
            "/../../../../following-sibling::div/descendant::h3[contains(., '#{@section}')]/"\
            "following-sibling::table/descendant::td[contains(text(), '#{field}')]/"\
            "following-sibling::td/div/input[@title='#{checkboxes_by_title[mod_check]}']"])
        elsif option.eql?("uncheck")
          kaiki.uncheck_approximate_field(["//h2[contains(text(), '#{@tab}')]"   \
            "/../../../../following-sibling::div/descendant::h3[contains(., '#{@section}')]/"\
            "following-sibling::table/descendant::td[contains(text(), '#{field}')]/"\
            "following-sibling::td/div/input[@title='#{checkboxes_by_title[mod_check]}']"])
        end
      end
    rescue Capybara::ElementNotFound
      raise "CheckboxDoesNotExistOnPage"
    end
  end
end