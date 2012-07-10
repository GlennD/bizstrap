#!/usr/bin/env ruby

# Watch for file changes: straight copy/paste from my dependence gem
# yay for code reuse
module Dependence
  class FileWatcher
    @@defaults = {
      :load_path => ".",
      :glob_str  => "**/*"
    }
    def initialize(opts, &block)
      @options = @@defaults.merge(opts)
      recreate_timetable
      poll(&block)
    end

    private
    def poll(&block)
      while true
        if fs_modified?
          block.call
          recreate_timetable
        end
        sleep 3 
      end
    end

    def fs_modified?
      new_files = get_files
      return true if new_files.length != @files.length 
      new_timetable = create_file_modified_timetable(new_files)

      modified = false
      new_timetable.each do |filename,time|
        if time != @timetable[filename] 
          modified = true
          break
        end
      end
      modified
    end

    def get_files
      Dir.glob File.join(@options[:load_path], @options[:glob_str]) 
    end

    def recreate_timetable
      @files = get_files
      @timetable = create_file_modified_timetable(@files)
    end

    def create_file_modified_timetable(filenames)
      filenames.inject({}) do |table, filename|
        table[filename] = File.mtime(filename) if File.exists? filename
        table
      end
    end
  end
end

SOURCE = File.join(File.dirname(__FILE__), "less", "bootstrap.less")

def build(output)
  puts "Compiling Bootstrap files to #{output}"
  `lessc #{SOURCE} #{output}`
  puts "Done!"
end

if ARGV.length < 1
  puts "USAGE:" 
  puts "Build Once: build.rb <output css file>"
  puts "Build Whenever Files Change: build.rb <output css file> -w"
  exit(1)
end

output = ARGV[0]
build(output)

if ARGV.length > 1 && ARGV[1] == '-w'
  puts "Watching for additional changes control-c to kill me"
  Dependence::FileWatcher.new(:load_path => "./less", :glob_str => "**/*.less") do 
    build(output)
  end
end
