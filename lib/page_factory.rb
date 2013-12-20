# Description: This fill contains all of the methods needed by the page
#              factory.
#              Currently it can create a specified page object given the page's
#              name and application.
#
# Original Date: 12 November 2013

class PageFactory

  # Public: This method retrieves the current application's pages and compares
  #         the given page name to that list, if the list contains the page
  #         name, the corresponding object is made and the class variable
  #         @@current_page in KaikiWorld is set to said page.
  #
  # Parameters:
  #   page        - name of the page to create
  #   application - current application being accessed
  #
  # Returns nothing.
  def self.create_page(page, application)

    app_object = "Kaiki::#{application.upcase}_Page::Base".split('::').inject(Object)\
      { |o,c| o.const_get(c) }

    app_pages = app_object.pages

    page = page.strip.gsub(/\s/, '_')
    if app_pages.include?(page)
      page = Object::const_get("#{page}").new
      KaikiWorld.set_current_page(page)
      Kaiki::Page::Base.set_current_page(page)
    else
      raise "PageDoesNotExistInApplication"
    end
  end

end