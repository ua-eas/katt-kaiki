# Description: It is currently used to set up various methods for each instance
#              of the CapybaraDriver Base, for KC only.
#              It has access to the envs.json file and a
#              sharedpasswords.yaml file (if created).
#
# Original Date: August 20th 2011

class Kaiki::CapybaraDriver::KC < Kaiki::CapybaraDriver::Base

  # Public: Desired url for the browser to navigate to.
  #
  # Returns nothing.
  def url
    @envs[@env]['url'] || "https://kr-#{@env}.mosaic.arizona.edu/kra-#{@env}"
  end

end