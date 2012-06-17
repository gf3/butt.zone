Today I was about to format my computer, but first I had to backup my files. So
I dragged my home folder over to an external hard drive. Turns out the external
drive was formatted as case-insensitive and my internal drive is case-sensitive
(the true UNIX way). Anyway, the transfer failed because many of my files had
the same name, just different case. I freaked out and thought that this would
be impossible to fix. But then I remembered that I was a programmer, so
I quickly wrote a couple ruby scripts to quickly find files with conflicting
names.

I thought some of you might find these useful, so I'm posting them here:

### Code

#### casechecker.rb

``` ruby
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
```

#### casechecker_recursive.rb

``` ruby
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
```

### Usage

``` bash
./casechecker_recursive.rb /path/to/directory
```

### PS

Never format your Mac as case-sensitive, you'll have major compatibility issues. **Trust me**.

