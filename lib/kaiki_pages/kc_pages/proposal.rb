# Description: This is the file for the Proposal page class and applies to the
#              proposal page on the kuali coeus system.
#
# Original Date: 11 November 2013

class Proposal < Kaiki::KC_Page::Base

  # Public: Defines the hashes inputs, selects and textareas for their
  #         respective fields that are contained on this page that are used
  #         in the current implemented tests.
  #
  # Returns the inputs, selects and textareas hashes.
  def page_fields
    inputs = {
      'description' => "input[@title='* Document Description']",
      'organization_document_number' => "input[@title='Organization Document Number']",
      'lead_unit' => "input[@title='* Lead Unit']",
      'sponsor_code' => "input[@title='* Sponsor Code']",
      'project_start_date' => "input[@title='* Project Start Date']",
      'project_end_date' => "input[@title='* Project End Date']",
      'award_id' => "input[@title='Award ID']",
      'original_institutional_proposal_id' => "input[@title='Original Institutional Proposal ID']",
      'sponsor_deadline_date' => "input[@title='Sponsor Deadline Date']",
      'prime_sponsor_id' => "input[@title='Prime Sponsor ID']",
      'sponsor_div_code' => "input[@title='Sponsor Div Code']",
      'cfda_number' => "input[@title='CFDA Number']",
      'opportunity_id' => "input[@title='Opportunity ID']",
      'sponsor_proposal_is' => "input[@title='Sponsor Proposal ID']",
      'sponsor_program_code' => "input[@title='Sponsor Program Code']",
      'performance_site_location' => "input[@title='Location Name']",
      'district_number' => "input[@title='District Number']",
      'location_name' => "input[@title='Location Name']"
    }

    selects = {
      'proposal_type' => "select[@title='* Proposal Type']",
      'activity_type' => "select[@title='* Activity Type']",
      'sponsor_deadline_type' => "select[@title='Sponsor Deadline Type']",
      'nsf_science_code' => "select[@title='* NSF Science Code']",
      'notice_of_opportunity' => "select[@title='Notice of Opportunity']",
      'state' => "select[@title='State']"
    }

    textareas = {
      'explanation' => "textarea[@title='Explanation']",
      'project_title' => "textarea[@title='* Project Title']",
      'opportunity_title' => "textarea[@title='Opportunity Title']"
    }
    return inputs, selects, textareas
  end

  # Public: Defines the hash search_buttons_by_name and
  #         search_buttons_by_name_and_field for all the search buttons
  #         that are contained on this page.
  #
  # Returns the search_buttons_by_name, search_buttons_by_name_and_field
  def search_buttons
    search_buttons_by_name = {
      'sponsor_code' => 'methodToCall.performLookup.(!!org.kuali.kra.bo.Sponsor!!).(((sponsorCode:document.developmentProposalList[0].sponsorCode,sponsorName:document.developmentProposalList[0].sponsor.sponsorName))).((``)).((<>)).(([])).((**)).((^^)).((&&)).((//)).((~~)).(::::;;::::).anchorRequiredFieldsforSavingDocument',
      'award_id' => 'methodToCall.performLookup.(!!org.kuali.kra.award.home.Award!!).(((awardNumber:document.developmentProposalList[0].currentAwardNumber))).((``)).((<>)).(([])).((**)).((^^)).((&&)).((//)).((~~)).(::::;;::::).anchorRequiredFieldsforSavingDocument',
      'original_institutional_proposal_id' => 'methodToCall.performLookup.(!!org.kuali.kra.institutionalproposal.home.InstitutionalProposal!!).(((proposalNumber:document.developmentProposalList[0].continuedFrom))).((``)).((<>)).(([])).((**)).((^^)).((&&)).((//)).((~~)).(::::;;::::).anchorRequiredFieldsforSavingDocument',
      'prime_sponsor_id' => 'methodToCall.performLookup.(!!org.kuali.kra.bo.Sponsor!!).(((sponsorCode:document.developmentProposalList[0].primeSponsorCode,sponsorName:primeSponsorName))).((``)).((<>)).(([])).((**)).((^^)).((&&)).((//)).((~~)).(::::;;::::).anchorSponsorProgramInformation',
      'description' => 'methodToCall.performLookup.(!!org.kuali.kra.bo.ScienceKeyword!!).((``)).(:;propScienceKeywords;:).((%true%)).((~~)).anchorKeywords'
    }

    search_buttons_by_name_and_field = {
      'address' => {'Performance Site Locations' => 'methodToCall.performLookup.(!!org.kuali.kra.bo.Rolodex!!).(((rolodexId:newPerformanceSite.rolodexId,organization:newPerformanceSite.locationName,postalCode:newPerformanceSite.rolodex.postalCode,addressLine1:newPerformanceSite.rolodex.addressLine1,addressLine2:newPerformanceSite.rolodex.addressLine2,addressLine3:newPerformanceSite.rolodex.addressLine3,city:newPerformanceSite.rolodex.city,state:newPerformanceSite.rolodex.state))).((``)).((<>)).(([])).((**)).((^^)).((&&)).((//)).((~~)).(::::;;::::).anchor30',
                    'Other Organizations' => 'methodToCall.performLookup.(!!org.kuali.kra.bo.Organization!!).(((organizationId:newOtherOrganization.organizationId,organizationName:newOtherOrganization.locationName,address:newOtherOrganization.organization.address))).((``)).((<>)).(([])).((**)).((^^)).((&&)).((//)).((~~)).(::::;;::::).anchor30'}
    }

    return search_buttons_by_name, search_buttons_by_name_and_field
  end

  # Public: Defines the hash show_hide_by_title for all the show/hide tabs
  #         that are contained on this page.
  #
  # Returns the show_hide_by_title hash.
  def show_hide_tabs
    show_hide_by_title = {
      'document_overview' => {'Show' => 'open Document Overview',
                              'Hide' => 'close Document Overview'},
      'required_fields_for_saving_document' => {'Show' => 'open Required Fields for Saving Document',
                                                'Hide' => 'close Required Fields for Saving Document'},
      'sponsor_&_program_information' => {'Show' => 'open Sponsor & Program Information',
                                          'Hide' => 'close Sponsor & Program Information'},
      'organization/location' => {'Show' => 'open Organization/Location',
                                  'Hide' => 'close Organization/Location'},
      'keywords' => {'Show' => 'open Keywords',
                     'Hide' => 'close Keywords'}
    }
    return show_hide_by_title
  end

  # Public: Defines the hashes for other buttons that are not search or
  #         show/hides on this page.
  #
  # Returns buttons_by_title, buttons_by_name_and_fields
  def other_page_buttons
    buttons_by_title = {
      'save' => 'save',
      'reload' => 'reload',
      'close' => 'close'
    }

    buttons_by_name_and_field = {
      'add' => {'Applicant Organization' => 'methodToCall.addApplicantOrgCongDistrict',
                'Performing Organizations' => 'methodToCall.addPerformingOrgCongDistrict',
                'Performance Site Locations' => 'methodToCall.addPerformanceSite.anchor30',
                'Other Organizations' => 'methodToCall.addOtherOrganization.anchor30'},
      'delete' => {'Applicant Organization' => 'methodToCall.deleteApplicantOrgCongDistrict.district0',
                   'Performing Organization' => 'methodToCall.deletePerformingOrgCongDistrict.district0'}
    }

    return buttons_by_title, buttons_by_name_and_field
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
    buttons_by_title, buttons_by_name_and_field = other_page_buttons
    mod_button = modify_field(button_name)

    begin
      if buttons_by_title.key?(mod_button)
        kaiki.click_approximate_field(["//input[@title='#{buttons_by_title[mod_button]}']"])

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
        name = search_buttons_by_name_and_field[mod_button][field]
        kaiki.click_approximate_field(["//input[@name='#{name}']"])
      end
    rescue Capybara::ElementNotFound
      raise "SearchButtonDoesNotExistOnPage"
    end
  end
end