# Description: This file contains everything pertaining to running batch jobs
#              on the UofA systems.
#
# Original Date: November 17th, 2013

# Description: This class is used for handling Exceptions generated by batch
#              commands.
#
# Returns nothing.
class BatchException < Exception
end

# KFS BAT001-01 (Batch)

# Description: This step will connect to the server and then execute a batch
#              script.
#
# Parameters:
#   job_name        - The name of the job.
#   job_stream_name - The name of the job stream.
#
# Example: (taken from BAT001-01)
#   When I run the "clearCacheJob" job in the "KFS-SYS" jobstream
#
# Returns true (if successful) or false (if unsuccessful) or nil (if failed).
When(/^I run the "([^"]*)" job in the "([^"]*)" jobstream$/) do |job_name, job_stream_name|
  host = kaiki.envs[kaiki.env]['host']
  build_cmd = "ssh kbatch@#{host} \"batch_drive #{job_stream_name} #{job_name}\""
  result = system(build_cmd)
  print "#{result}\n"
  if result != true
    raise BatchException, "Batch process was unsuccessful or failed on #{job_name}"
  end
end

# KFS BAT001-01 (Batch)

# Description: This step verifies the existence of files on the server.
#
# Parameters:
#   file_ext    - The file type/extention of the files.
#   file_prefix - The filename's prefix.
#   path_to_dir - The path to the directory that contains the files.
#
# Example: (taken from BAT001-01)
#   When I verify that an ".xml" file starting with "pdp_check" exists in "/staging/pdp/PaymentExtract/" of the KFS working directory
#
# Returns true (if successful) or false (if unsuccessful) or nil (if failed).
When(/^I verify that an "([^"]*)" file starting with "([^"]*)" exists in "([^"]*)" of the KFS working directory$/)\
  do |file_ext, file_prefix, path_to_dir|
  result = ""
  30.times do
    host = kaiki.envs[kaiki.env]['host']
    system("ssh kbatch@#{host} \"ls ~/app/work/kfs/#{path_to_dir}/\"")
    build_cmd = "ssh kbatch@#{host} \"ls ~/app/work/kfs/#{path_to_dir}/#{file_prefix}*#{file_ext}\""
    result = system(build_cmd)
    print "#{result}\n"
    kaiki.pause(10)
    break if result == true
  end
  if result != true
    raise BatchException, "Batch process was unsuccessful or failed on verifying a file/s starting with #{file_prefix} & ending with #{file_ext}"
  end
end
