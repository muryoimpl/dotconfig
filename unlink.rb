require 'fileutils'

IGNORE_FILES = %w(. .. .DS_Store .git README.md LICENSE symlink.rb)

current_dir = Dir.pwd

dotconfigs = Dir.glob('*').reject {|f| IGNORE_FILES.include?(f) }

link_list = dotconfigs.map {|name| "#{ENV['HOME']}/.config/#{name}" }
FileUtils.safe_unlink(link_list)
