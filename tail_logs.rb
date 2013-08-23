#
# Description: This file will create and format the log file.
#
#
# Original Date: August 20, 2011
#

require 'file-tail'
require 'find'
require 'highline/import'

# Public: This method checks to see if a specific path is a directory.
#
# Example:
#     <present directory>\features\logs
#
# Returns nothing.
def log_files
  files = []
  Find.find(File.join(Dir.pwd, 'features', 'logs')) do |p|
    next if FileTest.directory? p
    files << p
  end
  files
end

# Public: Sorts the log files by date/time.
#
# Returns nothing.
def last_log
  log_files.sort_by { |f| File.mtime(f) }.max
end

# Public: Opens the log file, reads the line and assigns a color to the 
#         line based on the information in the line.
#
# Returns nothing.
def tail_last
  log_name = last_log
  File.open log_name do |f|
    f.extend File::Tail
    f.interval = 2
    f.backward(2)
    f.return_if_eof = true
    loop do
      f.tail { |line| color_print line }
      break unless last_log == log_name
    end
  end
end

# Public: Sets the log line to a specific color based on the type of log.
#         *Information = Green and bold
#         *Debug = Green
#         *Warning = Yellow and bold
#         *Error = Red and bold
#
# Parameters:
#   s - Line from the file.
#
# Returns nothing.
def color_print(s)
  if s =~ /^(\s*[A-Z]+)\s+(.+)$/
    colors = {
      'DEBUG' => 'GREEN',
      ' INFO' => 'GREEN + BOLD',
      ' WARN' => 'YELLOW + BOLD',
      'ERROR' => 'RED + BOLD'
    }
    say "<%= color(\"#{$1}\", #{colors[$1]}) %> #{$2}"
  else
    puts s
  end
end

loop do
  say "<%= color(\"Last log: #{last_log}\", YELLOW) %>"
  tail_last
end
