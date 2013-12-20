# Description: This is the file for the Requisiton class and applies to the
#              requisition page on the kuali financial system.
#
# Original Date: 12 November 2013

class Requisition < Kaiki::KFS_Page::Base

  # Public: Defines the hashes inputs, selects and textareas for their
  #         respective fields that are contained on this page that are used
  #         in the current implemented tests.
  #
  # Returns the inputs, selects and textareas hashes.
  def page_fields
    inputs = {
      'description' => "input[@title='* Document Description']",
      'room' => "input[@title='* Room']",
      'delivery_to' => "input[@title='* Delivery To']",
      'phone_number' => "input[@title='Phone Number']",
      'email' => "input[@title='Email']",
      'date_required' => "input[@title='Date Required']",
      'suggested_vendor' => "input[@title='Suggested Vendor']",
      'vendor_name_1' => "input[@title='Vendor Name 1']",
      'quantity' => "input[@title='Item Quantity']",
      'unit_of_measure_code' => "input[@title='Item Unit Of Measure Code']",
      'catalog_#' => "input[@title='Catalog #']",
      'unit_cost' => "input[@title='Unit Cost']",
      'account_number' => "input[@title='Account Number for New Source Line']",
      'object' => "input[@title='Object for New Source Line']",
      'percent' => "input[@title='Percent for New Source Line']",
      'requestor_name' => "input[@title='* Requestor Name']",
      'requestor_phone' => "input[@title='* Requestor Phone']",
      'requestor_email' => "input[@title='* Requestor Email']",
    }

    selects = {
      'funding_source' => "select[@title='* Funding Source']",
      'date_required_reason' => "select[@title='Date Required Reason']",
      'item_type' => "select[@title='* Item Type']",
      'chart' => "select[@title='Chart for New Source Line']",
      'method_of_po_transmission' => "select[@title='* Method of PO Transmission']"
    }

    textareas = {
      'description' => "textarea[contains(@title, 'Description')]",
      'note_text' => "textarea[@title='* Note Text']"
    }
    return inputs, selects, textareas
  end

  # Public: Defines the hashes inputs, selects and textareas for their
  #         respective fields that are contained in on this page, in a
  #         non-regular format, that are used in the current implemented tests.
  #
  # Returns the inputs, selects and textareas hashes.
  def special_page_fields
    inputs = {
      'extended_cost' => "input[@title='Unit Cost']"
    }

    selects = {

    }

    textareas = {
      'description' => "textarea[contains(@title, 'Description')]"
    }

    return inputs, selects, textareas
  end

  # Public: Defines the hash search_buttons_by_name and
  #         search_buttons_by_name_and_field for all the search buttons
  #         that are contained on this page.
  #
  # Returns search_buttons_by_name, search_buttons_by_xpath
  def search_buttons
    search_buttons_by_name = {
      'person'            => "methodToCall.performLookup.(!!org.kuali.rice.kim.bo.Person!!).(((principalName:newAdHocRoutePerson.id,name:newAdHocRoutePerson.name))).((#newAdHocRoutePerson.id:principalName#)).((<>)).(([])).((**)).((^^)).((&&)).((//)).((~~)).(::::;;::::).anchor21"
    }

    search_buttons_by_xpath = {
      'chart/org'            => "//div[text()='Chart/Org:']/../following-sibling::td/input[contains(@title, 'Search')]",
      'building'             => "//div[text()='Building:']/../following-sibling::td/input[contains(@title, 'Search')]",
      'room'                 => "//div[text()='Room:']/../following-sibling::td/input[contains(@title, 'Search')]",
      'receiving_address'    => "//div[text()='Receiving Address:']/../following-sibling::td/input[contains(@title, 'Search')]",
      'suggested_vendor'     => "//div[text()='Suggested Vendor:']/../following-sibling::td/input[contains(@title, 'Search')]",
      'unit_of_measure_code' => "/html/body/form/table/tbody/tr/td[2]/div/div[4]/div[2]/table/tbody/tr[3]/td[4]/input[2]"
    }

    return search_buttons_by_name, search_buttons_by_xpath
  end

  # Public: Defines the hash show_hide_by_title for all the show/hide tabs
  #         that are contained on this page.
  #
  # Returns the show_hide_by_title, show_hide_by_name hashes,
  #   show_hide_route_log hashes.
  def show_hide_tabs
    show_hide_by_title = {
      'document_overview' => {'Show' => 'open Document Overview',
                              'Hide' => 'close Document Overview'},
      'delivery' => {'Show' => 'open Delivery',
                     'Hide' => 'close Delivery'},
      'vendor' => {'Show' => 'open Vendor',
                   'Hide' => 'close Vendor'},
      'items' => {'Show' => 'open Items',
                  'Hide' => 'close Items'},
      'capital_asset' => {'Show' => 'open Capital Asser',
                          'Hide' => 'close Capital Asset'},
      'payment_info' => {'Show' => 'open Payment Info',
                         'Hide' => 'close Payment Info'},
      'additional_institutional_info' => {'Show' => 'open Additional Institutional Info',
                                       'Hide' => 'close Additional Institutional Info'},
      'account_summary' => {'Show' => 'open Account Summary',
                            'Hide' => 'close Account Summary'},
      'view_related_documents' => {'Show' => 'open View Related Documents',
                                  'Hide' => 'close View Related Documents'},
      'view_payment_history' => {'Show' => 'open View Payment History',
                                 'Hide' => 'close View Payment History'},
      'notes_and_attachments' => {'Show' => 'open Notes and Attachments',
                                  'Hide' => 'close Notes and Attachments'},
      'ad_hoc_recipients' => {'Show' => 'open Ad Hoc Recipients',
                              'Hide' => 'close Ad Hoc recipients'},
      'route_log' => {'Show' => 'open Route Log',
                      'Hide' => 'close Route Log'},
    }

    show_hide_by_name = {
      'additional_charges' => 'methodToCall.toggleTab.tabAdditionalCharges',
      'accounting_lines' => 'methodToCall.toggleTab.tabAccountingLines5'
    }
    show_hide_route_log = {
      'id' => "//input[@name='methodToCall.toggleTab.tabID2412184']",
      'actions_taken' => "//input[@name='methodToCall.toggleTab.tabActionsTaken']",
      'pending_actions_requests' => "//input[@name='methodToCall.toggleTab.tabPendingActionRequests']",
      'future_action_requests' => "//a[contains(@href, 'RouteLog.do?showFuture')]",
    }
    return show_hide_by_title, show_hide_by_name, show_hide_route_log
  end

  # Public: Defines the hashes that contain all of the checkboxes that are
  #         contained on this page.
  #
  # Returns checkboxes_by_title
  def checkboxes
    checkboxes_by_title = {
      'receiving_requested' => 'Receiving Required',
      'payment_request_positive_approval_requested' => 'Payment Request Positive Approval Required',
      'restricted' => 'Restricted',
      'assigned_to_trade_in' => 'Assigned To Trade In'
    }
    return checkboxes_by_title
  end

  # Public: Defines the hashes that contain all of the radio buttons that are
  #         contained on this page.
  #
  # Returns radio_buttons_by_title
  def radio_buttons
    radio_buttons_by_title = {
      'receiving_address' => 'Shipping Address Presented to Vendor - Receiving Address',
      'final_delivery_address' => 'Shipping Address Presented to Vendor - Final Delivery Address'
    }
    return radio_buttons_by_title
  end

  # Public: Defines the hashes that contains all of the calendars that are
  #         contained on this page.
  #
  # Returns calendars_by_id
  def calendars
    calendars_by_id = {
      'date_required' => 'document.deliveryRequiredDate_datepicker',
      'begin_date' => 'document.purchaseOrderBeginDate_datepicker',
      'end_date' => 'document.purchaseOrderEndDate_datepicker'
    }
    return calendars_by_id
  end

  # Public: Defines the hashes for other buttons that are not search or
  #         show/hides on this page.
  #
  # Returns buttons_by_title, buttons_by_name_and_section,
  #         buttons_by_alt_and_section, add_button_by_title_and_section,
  #         add_button_by_title_and_subsection, route_log_buttons
  def other_page_buttons
    buttons_by_title = {
      'calculate' => 'Calculate',
      'submit' => 'submit',
      'save' => 'save',
      'close' => 'close',
      'cancel' => 'cancel',
      'approve' => 'approve'
    }

    buttons_by_name_and_section = {
      'delete' => {'Current Items' => 'methodToCall.deleteItem.line0'}
    }

    buttons_by_alt_and_section = {
      'building_not_found' => {'Final Delivery' => 'building not found'},
      'set_as_default_building' => {'Final Delivery' => 'set as default building'},
      'clear_vendor' => {'Vendor Address' => 'clear vendor'},
      'import_items' => {'Add Item' => 'import items from file'},
      'setup_distribution' => {'Add Item' => 'setup distribution'},
      'remove_accounts_from_all_items' => {'Add Item' => 'remove accounts from all items'},
      'expand_all_accounts' => {'Add Item' => 'expand all accounts'},
      'collapse_all_accounts' => {'Add Item' => 'collapse all accounts'},
      'clear_all_tax' => {'Add Item' => 'Clear all tax'},
      'show_detail' => {'Current Items' => 'show transaction deatils'},
      'hide_detail' => {'Current Items' => 'hide transaction details'},
      'select' => {'System Selection' => 'select system'},
      'refresh_account_summary' => {'Account Summary' => 'refresh account summary'},
    }

    add_button_by_title_and_section = {
      'Add Item' => "input[@title='Add an Item']",
      'Current Items' => "input[@title='Add Source Accounting Line']",
      'Notes and Attachments' => "input[@title='Add a Note']"
    }

    add_button_by_title_and_subsection = {
      'FREIGHT' => "input[@title='Add Source Accounting Line']",
      'MINIMUM ORDER' => "input[@title='Add Source Accounting Line']",
      'MISCELLANOUS' => "input[@title='Add Source Accounting Line']",
      'FULL ORDER DISCOUNT' => "input[@title='Add Source Accounting Line']",
      'SHIPPING AND HANDLING' => "input[@title='Add Source Accounting Line']",
      'CAPITAL TRADE IN' => "input[@title='Add Source Accounting Line']",
      'NON-CAPITAL TRADE IN' => "input[@title='Add Source Accounting Line']"
    }

    route_log_buttons = {
      'refresh' => "//img[@alt='refresh']"
    }

    return buttons_by_title, buttons_by_name_and_section,
      buttons_by_alt_and_section, add_button_by_title_and_section,
      add_button_by_title_and_subsection, route_log_buttons
  end

  # Public: First calls get_all_fields and modify_field.
  #         Then depending on what mod_field equals, an if statement filters
  #         through to the correct operation to be performed.
  #         Set_approximate_field in the CapybaraDriver is used
  #         to find and fill in said field with the given value.
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
  def fill_in_field(field, value, line_number=nil, subsection=nil)
    all_fields = get_all_fields
    mod_field = modify_field(field)
    begin
      if mod_field.eql?('description') and not subsection
        kaiki.set_approximate_field(["//h2[contains(., '#{@tab}')]/../../../../"\
        "following-sibling::div/descendant::h3[contains(., '#{@section}')]/"\
        "following-sibling::table/descendant::#{all_fields[0][mod_field]}"], value)

      elsif subsection
        inputs, selects, textareas = special_page_fields
        if inputs.key?(mod_field)
          kaiki.set_approximate_field(["//h2[contains(., '#{@tab}')]/../../../../"\
          "following-sibling::div/descendant::span[contains(., '#{@section}')]"\
          "/../../following-sibling::tr[contains(., '#{subsection}')]/"        \
          "following-sibling::tr/descendant::#{inputs[mod_field]}"], value)

        elsif selects.key?(mod_field)
          kaiki.set_approximate_field(["//h2[contains(., '#{@tab}')]/../../../../"\
          "following-sibling::div/descendant::span[contains(., '#{@section}')]"\
          "/../../following-sibling::tr[contains(., '#{subsection}')]/"        \
          "following-sibling::tr/descendant::#{selects[mod_field]}"], value)

        elsif textareas.key?(mod_field)
          kaiki.set_approximate_field(["//h2[contains(., '#{@tab}')]/../../../../"\
          "following-sibling::div/descendant::span[contains(., '#{@section}')]"\
          "/../../following-sibling::tr[contains(., '#{subsection}')]/"        \
          "following-sibling::tr/descendant::#{textareas[mod_field]}"], value)
        end

      else
        super
      end
    rescue Capybara::ElementNotFound
      raise "FieldDoesNotExistOnPage"
    end
  end

  # Public: First the starting column of the data is determined based on
  #         what the data actually contains.
  #         Next it retrieves all the page fields from the hashes storing them,
  #         and also the same for the page's special fields and buttons.
  #         This method uses two if statements to filter through
  #         the actions that are taking place; performing a search or
  #         filling in a field/clicking a button.
  #         The first if checks if the current value contains a '@'. If it
  #         does, this signifies that there needs to be a search performed.
  #         The last block is used to fill out the fields within the table; if
  #         the field is part of the page's field hashes, it will fill it in.
  #         Location awareness, i.e. tab name, and section name are used
  #         to further determine the location of the field to be filed in.
  #
  #         Raises a custom error "FieldNotImplemeneted" if the
  #         specified field is not contained within the current page object.
  #
  # Parameters:
  #   subsection - subsection of the page the field may appear in
  #   table_name - name of the table to be filled out
  #   table      - data to be used, in tabular format
  #   options    - either :add or nil
  #
  # Returns nothing.
  def table_fill(subsection, table_name, table, options=nil)
    data_table = table.raw
    header_row = data_table[0]
    max_data_rows = data_table.size - 1
    max_data_columns = header_row.size - 1

    if (options == :add) or not header_row[0].include?("#")
      starting_column = 0
    else
      starting_column = 1
    end

    all_fields = get_all_fields
    inputs, selects, textareas = special_page_fields
    buttons_by_title, buttons_by_name_and_section,
    buttons_by_alt_and_section, add_button_by_title_and_section,
    add_button_by_title_and_subsection, route_log_buttons = other_page_buttons

    (1..max_data_rows).each do |data_row_counter|
      (starting_column..max_data_columns).each do |data_column_counter|
        row_name = data_table[data_row_counter][0]
        row_name = subsection if subsection
        column_name = data_table[0][data_column_counter]
        value = data_table[data_row_counter][data_column_counter]

        mod_field = modify_field(column_name)

        if value[-1].eql?("@")
          value = value.chop
          click_search_button(column_name, value, nil, nil)
          search_page.fill_in_field(column_name, value)
          search_page.click_button("search")
          search_page.click_link_on_record(column_name, value)

        elsif not value.eql?("")
          all_fields.each do |hash|
            @field = textareas[mod_field] if mod_field.eql?('description')
            @field = add_button_by_title_and_section[@section] if mod_field.eql?('action')
            @field = add_button_by_title_and_subsection[subsection] if subsection and mod_field.eql?('action')
            if hash.key?(mod_field)
              @field = hash[mod_field]
            end
            @approximate_xpath = [
              option0 = "//h2[contains(., '#{@tab}')]/../../../../following-sibling::"\
                        "div/descendant::span[contains(text(), '#{@section}')]"\
                        "/../../following-sibling::tr[contains(., '#{row_name}')]"\
                        "/following-sibling::tr/descendant::span[contains(., '#{table_name}')]"\
                        "/../../following-sibling::tr/descendant::#{@field}",

              option1 = "//h2[contains(., '#{@tab}')]/../../../../following-sibling::"\
                        "div/descendant::span[contains(text(), '#{@section}')]"\
                        "/../../following-sibling::tr/descendant::#{@field}"
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

  # Public: First calls other_page_buttons and modify_field. Then checks each
  #         returned hash to see if any of them contain mod_button as a key.
  #         If it does it calls click_approximate_field in the CapybaraDriver
  #         to find and click said button.
  #
  # Parameters:
  #   button_name - button to be clicked
  #   field       - label of field adjacent to button is applicable
  #   line_number - possible line number the field may show up on
  #   subsection  - subsection of the page the field may appear in
  #
  # Returns nothing.
  def click_button(button_name, field, line_number, subsection)
    buttons_by_title, buttons_by_name_and_section,
      buttons_by_alt_and_section, add_button_by_title_and_section,
      add_button_by_title_and_subsection, route_log_buttons = other_page_buttons
    mod_button = modify_field(button_name)

    if buttons_by_title.key?(mod_button)
      kaiki.click_approximate_field(["//input[@title='#{buttons_by_title[mod_button]}']"])

    elsif buttons_by_name_and_section.key?(mod_button)
      name = buttons_by_name_and_section[mod_button][@section]
      name["line0"] = "line#{line_number.to_i-1}" if mod_button.eql?('delete') and name.include?('line0')
      kaiki.click_approximate_field(["//input[@name='#{name}']"])

    elsif buttons_by_alt_and_section.key?(mod_button)
      alt = buttons_by_alt_and_section[mod_button][@section]
      kaiki.click_approximate_field(["//input[@alt='#{alt}']"])

    elsif add_button_by_title_and_section.key?(@section)
      kaiki.click_approximate_field(["//h2[contains(text(), '#{@tab}')]"       \
          "/../../../../following-sibling::div/descendant::"                   \
          "h3[contains(., '#{@section}')]/following-sibling::table/"           \
          "descendant::#{add_button_by_title_and_section[@section]}"])

    elsif add_button_by_title_and_subsection.key?(subsection)
      kaiki.click_approximate_field(["//h2[contains(text(), '#{@tab}')]"       \
          "/../../../../following-sibling::div/descendant::"                   \
          "span[contains(., '#{@section}')]/../../following-sibling::"         \
          "tr[contains(.,'#{subsection}')]/following-sibling::tr/"             \
          "descendant::#{add_button_by_title_and_subsection[subsection]}"])

    elsif route_log_buttons.key?(mod_button)
      kaiki.select_frame('routeLogIFrame')
      kaiki.click_approximate_field([route_log_buttons[mod_button]])

    else
      super
    end
  end

  # Public: First calls show_hide_tabs and modify_field. Then checks each
  #         returned hash to see if any of them contain mod_button as a key.
  #         If it does it calls click_approximate_field in the CapybaraDriver
  #         to find and click said button.
  #
  #         Raises a custom error "ShowHideTabNotImplemented" if the
  #         specified button is not contained within the current page object.
  #
  # Parameters:
  #   tab_name   - name of the tab to be clicked
  #   action     - either show or hide
  #   person     - person the section or subsection may appear under
  #
  # Returns nothing.
  def click_show_hide(tab_name, action, person=nil)
    show_hide_by_title, show_hide_by_name, show_hide_route_log = show_hide_tabs
    mod_tab = modify_field(tab_name)

    if show_hide_by_title.key?(mod_tab)
      if action.eql?("Show")
        kaiki.show_tab("//input[contains(@title, '#{show_hide_by_title[mod_tab]["Show"]}')]")
      elsif action.eql?("Hide")
        kaiki.hide_tab("//input[contains(@title, '#{show_hide_by_title[mod_tab]["Hide"]}')]")
      end

    elsif show_hide_by_name.key?(mod_tab)
      name = show_hide_by_name[mod_tab]
      kaiki.click_approximate_field(["//input[@name='#{name}']"])

    elsif show_hide_route_log.key?(mod_tab)
      kaiki.select_frame('routeLogIFrame')
      kaiki.click_approximate_field([show_hide_route_log[mod_tab]])

    else
      raise "ShowHideTabNotImplemented"
    end
  end

  # Public: First calls search_buttons and modify_field. Then checks each
  #         returned hash to see if any of them contain mod_button as a key.
  #         If it does it calls click_approximate_field in the CapybaraDriver
  #         to find and click said button.
  #
  #         Raises a custom error "SearchButtonNotImplemented" if the
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
    search_buttons_by_name, search_buttons_by_xpath = search_buttons
    mod_button = modify_field(button_name)

    if search_buttons_by_name.key?(mod_button)
      kaiki.click_approximate_field(["//input[@name='#{search_buttons_by_name[mod_button]}']"])

    elsif search_buttons_by_xpath.key?(mod_button)
      kaiki.click_approximate_field([search_buttons_by_xpath[mod_button]])

    else
      raise "SearchButtonNotImplemented"
    end
  end

  # Public: First calls checkboxes and modify_field. Then checks each
  #         returned hash to see if any of them contain mod_button as a key.
  #         If it does it calls click_approximate_field in the CapybaraDriver
  #         to find and click said button.
  #
  #         Raises a custom error "CheckboxNotImplemented" if the specified
  #         button is not contained within the current page object.
  #
  # Parameters:
  #   option      - check or uncheck
  #   check_name  - name of the checkbox to click
  #   field       - label of field adjacent to button is applicable
  #   line_number - possible line number the field may show up on
  #   subsection  - subsection of the page the field may appear in
  #
  # Returns nothing.
  def check_uncheck_box(option, check_name, field, line_number, subsection)
    checkboxes_by_title = checkboxes
    mod_check = modify_field(check_name)
    if checkboxes_by_title.key?(mod_check)
      if option.eql?("check")
        kaiki.check_approximate_field(["//h2[contains(text(), '#{@tab}')]"   \
          "/../../../../following-sibling::div/descendant::"                 \
          "h3[contains(., '#{@section}')]/following-sibling::"               \
          "table/descendant::input[@title='#{checkboxes_by_title[mod_check]}']"])
      elsif option.eql?("uncheck")
        kaiki.uncheck_approximate_field(["//h2[contains(text(), '#{@tab}')]" \
          "/../../../../following-sibling::div/descendant::"                 \
          "h3[contains(., '#{@section}')]/following-sibling::"               \
          "table/descendant::input[@title='#{checkboxes_by_title[mod_check]}']"])
      end
    else
      raise "CheckboxNotImplemented"
    end
  end

  # Public: First calls other_page_buttons and modify_field. Then checks each
  #         returned hash to see if any of them contain mod_button as a key.
  #         If it does it calls click_approximate_field in the CapybaraDriver
  #         to find and click said button.
  #
  #         Raises a custom error "RadioButtonNotImplemented" if the
  #         specified button is not contained within the current page object.
  #
  # Parameters:
  #   button_name - button to be clicked
  #   field       - label of field adjacent to button is applicable
  #   line_number - possible line number the field may show up on
  #   subsection  - subsection of the page the field may appear in
  #
  # Returns nothing.
  def click_radio_button(button_name, subsection)
    radio_buttons_by_title = radio_buttons
    mod_button = modify_field(button_name)
    if radio_buttons_by_title.key?(mod_button)
      kaiki.click_approximate_field(["//h2[contains(text(), '#{@tab}')]"     \
        "/../../../../following-sibling::div/descendant::h3[contains(., '#{@section}')]/"\
        "following-sibling::table/descendant::input[@title='#{radio_buttons_by_title[mod_button]}']"])
    else
      raise "RadioButtonNotImplemented"
    end
  end

  # Description: Will open the calendar popup adjacent to the specified field
  #              and select the appropriate date from within it by calling
  #              select_calendar_date in CapybaraDriver.
  #
  #              **If a date other than 'Today' is to be selected, the format
  #                for said date needs to be 'November 19, 2013' for example.
  #
  #              Raises a custom error "CalendarNotImplemented" if the
  #              specified calendar is not contained within the current
  #              page object.
  #
  # Example:
  #   When I click the "Date Required" calendar and set the date to "Today"
  #   When I click the "Date Required" calendar and set the date to "November 19, 2013"
  #
  # Parameters:
  #   label         - name of the field the calendar is adjacent to
  #   date_option   - option inside the calender to be selected
  #
  # Returns nothing.
  def click_calendar(label, date_option)
    calendars_by_id = calendars
    mod_label = modify_field(label)
    if calendars_by_id.key?(mod_label)
      kaiki.click_approximate_field(["//h2[contains(text(), '#{@tab}')]"     \
        "/../../../../following-sibling::div/descendant::h3[contains(., '#{@section}')]/"\
        "following-sibling::table/descendant::input[@id='#{calendars_by_id[mod_label]}']"])
      kaiki.select_calender_date(date_option)
    else
      raise "CalendarNotImplemented"
    end
  end
end
