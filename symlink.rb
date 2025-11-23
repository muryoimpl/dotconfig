require 'fileutils'
require 'rbconfig'

IGNORE_FILES = %w(. .. .DS_Store .git README.md LICENSE symlink.rb unlink.rb vscode.plugin.txt)
RELATIVE_PATH = './ghq/github.com/muryoimpl/dotconfig'

ignored =
  case RbConfig::CONFIG['host_os']
  when /darwin/
    IGNORE_FILES
  when /linux/
    IGNORE_FILES + %w(picom polybar systemd)
  end

current_dir = Dir.pwd
dotconfigs = Dir.glob('*').reject {|f| ignored.include?(f) }

FileUtils.cd "#{ENV['HOME']}/.config/"

dotconfigs.each do |dotconf|
  file_in_home = "./#{dotconf}"
  FileUtils.safe_unlink(file_in_home) if FileTest.symlink?(file_in_home)

  FileUtils.ln_s("../#{RELATIVE_PATH}/#{dotconf}", "./#{dotconf}", force: true)
  puts "$HOME/#{RELATIVE_PATH}/#{dotconf}  ->  $HOME/.config/#{dotconf}"
rescue
  puts "Error occurred. #{dotconf}, file_in_home: #{file_in_home}"
end
