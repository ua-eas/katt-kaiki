# Description: This file contains everything pertaining to running batch jobs
#              on the UofA systems.
#
# Original Date: November 17th, 2013

# class BatchException < Exception
# end

# Description: Connects and executes a batch script to UofA server
#
# Parameters:
#   job_name        - name of job
#   job_stream_name - name of the job stream
#
# Example:
#   When I run the "clearCacheJob" job in the "KFS-SYS" jobstream
#
# Returns true(successful) false(unsuccessful) or nil(failed)
When(/^I run the "([^"]*)" job in the "([^"]*)" jobstream$/) do |job_name, job_stream_name|
  host = kaiki.envs[kaiki.env]['host']
  build_cmd = "ssh kbatch@#{host} \"batch_drive #{job_stream_name} #{job_name}\""
  result = system(build_cmd)
  print "#{result}\n"
  if result != true
    raise BatchException, "Batch process was unsuccessful or failed on #{job_name}"
  end
end

# Description: Verifies the existence of a file / files within the UofA server directory
#
# Parameters:
#
#   file_ext    - type of file extension
#   file_prefix - the prefix of a file / files name
#   path_to_dir - the /../../.. path to the directory
#
# Example:
#   When I verify that an ".xml" file starting with "pdp_check" exists in "/staging/pdp/PaymentExtract/" of the KFS working directory
#
# Returns true(successful) false(unsuccessful) or nil(failed)
When(/^I verify that an "([^"]*)" file starting with "([^"]*)" exists in "([^"]*)" of the KFS working directory$/)\
  do |file_ext, file_prefix, path_to_dir|
  host = kaiki.envs[kaiki.env]['host']
  system("ssh kbatch@#{host} \"ls ~/app/work/kfs/#{path_to_dir}/\"")
  build_cmd = "ssh kbatch@#{host} \"ls ~/app/work/kfs/#{path_to_dir}/#{file_prefix}*#{file_ext}\""
  result = system(build_cmd)
  print "#{result}\n"
  if result != true
    raise BatchException, "Batch process was unsuccessful or failed on verifying a file/s starting with #{file_prefix} & ending with #{file_ext}"
  end
end