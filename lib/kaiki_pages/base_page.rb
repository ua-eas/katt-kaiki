# Description: This file contains the methods that pertain to the class
#              Kaiki::Page::Base and its subclasses.
#
#
#              In the overall scheme, where a hash is used to store field names,
#              there is a specific pattern in place. The keys in these hashes
#              are a modified version of what is brought in from the feature
#              file, modified using the modify_field method in
#              Kaiki::Page::Base. The corresponding values for these keys are
#              a snippet of xpath that contains the field.
#
#              For example:
#              inputs = {
#                "description" => "input[@title='* Document Description']",
#              }
#
#              This way any xpath leading up to the input element can be
#              changed as needed, but this input element is one thing that
#              always stays the same.
#
#              Each method housed within Kaiki::Page::Base is never directly
#              accessed by the step definitions. It is only used if the
#              current page either doesn't have the method in it's subclass
#              or calls the parent class's method.
#
#
# Original Date: November 12th 2013

module Kaiki
end

module Kaiki::Page
end

class Kaiki::Page::Base

  attr_accessor :tab, :section, :subsection, :button_xpath

  # Public: When an instance of this class or its subclasses is made, it sets
  #         the instance variables tab, section, and subsection to nil.
  #
  # Returns nothing.
  def initialize
    @tab = nil
    @section = nil
    @subsection = nil
  end

  # Public: Gives subclasses access to the class variable @@kaiki of KaikiWorld,
  #         which in turn gives access to the CapybaraDriver object.
  #
  # Returns nothing.
  def kaiki
    KaikiWorld.kaiki
  end

  # Public: Gives subclasses access to the class variable @@search_page
  #         of KaikiWorld, which in turn gives access to the
  #         Search_Page object.
  #
  # Returns nothing.
  def search_page
    KaikiWorld.search_page
  end

  # Public: Gives subclasses access to the class variable @@current_page
  #
  # Returns nothing.
  def current_page
    @@current_page
  end

  # Public: Sets the class variable @@current_page for use by
  #         Kaiki::Page::Base's subclasses.
  #
  # Parameters:
  #   page - page to be set to @@current_page
  #
  # Returns nothing.
  def self.set_current_page(page)
    @@current_page = page
  end

  # Public: Takes in a field name given by the feature files and does some
  #         simple string manipulation, by downcasing it, stripping off all
  #         outer whitespace and then replaces all inner white space
  #         with underscores. This is done to match the keys in the field
  #         hashes contained within each page class.
  #
  # Parameters:
  #   field - name of field to be manipulated
  #
  # Returns mod_field, the modified field name.
  def modify_field(field)
    mod_field = field.downcase.strip.gsub(/\s/, '_')
  end

  # Public: Retrieves the current page object's fields and stores them
  #         in an array called all_fields.
  #
  # Returns the all_fields array.
  def get_all_fields
    inputs, selects, textareas = page_fields
    all_fields = [inputs, selects, textareas]
    return all_fields
  end

  # Public: Provides access to the buttons that appear on every page of
  #         the KC system.
  #
  # Returns the two hashes, buttons_by_title and buttons_by_a_tag
  def generic_buttons
    buttons_by_title = {
      'login' => 'Click to login.',
      'logout' => 'Click to logout.',
      'expand_all' => 'show all panel content',
      'collapse_all' => 'hide all panel content'
    }

    buttons_by_a_tag = {
      'action_list' => 'Action List',
      'document_search' => 'Document Search',
      'analytics/reports' => 'UAccess Analytics'
    }
    return buttons_by_title, buttons_by_a_tag
  end

  # Public: Verifies that the specified text appears next to the given label
  #         in the document header. This method applies to all KC and KFS tests.
  #
  # Parameters:
  #   label - label associated with the given text
  #   text  - text to be verified
  #
  # Returns nothing.
  def verify_document_header(label, text)
    element = kaiki.find_approximate_element([
                "//th[contains(., '#{label}')]/following-sibling::td"])
    tf = element.has_content?(text)
    raise Capybara::ExpectationNotMet unless tf.eql?(true)
  end

  # Public: First calls get_all_fields and modify_field.
  #         Then checks each all_field array element (which should be a hash)
  #         to see if they contain mod_field as one of it's keys;
  #         if it does it calls set_approximate_field in the CapybaraDriver
  #         to find and fill in said field with the given value.
  #
  #         Raises a custom error "FieldDoesNotExistOnPage" if
  #         Capybara::ElementNotFound is raised by the CapybaraDriver,
  #         and the current page has no defined special case verify text method.
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
      all_fields.each do |hash|
        if hash.key?(mod_field)
          kaiki.set_approximate_field(["//h2[contains(., '#{@tab}')]/../../../../"\
          "following-sibling::div/descendant::h3[contains(., '#{@section}')]/"\
          "following-sibling::table/descendant::#{hash[mod_field]}"], value)
        end
      end
    rescue Capybara::ElementNotFound
      raise "FieldDoesNotExistOnPage"
    end
  end

  # Public: First calls get_all_fields and modify_field.
  #         Then checks each all_field array element (which should be a hash)
  #         to see if they contain mod_field as one of it's keys;
  #         if it does it calls get_approximate_field in the CapybaraDriver
  #         to find and retrieve the contents of the field.
  #
  #         Raises a custom error "FieldDoesNotExistOnPage" if
  #         Capybara::ElementNotFound is raised by the CapybaraDriver,
  #         and the current page has no defined special case verify text method.
  #
  # Parameters:
  #   field       - label of field
  #   value       - what is to be entered into the field
  #   mode        - fuzzy or exact match
  #   line_number - possible line number the label may show up on
  #   subsection  - subsection of the page the label may appear in
  #
  # Returns nothing.
  def verify_field(field, value, mode, line_number=nil, subsection=nil)
    all_fields = get_all_fields
    mod_field = modify_field(field)
    begin
      all_fields.each do |hash|
        if hash.key?(mod_field)
          @field_text = kaiki.get_approximate_field(["//h2[contains(., '#{@tab}')]"\
          "/../../../../following-sibling::div/descendant::h3[contains(., '#{@section}')]/"\
          "following-sibling::table/descendant::#{hash[mod_field]}"])
        end
      end
    rescue Capybara::ElementNotFound
      raise "FieldDoesNotExistOnPage"
    end

    case mode
    when "exact"
      raise Capybara::ExpectationNotMet unless @field_text.eql?(value)
    when "fuzzy"
      raise Capybara::ExpectationNotMet unless @field_text.include?(value)
    else
      raise "InvalidVerificationMode"
    end
  end

  # Public: Uses a default xpath to find the wanted label and the text adjacent
  #         to it. Uses get_approxmiate_xpath from the CapybaraDriver to
  #         then retrieve the text for verification.
  #
  #         Raises a custom error "FieldDoesNotExistOnPage" if
  #         Capybara::ElementNotFound is raised by the CapybaraDriver,
  #         and the current page has no defined special case verify text method.
  #
  # Parameters:
  #   label       - label adjacent to text
  #   text        - text corresponding to label to be verified
  #   mode        - fuzzy or exact match
  #   subsection  - subsection of the page the label may appear in
  #
  # Returns nothing.
  def verify_text(label, text, mode, subsection=nil)
    begin
      @field_text = kaiki.get_approximate_field(["//h2[contains(., '#{@tab}')]"\
        "/../../../../following-sibling::div/descendant::h3[contains(., '#{@section}')]/"\
        "following-sibling::table/descendant::th[contains(., '#{label}')]/"    \
        "following-sibling::td"])
    rescue Capybara::ElementNotFound
      raise "FieldDoesNotExistOnPage"
    end

    case mode
    when "exact"
      raise Capybara::ExpectationNotMet unless @field_text.eql?(text)
    when "fuzzy"
      raise Capybara::ExpectationNotMet unless @field_text.include?(text)
    else
      raise "InvalidVerificationMode"
    end
  end

  # Public: First calls gerneric_buttons and modify_field. Then checks each
  #         returned hash to see if any of them contain mod_button as a key.
  #         If it does it calls click_approximate_field in the CapybaraDriver
  #         to find and click said button.
  #
  #         Raises a custom error "ButtonNotImplemented" if the specified
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
    buttons_by_title, buttons_by_a_tag = generic_buttons
    mod_button = modify_field(button_name)

    begin
      if buttons_by_title.key?(mod_button)
        kaiki.click_approximate_field(["//input[@title='#{buttons_by_title[mod_button]}']"])

      elsif buttons_by_a_tag.key?(mod_button)
        kaiki.click_approximate_field(["//a[@title='#{buttons_by_a_tag[mod_button]}']"])

      end
    rescue Capybara::ElementNotFound
      raise "ButtonNotImplemented"
    end
  end

  # Public: Used only if the current page hasn't specified the show/hide tab
  #         already. No modification is done to the tab name. It calls
  #         show_tab or hide_tab, depending on the action given by the feature
  #         file, using the most generic xpath possible.
  #
  #         Raises a custom error "ShowHideTabNotImplemented" if the
  #         show or hide method in CapybaraDriver raises
  #         Capybara::ElementNotFound.
  #
  # Parameters:
  #   tab_name   - name of the tab to be clicked
  #   action     - either show or hide
  #   section    - name of the section to be clicked, if necessary
  #   subsection - name of the subsection to be clicked, if necessary
  #   person     - person the section or subsection may appear under
  #
  # Returns nothing.
  def click_show_hide(tab_name, action, person=nil)
    mod_tab = modify_field(tab_name)
    begin
      if action.eql?("Show")
        kaiki.show_tab("//input[contains(@title, '#{tab_name}')]")
      elsif action.eql?("Hide")
        kaiki.hide_tab("//input[contains(@title, '#{tab_name}')]")
      end
    rescue Capybara::ElementNotFound
      raise "ShowHideTabNotImplemented"
    end
  end
end