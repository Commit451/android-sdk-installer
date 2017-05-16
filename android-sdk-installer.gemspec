# coding: utf-8

Gem::Specification.new do |spec|
  spec.name          = 'android-sdk-installer'
  spec.version       = '0.0.1'
  spec.authors       = ['Commit 451']

  spec.summary       = 'Android SDK installer'
  spec.homepage      = 'https://github.com/Commit451/android-sdk-installer'
  spec.license       = 'MIT'

  spec.files         = ['lib/android-sdk-installer.rb']
  spec.bindir        = 'bin'
  spec.require_paths << 'lib'
  spec.executables   << 'android-sdk-installer'

  spec.required_ruby_version = '>= 2.0.0'

end
