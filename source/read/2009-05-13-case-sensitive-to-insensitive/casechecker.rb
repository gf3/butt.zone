#!/usr/bin/env ruby -w

def find_caseinsensitive_duplicates(dir)
  # INIT
  conflicts = {}
  
  # Load file list
  files = Dir.entries(dir).collect{|f| f.downcase }
  
  # Do yo thang!
  files.each do |f|
    files.each do |o|
      if f == o
        conflicts[f].nil? ? conflicts[f] = 1 : conflicts[f] += 1
      end
    end
  end
  
  conflicts = conflicts.delete_if{|w, o| o == 1}
  
  if conflicts.empty?
    puts "You're good to go! [#{dir}]"
  else
    puts "Conflicts found! [#{dir}]"
    conflicts.sort.each do |c|
      puts "conflict found on '#{c[0]}'"
    end
    puts "\n#{conflicts.length} conflict(s) in total."
  end
end

# Main
if $0 == __FILE__
  find_caseinsensitive_duplicates(ARGV[0] || Dir.pwd)
end

