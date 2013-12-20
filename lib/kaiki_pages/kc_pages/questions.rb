# Description: This is the file for the Questions class and applies to the
#              questions page on the kuali coeus system.
#
# Original Date: 11 November 2013

class Questions < Kaiki::KC_Page::Base

  # Public: Defines the hashes inputs, selects and textareas for their
  #         respective fields that are contained on this page that are used
  #         in the current implemented tests.
  #
  # Returns the inputs, selects and textareas hashes.
  def page_fields
    inputs = {
      'yes' => "input[@title='Answer - Yes']",
      'no' => "input[@title='Answer - No']",
      'n/a' => "input[@title='Answer - N/A']",
      'review_date' => "input[@title='Review Date']"
    }

    selects = {

    }

    textareas = {
      'explanation' => "textarea[@title='Explanation']",
    }
    return inputs, selects, textareas
  end

  # Public: Defines the hash show_hide_by_title for all the show/hide tabs
  #         that are contained on this page.
  #
  # Returns the show_hide_by_title hash.
  def show_hide_tabs
    show_hide_by_title = {
      'does_the_proposed_work_include_any_of_the_following?' => {'Show' => 'open Does the Proposed Work Include any of the Following?',
                                                                 'Hide' => 'close Does the Proposed Work Include any of the Following?',},
      'f&a_(indirect_cost)_questions' => {'Show' => 'open F&A (Indirect Cost) Questions',
                                          'Hide' => 'close F&A (Indirect Cost) Questions',},
      'grants.gov_questions' => {'Show' => 'open Grants.gov Questions',
                                 'Hide' => 'close Grants.gov Questions',},
      'prs_questions' => {'Show' => 'open PRS Questions',
                          'Hide' => 'close PRS Questions',}
    }
    return show_hide_by_title
  end

  # Public: Defines the hashes for other buttons that are not search or
  #         show/hides on this page.
  #
  # Returns buttons_by_title
  def other_page_buttons
    buttons_by_title = {
      'save' => 'save',
      'reload' => 'reload',
      'close' => 'close'
    }

    buttons_by_alt = {
      'view' => {'Does the Proposed Work Include any of the Following? '=> 'inquiry',
                 'F&A (Indirect Cost) Questions' => 'inquiry',
                 'Grants.gov Questions' => 'inquiry',
                 'PRS Questions' => 'inquiry'}
    }
    return buttons_by_title, buttons_by_alt
  end

  # Public: First the starting column of the data is determined based on
  #         what the data actually contains.
  #         Next it retrieves all the page fields from the hashes storing them,
  #         and also the same for the page's buttons.
  #         The block is used to fill out the fields within the table. If
  #         the field is part of the page's field hashes, it will fill it in.
  #         Location awareness, i.e. tab name, and section name are used
  #         to further determine the location of the field to be filed in.
  #
  #         Raises a custom error "FieldNotImplemented" if the
  #         specified field is not contained within the current page object.
  #
  # Parameters:
  #   subsection - subsection of the page the field may appear in
  #   table_name - name of the table to be filled out
  #   table      - data to be used, in tabular format
  #   options    - either :add or nil
  #
  # Returns nothing.
  def table_fill(subsection_name, table_name, table, options=nil)
    data_table = table.raw
    header_row = data_table[0]
    max_data_rows = data_table.size - 1
    max_data_columns = header_row.size - 1

    if (options == :add) || (!header_row[0].include?("#"))
      starting_column = 0
    else
      starting_column = 1
    end
    all_fields = get_all_fields

    (1..max_data_rows).each do |data_row_counter|
      (starting_column..max_data_columns).each do |data_column_counter|
        row_name = data_table[data_row_counter][0]
        column_name = data_table[0][data_column_counter]
        value = data_table[data_row_counter][data_column_counter]

        mod_field = modify_field(value)

        unless value.eql?("")
          all_fields.each do |hash|
            if hash.key?(mod_field)
              @field = hash[mod_field]
            end
            @approximate_xpath = [
              option0 = "//h2[contains(text(), '#{@tab}')]/../../../../following-sibling::"\
                        "div/descendant::h3[contains(., '#{@section}')]/following-sibling::"\
                        "table/descendant::th[contains(text(), '#{row_name}')]/"\
                        "following-sibling::td/descendant::#{@field}"
            ]
          end
         kaiki.click_approximate_field(@approximate_xpath, "radio")
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
    buttons_by_title, buttons_by_alt = other_page_buttons
    mod_button = modify_field(button_name)

    begin
      if buttons_by_title.key?(mod_button)
        kaiki.click_approximate_field(["//input[@title='#{buttons_by_title[mod_button]}']"])

      elsif buttons_by_alt.key?(mod_button)
        kaiki.click_approximate_field(["//input[@alt='#{buttons_by_alt[mod_button]}']"])

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