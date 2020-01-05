require 'fileutils'

IGNORE_FILES = %w(. .. .DS_Store .git README.md LICENSE symlink.rb)

current_dir = Dir.pwd

dotconfigs = Dir.glob('./*').reject {|f| IGNORE_FILES.include?(f) }

dotconfigs.each do |dotconf|
  FileUtils.ln_s("#{current_dir}/#{dotconf}", "#{ENV['HOME']}/.config/#{dotconf}", force: true)
  puts "#{current_dir}/#{dotconf}  ->  #{ENV['HOME']}/.config/#{dotconf}"
end
