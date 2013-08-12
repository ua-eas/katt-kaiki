# Description: This class is used by the kaikifs operation to change the
#              extension on a file if necessary.
#
# Original Date: August 20th 2011

class File
  # Return `file_name`, changing the extension to `new_extension`.
  def self.change_extension(file_name, new_extension)
    if file_name =~ /^(.+)\.(.+)$/
      "#{$1}.#{new_extension}"
    else
      "#{file_name}.#{new_extension}"
    end
  end
end
