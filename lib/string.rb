# Description: This class is used by the kaiki operation as some patching
#              to strings to make them safe to use as file names.
#              Do the following in order to make this String safe to
#              use as a filename:
#               * downcase it
#               * change all forward slashes into underscores
#               * change all nonalphanumeriunderscoreperiodic characters
#               * to hyphens (`/[^a-z0-9_.]/`)
#
# Original Date: August 20th 2011

class String
  def file_safe
    downcase.gsub(/\//, '_').gsub(/[^a-z0-9_.]/i, '-')
  end
end
