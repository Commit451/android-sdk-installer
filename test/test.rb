require_relative '../lib/android-sdk-installer.rb'

input = ARGV
puts 'Input size: ' + input.size.to_s
puts 'Input: ' + input.to_s
installer = AndroidInstaller::Installer.new(input)
installer.install
