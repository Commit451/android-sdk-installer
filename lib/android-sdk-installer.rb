require 'yaml'
require 'logger'
require 'pathname'
require 'dotenv/load'

module AndroidInstaller
  # Installs components for building Android projects
  # noinspection RubyClassVariableUsageInspection
  class Installer

    def initialize
      @@logger = Logger.new(STDOUT)
      @@logger.level = Logger::WARN
    end

    def install
      key_sdk_tools = '{ANDROID_SDK_TOOLS}'
      key_platform = '{PLATFORM}'
      sdk_url = 'https://dl.google.com/android/repository/tools_r' + key_sdk_tools + '-' + key_platform + '.zip'
      # Validation
      unless File.file?('android-sdk-installer.yml')
        puts "\nNo config file found. You need a file called `android-sdk-installer.yml` with the configuration. See the README for details\n\n"
        exit(1)
      end
      config = YAML.load_file('android-sdk-installer.yml')
      testing = false
      unless config.has_key?('version')
        puts "\nError in config file! Build file must contain a `version` string.\n\n"
        exit(1)
      end
      if config['debug']
        @@logger.level = Logger::DEBUG
        @@logger.debug('We are in debug mode')
      end
      version = config['version']
      platform = config['platform']
      sdk_url[key_sdk_tools] = version
      sdk_url[key_platform] = platform
      @@logger.debug('Installing version ' + version + ' for platform ' + platform + ' with url ' + sdk_url)
      exec('wget --quiet --output-document=android-sdk.zip ' + sdk_url)
    end
  end
end
