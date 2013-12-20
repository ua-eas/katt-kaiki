#
# Description: This is the Rakefile that is used to run the features from Jenkins.
#			         This sets environment variables and starts a video.
#              This can run all features, a certain feature, a certain
#              scenario inside a feature, or a certain feature multiple times.
#
# Original Date: August 20, 2011

require_relative 'features/support/test_tags.rb'
require 'rake/clean'
require 'cucumber'
require 'cucumber/rake/task'
require 'highline/import'

# Getting a weird warning about CLEAN...

#CLEAN = FileList['features/logs/*']

# Rake stuff needs to be non-interactive. So we'll set the things that will make it non-interactive.
# This sets environment variables.

def set_env_defaults
  ENV['KAIKI_IS_HEADLESS'] = "true" if ENV['KAIKI_IS_HEADLESS'].nil?
  ENV['KAIKI_NETID'] = "uartest"    if ENV['KAIKI_NETID'].nil?
  ENV['KAIKI_ENV'] = "cdf"          if ENV['KAIKI_ENV'].nil?
end


# Public: Takes an array from the given ruby file and runs scenarios according
#         to the tags contained within said array.
#
# Parameters:
#   rows - rows of the array
#   kc   - name of the tags for kuali coeus test senarios that need to be
#          run in order
#
#
# Returns nothing.
task :KC do
  ENV['KAIKI_APP'] = "kc" if ENV['KAIKI_APP'].nil?
  set_env_defaults
  File.basename("katt-kaiki-dev-financial/features/support/test_tags.rb")
  kc_tags.each do |i|
    i.each do |j|
      Cucumber::Rake::Task.new(:KC, "Run all tests in required order.") do |t|
        t.cucumber_opts = "--tags #{j} --format pretty --format html --out ./features/reports/#{tag_name}.html"
      end
    end
  end
end


# Public: Takes an array from the given ruby file and runs scenarios according
#         to the tags contained within said array.
#
# Parameters:
#   rows - rows of the array
#   kc   - name of the tags for kuali financial system test senarios that need
#          to be run in order
#
#
# Returns nothing.
task :KFS do
  ENV['KAIKI_APP'] = "kfs" if ENV['KAIKI_APP'].nil?
  set_env_defaults
  File.basename("katt-kaiki-dev-financial/features/support/test_tags.rb")
  kfs_tags.each do |i|
    i.each do |j|
      Cucumber::Rake::Task.new(:KFS, "Run all tests in required order.") do |t|
        t.cucumber_opts = "--tags #{j} --format pretty --format html --out ./features/reports/#{tag_name}.html"
      end
    end
  end
end


#Public: General Tag for features that dont need to run in order
#
# Parameters
#
#
# Returns nothing.
task :by_tag, :tag do |t, args|
  ENV['KAIKI_APP'] = ask("Application: ") { |q| q.echo = true; } if ENV['KAIKI_APP'].nil?
  set_env_defaults
  tag_name = args[:tag]
  Cucumber::Rake::Task.new(:by_tag) do |t|
    set_env_defaults
    t.cucumber_opts = "--tags #{tag_name} --format pretty --format html --out ./features/reports/#{tag_name}.html"
  end
end


# Experimental... not sure we'll use this...
# This creates a .mov video file when the rake starts.

task :merge_videos do
  Dir.glob("features/videos/*__*.mov").group_by {|n| n =~ /^(.+)__(\d+)\.mov/; $1 }.each do |prefix,videos|
    final_merged_file = prefix+".mov"
    next if File.exist? final_merged_file

    new_videos = []
    videos.sort.each do |mov|
      new_video = File.change_extension(mov, 'mpg')
      FFMpegFunctions.transcode(mov, new_video, '-qscale 1')
      new_videos << new_video
    end
    FFMpegFunctions.concatenate(prefix+".mpg", new_videos)
    FFMpegFunctions.transcode( prefix+".mpg", final_merged_file, '-qscale 2')
  end
end


# This sets up the 'features' task. Use as:
#
# rake features
#
# This will run all feature files in the features/ directory, according to the
# tag rules: anything that is NOT a cucumber_example, and NOT incomplete, and
# NOT not_a_test.

Cucumber::Rake::Task.new(:features) do |t|
  set_env_defaults
  t.cucumber_opts = "--format pretty --tags ~@cucumber_example --tags ~@incomplete --tags ~@not_a_test"
end


