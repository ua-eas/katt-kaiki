# Description: This file contains the methods that pertain to the class
#              Kaiki::KC_Page::Base and its subclasses. It inherits from
#              Kaiki::Page::Base.
#
#
# Original Date: November 10th 2013

module Kaiki
end

module Kaiki::KC_Page
end

class Kaiki::KC_Page::Base < Kaiki::Page::Base

  # Public: This is the accessor method to what pages the KC system contains.
  #
  # Returns the kc_pages array.
  def self.pages
    kc_pages = [
      'Proposal',
      'Grants_Gov',
      'Key_Personnel',
      'Special_Review',
      'Custom_Data',
      'Abstracts_And_Attachments',
      'Questions',
      'Budget_Versions',
      'Permissions',
      'Proposal_Actions',
      'Medusa',
      'Parameters'
    ]
    return kc_pages
  end
end