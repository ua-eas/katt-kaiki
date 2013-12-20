# Description: This is the file for the Parameters class and applies to the
#              parameters page on the kuali coeus system inside of a budget
#              document.
#
# Original Date: 11 November 2013

class Parameters < Budget_Versions

  # Public: Defines the hashes inputs, selects and textareas for their
  #         respective fields that are contained on this page that are used
  #         in the current implemented tests.
  #
  # Returns the inputs, selects and textareas hashes.
  def page_fields
    inputs = {
      'total_direct_cost_limit' => "input[@title='Total Direct Cost Limit']",
      'residual_funds' => "input[@title='Residual Funds']",
      'total_cost_limit' => "input[@title='Total Cost Limit']",
      'period_start_date' => "input[@title='Period Start Date']",
      'period_end_date' => "input[@title='Period End Date']",
      'total_sponsor_cost' => "input[@title='Total Sponsor Cost']",
      'direct_cost' => "input[@title='Direct Cost']",
      'f&a_cost' => "input[@title='F&A Cost']",
      'unrecovered_f&a' => "input[@title='Unrecovered F&A']",
      'cost_sharing' => "input[@title='Cost Sharing']",
      'cost_limit' => "input[@title='Cost Limit']",
      'direct_cost_limit' => "input[@title='Direct Cost Limit']"
    }

    selects = {
      'budget_status' => "select[@title='Budget Status']",
      'on/off campus' => "select[@title='On/Off Campus']",
      'unrecovered_f_&_a_rate_type' => "select[@title='Unrecovered F & A Rate Type']",
      'f&a_rate_type' => "select[@title='F&A Rate Type']"
    }

    textareas = {
      'comments' => "textarea[@title='Comments']"
    }
    return inputs, selects, textareas
  end

  # Public: Defines the hash show_hide_by_title for all the show/hide tabs
  #         that are contained on this page.
  #
  # Returns the show_hide_by_title hash.
  def show_hide_tabs
    show_hide_by_title = {
      'budget_overview' => {'Show' => 'open Budget Overview',
                            'Hide' => 'close Budget Overview'},
      'budget_periods_&_totals' => {'Show' => 'open Budget Periods & Totals',
                                    'Hide' => 'close Budget Periods & Totals'}
    }
    return show_hide_by_title
  end

  # Public: Defines the hashes that contain all of the checkboxes that are
  #         contained on this page.
  #
  # Returns checkboxes_by_title
  def checkboxes
    checkboxes_by_title = {
      'final?' => 'Final?',
      'modular_budget?' => 'Modular Budget?'
    }
    return checkboxes_by_title
  end

  # Public: Defines the hashes for other buttons that are not search or
  #         show/hides on this page.
  #
  # Returns buttons_by_title, buttons_by_name, buttons_by_name_and_field
  def other_page_buttons
    buttons_by_title = {
      'generate_all_periods' => 'Generate All Periods',
      'calculate_all_periods' => 'Calculate All Periods',
      'default_periods' => 'Default Periods',
      'save' => 'save',
      'reload' => 'reload',
      'close' => 'close'

    }
    buttons_by_name = {
      'recalculate' => 'methodToCall.recalculateBudgetPeriod.anchorBudgetPeriodsTotals',
      'return_to_proposal' => 'methodToCall.returnToProposal'
    }
    buttons_by_name_and_field = {
      'add' => {'Budget Versions' => 'methodToCall.addBudgetVersion',
                'Budget Periods' => 'methodToCall.addBudgetPeriod.anchorBudgetPeriodsTotals'},

      'delete' => {'Budget Periods' => 'methodToCall.deleteBudgetPeriod.line0.anchor11'}
    }
    return buttons_by_title, buttons_by_name, buttons_by_name_and_field
  end

  # Public: Defines the names of the tables that are contained on this page.
  #
  # Returns the tables array.
  def page_tables
    tables = Array[
      'budget_periods',
      'totals'
    ]
    return tables
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
    buttons_by_title, buttons_by_name, buttons_by_name_and_field = other_page_buttons

    (1..max_data_rows).each do |data_row_counter|
      (starting_column..max_data_columns).each do |data_column_counter|
        row_name = data_table[data_row_counter][0]
        row_name = subsection_name if subsection_name
        column_name = data_table[0][data_column_counter]
        value = data_table[data_row_counter][data_column_counter]

        mod_field = modify_field(column_name)

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
          raise "FieldNotImplemented" unless @approximate_xpath
          if mod_field.eql?('action')
            kaiki.click_approximate_field(@approximate_xpath)
          else
            kaiki.set_approximate_field(@approximate_xpath, value)
          end
        end
      end
    end
  end

  # Public: First the starting column of the data is determined based on
  #         what the data actually contains.
  #         Next it retrieves all the page fields from the hashes storing them.
  #         The block is used to fill verify the fields within the table. If
  #         the field is part of the page's field hashes, it will verify it.
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
  def table_verify(table_name, table, options=nil)
    data_table = table.raw
    tables = page_tables
    mod_table = modify_field(table_name)
    raise "TableDoesNotExistOnPage" unless tables.include?(mod_table)

    case table_name
    when 'budget_periods'
      header_row = data_table[0]
      max_data_rows = data_table.size - 1
      max_data_columns = header_row.size - 1

      unless header_row[0].include?("#")
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

          unless value.eql?("")
            all_fields.each do |hash|
              option0 = "//h2[contains(text(), '#{@tab}')]/../../../../following-sibling::"\
                        "div/descendant::h3[contains(., '#{@section}')]/following-sibling::"\
                        "table/descendant::th[contains(text(), '#{row_name}')]/"\
                        "following-sibling::td/descendant::#{hash[mod_field]}"
              @approximate_xpath = [
                option0
              ]
            end
            field_text = kaiki.get_approximate_field(@approximate_xpath)
            raise Capybara::ExpectationNotMet unless field_text.eql?(value)
          end
        end
      end
    when 'totals'
      data_hash = {}
      (0..10).each do |data_row_counter|
        header_value = kaiki.find(
          :xpath,
          "//h2[contains(text(), '#{@tab}')]/../../../../following-sibling::div/"\
            "descendant::h3[contains(., '#{@section}')]/following-sibling::"   \
            "table/tbody/tr[1]/th[#{data_row_counter+1}]/div").text.strip
        data_value = kaiki.find(
          :xpath,
          "//h2[contains(text(), '#{@tab}')]/../../../../following-sibling::div/"\
            "descendant::h3[contains(., '#{@section}')]/following-sibling::"   \
            "table/descendant::tr[contains(., 'Totals')]/following-sibling::"  \
            "tr[1]/td[#{data_row_counter+1}]/div").text.strip
        data_hash.store(header_value, data_value)
      end
      rows = data_table.length-1
      (0..rows).each do |data_row_counter|
        header_name = data_table[data_row_counter][0]
        value = data_table[data_row_counter][1]
        raise Capybara::ExpectationNotMet unless data_hash[header_name].include?(value)
        kaiki.highlight(
          :xpath,
          "//h2[contains(text(), '#{@tab}')]/../../../../following-sibling::div/"\
            "descendant::h3[contains(., '#{@section}')]/following-sibling::" \
            "table/descendant::tr[contains(., 'Totals')]/following-sibling::"\
            "tr[1]/td[#{data_row_counter+2}]/div[contains(., '#{value}')]")
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
    buttons_by_title, buttons_by_name, buttons_by_name_and_field = other_page_buttons
    mod_button = modify_field(button_name)

    begin
      if buttons_by_title.key?(mod_button)
        kaiki.click_approximate_field(["//input[@title='#{buttons_by_title[mod_button]}']"])

      elsif buttons_by_name.key?(mod_button)
        kaiki.click_approximate_field(["//input[@name='#{buttons_by_name[mod_button]}']"])

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
            "following-sibling::table/descendant::input[@title='#{checkboxes_by_title[mod_check]}']"])
        elsif option.eql?("uncheck")
          kaiki.uncheck_approximate_field(["//h2[contains(text(), '#{@tab}')]"   \
            "/../../../../following-sibling::div/descendant::h3[contains(., '#{@section}')]/"\
            "following-sibling::table/descendant::input[@title='#{checkboxes_by_title[mod_check]}']"])
        end
      end
    rescue Capybara::ElementNotFound
      raise "CheckboxDoesNotExistOnPage"
    end
  end
end