# This sets up the 'ci_features' task. Use as:
#
# rake ci_features
#
# This will run all feature files in the features/ directory, according to the
# tag rules: anything that is NOT a cucumber_example, and NOT incomplete, and
# NOT not_a_test. It uses `--format progress` so that it looks better in
# Jenkins.

Cucumber::Rake::Task.new(:ci_features) do |t|
  set_env_defaults
  t.cucumber_opts = "--format progress --tags ~@cucumber_example --tags ~@incomplete --tags ~@not_a_test"
end


# This sets up the 'feature' task. Use as:
#
# rake feature[KFSI-1021]
#
# This will run a single feature that matches the substring supplied. To test
# what features will match, you can run:
#
# find features ! -path "*/example_syntax/*" ! -path "*/ceremonies/*" -name "*KFSI-1021*.feature"

task :feature, :name do |t, args|
  set_env_defaults
  feature = `find features ! -path "*/example_syntax/*" ! -path "*/ceremonies/*" -name "*#{args[:name]}*.feature"`
  break if feature.empty?
  feature = feature.split(/\n/).first

  Cucumber::Rake::Task.new(:cuke_feature, "Run a single feature") do |t|
    t.cucumber_opts = "--format pretty #{feature} -s -r features"
  end

  Rake::Task["cuke_feature"].invoke
end


# This sets up the 'scenario' task. Use as:
#
# rake scenario[KFSI-1021,7]
#
# This will run a single scenario that matches the substring and line number
# supplied. To test what features will match, you can run:
#
# find features ! -path "*/example_syntax/*" ! -path "*/ceremonies/*" -name "*KFSI-1021*.feature"

task :scenario, :name, :line do |t, args|
  set_env_defaults
  feature = `find features ! -path "*/example_syntax/*" ! -path "*/ceremonies/*" -name "*#{args[:name]}*.feature"`
  break if feature.empty?
  feature = feature.split(/\n/).first
  line = args[:line]

  Cucumber::Rake::Task.new(:cuke_feature, "Run a single scenario") do |t|
    t.cucumber_opts = "--format pretty #{feature}:#{line} -s -r features"
  end

  Rake::Task["cuke_feature"].invoke
end

# same as scenario, but only looking in ceremonies folder
task :ceremony, :name, :line do |t, args|
  set_env_defaults
  feature = `find features/ceremonies -name "*#{args[:name]}*.feature"`
  break if feature.empty?
  feature = feature.split(/\n/).first
  line = args[:line]

  Cucumber::Rake::Task.new(:cuke_feature, "Run a single scenario") do |t|
    t.cucumber_opts = "--format pretty #{feature}:#{line} -s -r features"
  end

  Rake::Task["cuke_feature"].invoke
end

# This sets up the 'vet_feature' task. Use as:
#
# rake vet_feature[KFSI-1021]
#
# This will run a single feature that matches the substring supplied, ten
# times. To test what features will match, you can run:
#
# find features ! -path "*/example_syntax/*" ! -path "*/ceremonies/*" -name "*KFSI-1021*.feature"

task :vet_feature, :name do |t, args|
  set_env_defaults
  feature = `find features ! -path "*/example_syntax/*" -name "*#{args[:name]}*.feature"`
  break if feature.empty?
  feature = feature.split(/\n/).first

  Cucumber::Rake::Task.new(:cuke_feature, "Run a single feature") do |t|
    t.cucumber_opts = "--format pretty #{feature} -s -r features"
  end

  10.times do
    Rake::Task["cuke_feature"].reenable
    Rake::Task["cuke_feature"].invoke
  end
end


# This sets up the 'vet' task. Use as:
#
# rake vet[KFSI-1021,7]
#
# This will run a single scenario that matches the substring and line number
# supplied, ten times. To test what features will match, you can run:
#
# find features ! -path "*/example_syntax/*" ! -path "*/ceremonies/*" -name "*KFSI-1021*.feature"

task :vet, :name, :line do |t, args|
  set_env_defaults
  feature = `find features ! -path "*/example_syntax/*" -name "*#{args[:name]}*.feature"`
  break if feature.empty?
  feature = feature.split(/\n/).first
  line = args[:line]

  Cucumber::Rake::Task.new(:cuke_scenario, "Run a single scenario") do |t|
    t.cucumber_opts = "--format pretty #{feature}:#{line} -s -r features"
  end

  10.times do
    Rake::Task["cuke_scenario"].reenable
    Rake::Task["cuke_scenario"].invoke
  end
end
