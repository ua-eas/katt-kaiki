# Description: This is the file for the Key_Personnel page class and applies
#              to the key personnel page on the kuali coeus system.
#
# Original Date: 11 November 2013

class Key_Personnel < Kaiki::KC_Page::Base

  # Public: Defines the hashes inputs, selects and textareas for their
  #         respective fields that are contained on this page that are used
  #         in the current implemented tests.
  #
  # Returns the inputs, selects and textareas hashes.
  def page_fields
    inputs = {
      'full_name' => "input[@title='Full Name']",
      'first_name' => "input[@title='First Name']",
      'middle_name' => "input[@title='Middle Name']",
      'email_address' => "input[@title='Email Address']",
      'primary_title' => "input[@title='Primary Title']",
      'era_commons_user_name' => "input[@title='eRA Commons User Name']",
      'pager' => "input[@title='Pager']",
      'office_location' => "input[@title='Office Location']",
      'address_line_1' => "input[@title='Address Line 1']",
      'address_line_2' => "input[@title='Address Line 2']",
      'address_line_3' => "input[@title='Address Line 3']",
      'percentage_effort' => "input[@title='Percentage Effort']",
      'last_name' => "input[@title='Last Name']",
      'office_phone' => "input[@title='Office Phone']",
      'directory_title' => "input[@title='Directory Title']",
      'fax' => "input[@title='Fax']",
      'mobile' => "input[@title='Mobile']",
      'secondary_office_location' => "input[@title='Secondary Office Location']",
      'city' => "input[@title='City']",
      'county' => "input[@title='County']",
      'age_by_fiscal_year' => "input[@title='Age by Fiscal Year']",
      'education_level' => "input[@title='Education Level']",
      'major' => "input[@title='Major']",
      'visa_type' => "input[@title='Visa Type']",
      'office_location' => "input[@title='Office Location']",
      'school' => "input[@title='School']",
      'directory_department' => "input[@title='Directory Department']",
      'id_provided' => "input[@title='Id Provided']",
      'race' => "input[@title='Race']",
      'degree' => "input[@title='Degree']",
      'handicap_type' => "input[@title='Handicap Type']",
      'veteran_type' => "input[@title='Veteran Type']",
      'visa_code' => "input[@title='Visa Code']",
      'view_renewal_code' => "input[@title='Visa Renewal Date']",
      'year_graduated' => "input[@title='Year Graduated']",
      'primary_title' => "input[@title='Primary Title']",
      'id_verified' => "input[@title='Id Verified']",
      'degree_description' => "input[@title='* Degree Description']",
      'graduation_year' => "input[@title='* Graduation Year']",
      'unit_name' => "input[@title='* Unit Number']",
      'credit_for_award' => "input[@name='document.developmentProposalList[0].investigator[0].creditSplits[0].credit']",
      'f&a_revenue' => "input[@name='document.developmentProposalList[0].investigator[0].creditSplits[1].credit']"
    }

    selects = {
      'proposal_role' => "select[@title='Proposal Person Role Id']",
      'proposal_person_role_id' => "select[@name='document.developmentProposalList[0].proposalPersons[0].proposalPersonRoleId']",
      'state' => "select[@title='State']",
      'country' => "select[@title='Country']",
      'citizen_type' => "select[@title='Citzenship Type']",
      'degree_type' => "select[@title='* Degree Type']",
    }

    textareas = {

    }
    return inputs, selects, textareas
  end

  # Public: Defines the hash search_buttons_by_name and
  #         search_buttons_by_name_and_field for all the search buttons
  #         that are contained on this page.
  #
  # Returns the search_buttons_by_name
  def search_buttons
    search_buttons_by_name = {
      'employee' => 'methodToCall.performLookup.(!!org.kuali.kra.bo.KcPerson!!).(((personId:newPersonId))).((``)).((<>)).(([])).((**)).((^^)).((&&)).((//)).((~~)).(::::;;::::).anchor',
      'non-employee' => 'methodToCall.performLookup.(!!org.kuali.kra.bo.NonOrganizationalRolodex!!).(((rolodexId:newRolodexId))).((``)).((<>)).(([])).((**)).((^^)).((&&)).((//)).((~~)).(::::;;::::).anchor',
      'unit_name' => 'methodToCall.performLookup.(!!org.kuali.kra.bo.Unit!!).(((unitNumber:newProposalPersonUnit[0].unitNumber,unitName:newProposalPersonUnit[0].unitName))).((``)).((<>)).(([])).((**)).((^^)).((&&)).((//)).((~~)).(::::;;::::).anchor'
    }
    return search_buttons_by_name
  end

  # Public: Defines the hash show_hide_by_title for all the show/hide tabs
  #         that are contained on this page.
  #
  # Returns the show_hide_by_title hash.
  def show_hide_tabs
    show_hide_subs_by_title = {
      'person_details' => {'Show' => 'open Person Details',
                           'Hide' => 'close Person Details'},
      'extended_details' => {'Show' => 'open Extended Details',
                             'Hide' => 'close Extended Details'},
      'degrees' => {'Show' => 'open Degrees',
                    'Hide' => 'close Degrees'},
      'unit_details' => {'Show' => 'open Unit Details',
                         'Hide' => 'close Unit Details'},
      'open  (Incomplete) - This Questionnaire has been deactivated.' => {'Show' => 'open  (Incomplete) - This Questionnaire has been deactivated.',
                                                                          'Hide' => 'close  (Incomplete) - This Questionnaire has been deactivated.'}
    }
    return show_hide_subs_by_title
  end

  # Public: Defines the hashes that contain all of the checkboxes that are
  #         contained on this page.
  #
  # Returns checkboxes_by_title
  def checkboxes
    checkboxes_by_title = {
      'faculty' => 'Faculty',
      'is_handicapped' => 'Is Handicapped',
      'veteran' => 'Veteran',
      'has_visa' => 'Has Visa',
      'is_on_sabbatical' => 'Is on Sabbatical',
      'is_vacation_accrual' => 'Is Vacation Accrual'
    }
    return checkboxes_by_title
  end

  # Public: Defines the hashes for other buttons that are not search or
  #         show/hides on this page.
  #
  # Returns buttons_by_title, buttons_by_name, buttons_by_title_and_fields
  def other_page_buttons
    buttons_by_title = {
      'clear' => 'Clear Fields',
      'add_person' => 'Add Proposal Person',
      'recalculate' => 'Recalculate',
      'save' => 'save',
      'reload' => 'reload',
      'close' => 'close'
    }

    buttons_by_name = {
      'delete_selected' => 'methodToCall.deletePerson'
    }

    buttons_by_title_and_field = {
      'add' => {'Degrees' => 'Add a Degree',
                'Unit Details' => 'Add Unit'}
    }
    return buttons_by_title, buttons_by_name, buttons_by_title_and_field
  end

  # Public: Calls get_all_fields and modify_field. Then checks each
  #         all_fields array element (which should be a hash) to see if they
  #         contain mod_field as one of it's keys. If it does it calls
  #         set_approximate_field in the CapybaraDriver to find and
  #         fill in said field with the given value.
  #
  #         Raises a custom error "FieldDoesNotExistOnPage" if
  #         Capybara::ElementNotFound is raised by the CapybaraDriver,
  #         and the current page has no defined special case verify text method.
  #
  #         *** This method is only used for special fields that do not
  #             follow the generic xpath in Kaiki::Page::Base's fill_in_field.
  #
  # Parameters:
  #   field       - label of field
  #   value       - what is to be entered into the field
  #   line_number - possible line number the field may show up on
  #   subsection  - subsection of the page the field may appear in
  #
  # Returns nothing.
  def fill_in_field(field, value, line_number, subsection)
    all_fields = get_all_fields
    mod_field = modify_field(field)
    begin
      all_fields.each do |hash|
        if hash.key?(mod_field)
          if mod_field.eql?('proposal_role')
            kaiki.set_approximate_field(["//td[contains(., '#{@section}')]/../../../"\
            "following-sibling::div/descendant::#{hash[mod_field]}"], value)

          elsif subsection
            kaiki.set_approximate_field(["//h2[contains(text(), '#{@tab}')]"   \
            "/../../../../following-sibling::div/descendant::h3[contains(., '#{@section}')]/"\
            "following-sibling::table/descendant::div[text()[contains(., '#{subsection}')]]/"\
            "following-sibling::div/descendant::#{hash[mod_field]}"], value)

          else
            super
          end
        end
      end
    rescue Capybara::ElementNotFound
      super
    end
  end

  # Public: Fills out the credit split table on this page for however many
  #         rows are contained in the data table brought in.
  #
  # Parameters:
  #   division   - This field is used in two possible ways:
  #                1) If the "under ____" is used, division is the division
  #                   the person belongs to.
  #                2) If the "under ____" is not used, division is the name of
  #                   the person.
  #   name       - This is the name of the person to fill the fields for
  #   table      - This is the table of fields to be filled, using the following
  #                  syntax:
  #                    | field_name | value |
  #
  # Returns nothing.
  def credit_split(division, name, table)
    data = table.raw
    data.each do |key, value|
      if key.eql?("Credit for Award")
        data_column = 1
      elsif key.eql?("F&A Revenue")
        data_column = 2
      else
        data_column = nil
        raise NotImplementedError
      end
      if not data_column.eql?(nil)
        if division.eql?(name) || name.eql?(nil)
            xpath =
              "//td/strong[contains(text(),'#{division}')]"                    \
                "/../following-sibling::td[#{data_column}]"                    \
                "/div/strong/input"
            element = kaiki.find(:xpath, xpath)
            kaiki.highlight(:xpath, xpath)
            element.set(value)
        else
          xpath =
            "//tr/td/strong[contains(text(),'#{name}')]"                       \
              "/../../following-sibling::tr/td[contains(text(),'#{division}')]"\
              "/following-sibling::td[#{data_column}]/div/input"
          element = kaiki.find(:xpath, xpath)
          kaiki.highlight(:xpath, xpath)
          element.set(value)
        end
      end
    end
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
    buttons_by_title, buttons_by_name, buttons_by_title_and_field = other_page_buttons
    mod_button = button_name.downcase.strip.gsub(/\s/, '_')

    begin
      if buttons_by_title.key?(mod_button)
        kaiki.click_approximate_field(["//input[@title='#{buttons_by_title[mod_button]}']"])

      elsif buttons_by_name.key?(mod_button)
        kaiki.click_approximate_field(["//input[@name='#{buttons_by_name[mod_button]}']"])

      elsif buttons_by_title_and_field.key?(mod_button)
        title = buttons_by_title_and_field[mod_button][field]
        kaiki.click_approximate_field(["//input[@title='#{title}']"])

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
    show_hide_subs_by_title = show_hide_tabs
    mod_tab = tab_name.downcase.strip.gsub(/\s/, '_')

    if show_hide_subs_by_title.key?(tab_name)
      begin
        if person
          if action.eql?("Show")
            title = show_hide_subs_by_title[tab_name][action]
            kaiki.show_tab("//h2[contains(text(), '#{@tab}')]/../../../../"      \
            "following-sibling::div/descendant::h3[contains(., '#{person}')]/"   \
            "following-sibling::table/descendant::input[@title='#{title}']")

          elsif action.eql?("Hide")
            title = show_hide_subs_by_title[tab_name][action]
            kaiki.show_tab("//h2[contains(text(), '#{@tab}')]/../../../../"      \
            "following-sibling::div/descendant::h3[contains(., '#{person}')]/"   \
            "following-sibling::table/descendant::input[@title='#{title}']")

          end
        end
      rescue Capybara::ElementNotFound
        raise "ShowHideTabDoesNotExistOnPage"
      end
    else
      super
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
        name = search_buttons_by_name_and_field[mod_button][field]
        kaiki.click_approximate_field(["//input[@name='#{name}']"])
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