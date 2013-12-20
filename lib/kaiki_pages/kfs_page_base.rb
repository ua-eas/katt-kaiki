# Description: This file contains the methods that pertain to the class
#              Kaiki::KC_Page::Base and its subclasses. It inherits from
#              Kaiki::Page::Base.
#
#
# Original Date: November 10th 2013

module Kaiki
end

module Kaiki::KFS_Page
end

class Kaiki::KFS_Page::Base < Kaiki::Page::Base

  # Public: This is the accessor method to what pages the KFS system contains.
  #
  # Returns the kc_pages array.
  def self.pages
    kfs_pages = [
      'Requisition',
      'Contract_Manager'
    ]
    return kfs_pages
  end
end