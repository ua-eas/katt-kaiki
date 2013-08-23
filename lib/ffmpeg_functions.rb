# Description: This module will take the recorded video from a headless run,
#              transcode it, and save it in the features/videos directory.
#
# Original Date: August 20th 2011

module FFMpegFunctions
  def self.transcode(file_name, new_file_name, options='')
    `ffmpeg -i #{file_name} #{options} #{new_file_name}`
  end

  def self.concatenate(new_file_name, *file_names)
    `cat #{file_names.join(' ')} > #{new_file_name}`
  end
end
