require 'fileutils'
require 'rbconfig'

IGNORE_FILES = %w(. .. .DS_Store .git README.md LICENSE symlink.rb unlink.rb vscode.plugin.txt)

ignored =
  case RbConfig::CONFIG['host_os']
  when /darwin/
    IGNORE_FILES
  when /linux/
    IGNORE_FILES + %w(dunst i3 picom polybar rofi systemd)
  end

current_dir = Dir.pwd
dotconfigs = Dir.glob('*').reject {|f| ignored.include?(f) }

dotconfigs.each do |dotconf|
  FileUtils.ln_s("#{current_dir}/#{dotconf}", "#{ENV['HOME']}/.config/#{dotconf}", force: true)
  puts "#{current_dir}/#{dotconf}  ->  #{ENV['HOME']}/.config/#{dotconf}"
end
