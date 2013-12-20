# Description: This file contains the methods that pertain to the class
#              Kaiki::Search_Page::Base and its subclasses.
#
# Original Date: November 11th 2013

module Kaiki
end

module Kaiki::Search_Page
end

class Kaiki::Search_Page::Base < Kaiki::Page::Base

  # Public: Defines the hashes inputs, selects and textareas that are contained
  #         on search pages found in either KC or KFS and stores the
  #         hashes in the all_fields array.
  #
  # Returns the all_fields array.
  def get_all_fields
    inputs = {
      'sponsor_code' => "input[@name='sponsorCode']",
      'organization_code' => "input[@name='organizationCode']",
      'document/notification id' => "input[@name='routeHeaderId']"
    }

    selects = {

    }

    textareas = {

    }
    all_fields = [inputs, selects, textareas]
    return all_fields
  end

  # Public: Defines the hash search_buttons_by_title and
  #         other_buttons_by_title that are contained on search pages found
  #         in either KC or KFS.
  #
  # Returns the all_buttons array.
  def page_buttons
    buttons_by_title = {
      'search' => "input[@title='search']",
      'clear' => "input[@title='clear']",
      'cancel' => "a[@title='cancel']"
    }

    return buttons_by_title
  end

  # Public: First calls get_all_fields and modify_field. Then checks each
  #         all_field array element (which should be a hash) to see if they
  #         contain mod_field as one of it's keys. If it does it calls
  #         set_approximate_field in the CapybaraDriver to find and
  #         fill in said field with the given value.
  #
  #         Raises a custom error "FieldDoesNotExistOnPage" if
  #         Capybara::ElementNotFound is raised by the CapybaraDriver.
  #
  # Parameters:
  #   field - label of field
  #   value - what is to be entered into the field
  #
  # Returns nothing.
  def fill_in_field(field, value)
    begin
      factory0 =
        ApproximationsFactory.transpose_build(
          "//%s[contains(text(), '#{field}')]/../following-sibling::td/%s",
          ['label',    'select'],
          ['div',      'input'])
      approximate_xpath = factory0
      kaiki.set_approximate_field(approximate_xpath, value)
    rescue Capybara::ElementNotFound
      raise "FieldDoesNotExistOnPage"
    end
  end

  # Public: First calls page_buttons and modify_field. Then checks each
  #         all_buttons array element (which should be a hash) to see if they
  #         contain mod_button as one of it's keys. If it does it calls
  #         click_approximate_field in the CapybaraDriver to find and
  #         click said button.
  #
  #         Raises a custom error "ButtonNotImplemented" if the button is
  #         not contained with this search page object.
  #
  # Parameters:
  #   button_name - label of the button
  #
  # Returns nothing.
  def click_button(button_name)
    buttons_by_title = page_buttons
    mod_button = modify_field(button_name)
    if buttons_by_title.key?(mod_button)
      kaiki.click_approximate_field(["//#{buttons_by_title[mod_button]}"])
    else
      raise "ButtonNotImplemented"
    end
  end

  # Public: Clicks the specified link on the page.
  #         Link_name will usually refer to the column that contains the value
  #         the link is associated with, but also may 'none' to mean the first
  #         link found on the page is to be clicked, and if it neither of those
  #         it is usually a specific action to be done on the first record,
  #         such as 'open', 'modify' or 'copy'.
  #         Record_identifier is exactly what it sounds like, it is what
  #         the record to be returned will be identified by; either the first
  #         record or a record with a specific value in a column.
  #
  # Parameters:
  #   link_name         - described above in detail
  #   record_identifier - described above in detail
  #
  # Returns nothing.
  def click_link_on_record(link_name=nil, record_identifier=nil)
    begin
      if link_name.eql?('none') and record_identifier.eql?(:first)
        kaiki.click_approximate_element(["/html/body/form/table/tbody/tr/td[2]"\
                                         "/table/tbody/tr/td/a"])

      elsif not link_name.eql?('none') and record_identifier.eql?(:first)
        kaiki.click_approximate_field(["//a[contains(text(), '#{action}')]"])

      else
        kaiki.click_approximate_field(["//th/a[contains(text(),'#{link_name}')]"\
            "/../../../following-sibling::tbody/tr/td[contains(.,'#{record_identifier}')]"\
            "/preceding-sibling::td/a[contains(text(),'return value')]"])

      end
    rescue Capybara::ElementNotFound
      raise "LinkDoesNotAppearOnPage"
    end
  end

end