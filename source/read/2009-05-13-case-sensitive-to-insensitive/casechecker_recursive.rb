#!/usr/bin/env ruby -w

require "casechecker"

def recursively_find_caseinsensitive_duplicates(dir)
  Dir.entries(dir).each do |file|
    unless ["..", "."].include? file
      new_path = File.join(dir, file)
      recursively_find_caseinsensitive_duplicates(new_path) if File.directory? new_path
    end
  end
  find_caseinsensitive_duplicates dir
end

# Main
if $0 == __FILE__
  recursively_find_caseinsensitive_duplicates(ARGV[0] || Dir.pwd)
end

