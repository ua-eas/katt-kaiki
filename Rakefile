#
# Description: This is the Rakefile that is used to run the features from Jenkins.
#			         This sets environment variables and starts a video.
#              This can run all features, a certain feature, a certain 
#              scenario inside a feature, or a certain feature multiple times. 
#
# Original Date: August 20, 2011

require_relative 'features/support/ECE.rb'
require 'rake/clean'
require 'cucumber'
require 'cucumber/rake/task'

# Getting a weird warning about CLEAN...

#CLEAN = FileList['features/logs/*']

# Rake stuff needs to be non-interactive. So we'll set the things that will make it non-interactive.
# This sets environment variables.

def set_env_defaults
  ENV['KAIKI_IS_HEADLESS'] = "true" if ENV['KAIKI_IS_HEADLESS'].nil?
  ENV['KAIKI_NETID'] = ""           if ENV['KAIKI_NETID'].nil?
  ENV['KAIKI_ENV']   = "cdf"        if ENV['KAIKI_ENV'].nil?
end


#Public: A rake task to run all features in order
#
# rake command: ordered_features 
#
# This will run feature files in order via a tag id
# Each feature file that you want to run in order simply add a tag to line 1 of the feature file 
# example: @test1
# NOTE:each tag has to start with the id "test"
# 
# you can edit this line of code based on the number of features you want to run in order:
# until i > 10
# example: 
# until i > 100
#	
task :ordered_features do |t|
  i = 1
  until i > 4
  tags = "--tags @test#{i}"
    Cucumber::Rake::Task.new(:ordered_features, "Run scenario") do |t|
      t.cucumber_opts = tags
    end
    i += 1
  end
end


# Public: Takes an array from the given ruby file and runs scenarios according to the tags
#         contained within said array.
#
# Parameters:
# rows: rows of the array
# kc: name of the tags for kuali coeus test senarios that need to be run in order
#
#
# Returns nothing.
task :ECE do
  set_env_defaults
  File.basename("katt-kaiki/features/support/ECE.rb")
  jirra.each do |rows|
    sleep 30
    rows.each do |kc|
      sleep 30
      tags = "--tags #{kc}"
      Cucumber::Rake::Task.new(:ECE, "Run all tests in required order.") do |t|
        t.cucumber_opts = tags
      end
    end
  end
    Rake::Task[:ECE].invoke
  end
end


#Public: General Tag for features that dont need to run in order
#
# Parameters
#   @kctest- tag name for tests that dont need to be run in order
#
# Returns nothing.
Cucumber::Rake::Task.new(:dev) do |t|
  set_env_defaults
  t.cucumber_opts = "--tags @kctest"
end

#Public: Takes two rake tasks and invokes them in order
#
# Parameters 
#   ECE - ECE rake Task
#   dev - dev rake Task
#
# Returns nothing.
Cucumber::Rake::Task.new(:run, "Run scenario") do
 set_env_defaults
    Rake::Task[:ECE].invoke 1
    Rake::Task[:ECE].reenable
    Rake::Task[:dev].invoke 2
    Rake::Task[:dev].reenable
end


#Public: A rake task to run all features in order
#
# rake command: ordered_features
#
# This will run feature files in order via a tag id
# Each feature file that you want to run in order simply add a tag to line 1 of the feature file
# example: @test1
# NOTE:each tag has to start with the id "test"
#
# you can edit this line of code based on the number of features you want to run in order:
# until i > 10
# example:
# until i > 100
#
task :ordered_features do |t|
  i = 1
  until i > 3
  tags = "--tags @test#{i}"
    Cucumber::Rake::Task.new(:ordered_features, "Run scenario") do |t|
      t.cucumber_opts = tags
    end
    i += 1
  end
end

#Public:Takes an Arry from a .rb file from a folder and runs test senerios in order
#
# Parameters:
# rows: rows of the array
# kc: name of the tags for kuali coeus test senarios that need to be run in order
#
#
#Returns an array
#
task :ECE do
  set_env_defaults
  File.basename("katt-kaiki/features/support/ECE.rb")
  begin
  jirra.each do |rows|
  
    rows.each do |kc|
      tags = "--tags #{kc}"
      puts tags
      Cucumber::Rake::Task.new(:ECE, "Run all tests in required order.") do |t|
        t.cucumber_opts = tags
      end
     end
    end
    rescue Exception => e
      puts e.message
  end
end

#Public: General Tag for features that dont need to run in order
#
# Parameters
# @kctest- tag name for tests that dont need to be run in order
#
#Returns Nothing
#
Cucumber::Rake::Task.new(:dev) do |t|
  set_env_defaults
  t.cucumber_opts = "--tags @kctest"
end

#Public: Takes two rake tasks and invokes them in order
#
# Parameters
# ECE - ECE rake Task
# dev - dev rake Task
#
# Returns Nothing
#
Cucumber::Rake::Task.new(:run, "Run scenario") do
 set_env_defaults
    Rake::Task[:ECE].invoke 1
    Rake::Task[:ECE].reenable
    Rake::Task[:dev].invoke 2
    Rake::Task[:dev].reenable
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
