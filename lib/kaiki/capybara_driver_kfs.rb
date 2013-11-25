# Description: It is currently used to set up various methods for each instance
#              of the CapybaraDriver Base, for KFS only.
#              It has access to the envs.json file and a
#              sharedpasswords.yaml file (if created).
#
# Original Date: August 20th 2011

class Kaiki::CapybaraDriver::KFS < Kaiki::CapybaraDriver::Base

  # Public: Desired url for the browser to navigate to.
  #
  # Returns nothing.
  def url
    @envs[@env]['url'] || "https://kf-#{@env}.mosaic.arizona.edu/kfs-#{@env}"
  end

end