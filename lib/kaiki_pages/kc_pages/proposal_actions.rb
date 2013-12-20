# Description: This is the file for the Proposal_Actions class and applies
#              to the proposal actions page on the kuali coeus system.
#
# Original Date: 11 November 2013

class Proposal_Actions < Kaiki::KC_Page::Base

  # Public: Defines the hashes inputs, selects and textareas for their
  #         respective fields that are contained on this page that are used
  #         in the current implemented tests.
  #
  # Returns the inputs, selects and textareas hashes.
  def page_fields
    inputs = {
      'link_child_proposal' => "input[@title='Proposal Number']",
      'lead_unit' => "input[@title='Lead Unit']",
      'questionnaires' => "input[@title='Questionnaires?']",
      'person' => "input[@title='Principal Name']",
      'namespace_code' => "input[@title='Namespace Code']",
      'name' => "input[@title='Name']"
    }

    selects = {
      'link_budget_type' => "select[@title='Hierarchy Budget Type']",
      'action_requested' => "select[@title='newAdHocRoutePerson.actionRequested']"
    }

    textareas = {

    }
    return inputs, selects, textareas
  end

  #
  #
  #
  def search_buttons
    search_buttons_by_name = {
      'person' => {'Current Report' => 'methodToCall.performLookup.(!!org.kuali.kra.bo.KcPerson!!).(((personId:reportHelperBean.personId))).((`reportHelperBean.personId:personId`)).((<>)).(([])).((**)).((^^)).((&&)).((//)).((~~)).(::::;;::::).anchorPrintForms:PrintReports',
                   'Pending Report' => 'methodToCall.performLookup.(!!org.kuali.kra.bo.KcPerson!!).(((personId:reportHelperBean.personId))).((`reportHelperBean.personId:personId`)).((<>)).(([])).((**)).((^^)).((&&)).((//)).((~~)).(::::;;::::).anchorPrintForms:PrintReports',
                   'Person Requests' => 'methodToCall.performLookup.(!!org.kuali.rice.kim.bo.Person!!).(((principalName:newAdHocRoutePerson.id,name:newAdHocRoutePerson.name))).((`newAdHocRoutePerson.id:principalName`)).((<>)).(([])).((**)).((^^)).((&&)).((//)).((~~)).(::::;;::::).anchor17'},
      'lead unit' => 'methodToCall.performLookup.(!!org.kuali.kra.bo.Unit!!).(((unitNumber:copyCriteria.leadUnitNumber))).((``)).((<>)).(([])).((**)).((^^)).((&&)).((//)).((~~)).(::::;;::::).anchorCopytoNewDocument'
    }

    return search_buttons_by_name
  end

  # Public: Defines the hash show_hide_by_title for all the show/hide tabs
  #         that are contained on this page.
  #
  # Returns the show_hide_by_title hash.
  def show_hide_tabs
    show_hide_by_title = {
    'data_validation' => {'Show' => 'open Data Validation',
                          'Hide' => 'close Data Validation'},
    'proposal_hierarchy' => {'Show' => 'open Proposal Hierarchy',
                             'Hide' => 'close Proposal Hierarchy'},
    'print' => {'Show' => 'open Print',
                'Hide' => 'close Print'},
    'copy_to_new_document' => {'Show' => 'open Copy to New Document',
                               'Hide' => 'close Copy to New Document'},
    'route_log' => {'Show' => 'open Route Log',
                    'Hide' => 'close Route Log'},
    'ad_hoc_recipients' => {'Show' => 'open Ad Hoc Recipients',
                            'Hide' => 'close Ad Hoc Recipients'}

    }
    return show_hide_by_title
  end

  # Public: Defines the hashes that contain all of the checkboxes that are
  #         contained on this page.
  #
  # Returns checkboxes_by_title
  def checkboxes
    checkboxes_by_title = {
      'budget?' => 'Budget?',
      'attachments?' => 'Attachments?',
      'questionaires?' => 'Questionnaires?'
    }
    return checkboxes_by_title
  end

  # Public: Defines the hashes for other buttons that are not search or
  #         show/hides on this page.
  #
  # Returns buttons_by_title, buttons_by_alt, buttons_by_name,
  #         buttons_by_name_and_field
  def other_page_buttons
    buttons_by_title = {
      'submit' => 'submit',
      'save' => 'save',
      'reload' => 'reload',
      'close' => 'close',
      'cancel' => 'cancel',
      'submit_to_sponsor' => 'Submit To Sponsor',
      'send_ad_hoc_request' => 'Send AdHoc Requests',
      'blanket_approve' => 'blanket approve'
    }

    buttons_by_alt = {
      'turn_on_validation' => 'activate validation',
      'refresh' => 'refresh'
    }

    buttons_by_name = {
      'link_to_hierarchy' => 'methodToCall.linkToHierarchy.anchorProposalHierarchy',
      'create_hierarchy' => 'methodToCall.createHierarchy.anchorProposalHierarchy',
      'copy_proposal' => 'methodToCall.copyProposal.anchorCopytoNewDocument',
      'link_child_proposal' => 'methodToCall.performLookup.(!!org.kuali.kra.proposaldevelopment.bo.DevelopmentProposal!!).(((proposalNumber:newHierarchyProposalNumber))).((`hierarchyParentStatus:hierarchyStatus`)).((<>)).(([])).((**)).((^^)).((&&)).((//)).((~~)).(::::;;::::).anchorProposalHierarchy',
      'lead_unit' => 'methodToCall.performLookup.(!!org.kuali.kra.bo.Unit!!).(((unitNumber:copyCriteria.leadUnitNumber))).((``)).((<>)).(([])).((**)).((^^)).((&&)).((//)).((~~)).(::::;;::::).anchorCopytoNewDocument',
      'name' => 'methodToCall.performLookup.(!!org.kuali.rice.kim.bo.impl.GroupImpl!!).(((namespaceCode:newAdHocRouteWorkgroup.recipientNamespaceCode,groupName:newAdHocRouteWorkgroup.recipientName))).((`newAdHocRouteWorkgroup.recipientNamespaceCode:namespaceCode,newAdHocRouteWorkgroup.recipientName:groupName`)).((<>)).(([])).((**)).((^^)).((&&)).((//)).((~~)).(::::;;::::).anchorPrintForms:PrintReports',
      'no' => 'methodToCall.processAnswer.button1',
      'yes' => 'methodToCall.processAnswer.button0',
    }

    buttons_by_name_and_field = {
      'print_selected' => {'Print Grants.gov Forms' => 'methodToCall.printForms',
                           'Print Sponsor Form Packages' => 'methodToCall.printSponsorForms'},
      'initiate_report' => {'Current Report' => 'methodToCall.prepareCurrentReport',
                            'Pending Report' => 'methodToCall.preparePendingReport'},
      'add' => {'Person Requests' => 'methodToCall.insertAdHocRoutePerson',
                'Ad Hoc Group Requests' => 'methodToCall.insertAdHocRouteWorkgroup'}
    }

    return buttons_by_title, buttons_by_alt, buttons_by_name,                  \
           buttons_by_name_and_field
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
    buttons_by_title, buttons_by_alt, buttons_by_name,                         \
           buttons_by_name_and_field = other_page_buttons
    mod_button = modify_field(button_name)

    begin
      if buttons_by_title.key?(mod_button)
        @button_xpath = "//input[@title='#{buttons_by_title[mod_button]}']"
        kaiki.click_approximate_field([@button_xpath])

      elsif buttons_by_name.key?(mod_button)
        @button_xpath = "//input[@name='#{buttons_by_name[mod_button]}']"
        kaiki.click_approximate_field([@button_xpath])

      elsif buttons_by_alt.key?(mod_button)
        @button_xpath = "//input[@alt='#{buttons_by_alt[mod_button]}']"
        kaiki.click_approximate_field([@button_xpath])

      elsif buttons_by_name_and_field.key?(mod_button)
        name = buttons_by_name_and_field[mod_button][field]
        @button_xpath = "//input[@name='#{name}']"
        kaiki.click_approximate_field([@button_xpath])
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