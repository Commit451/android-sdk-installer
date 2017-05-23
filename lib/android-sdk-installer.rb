require 'psych'
require 'logger'

module AndroidInstaller
  # Installs components for building Android projects
  # noinspection RubyClassVariableUsageInspection
  class Installer

    KEY_SDK_TOOLS = '{ANDROID_SDK_TOOLS}'
    KEY_PLATFORM = '{PLATFORM}'
    SDK_URL = 'https://dl.google.com'
    SDK_PATH = '/android/repository/sdk-tools-' + KEY_PLATFORM + '-' + KEY_SDK_TOOLS + '.zip'
    CONFIG_FILE = 'android-sdk-installer.yml'

    def initialize
      @@logger = Logger.new(STDOUT)
      @@logger.level = Logger::WARN
    end

    def install_command_line_sdk(platform, version)
      sdk_path = SDK_PATH
      sdk_path[KEY_SDK_TOOLS] = version
      sdk_path[KEY_PLATFORM] = platform
      url = SDK_URL + sdk_path
      @@logger.debug('Downloading version ' + version + ' for platform ' + platform + ' with url ' + url)
      `wget --quiet --output-document=android-sdk.zip #{url}`
      # TODO: error out here if file not found
      unless File.file?('android-sdk.zip')
        puts "\nAndroid SDK not found at url #{url}. Make sure you have the right values in your #{CONFIG_FILE}\n"
        exit(1)
      end
      @@logger.debug('Unzipping android-sdk.zip')
      `unzip -q android-sdk.zip -d $PWD/android-sdk`
      `rm android-sdk.zip`
      `export ANDROID_HOME=$PWD/android-sdk`
    end

    def install
      # Validation
      if File.file?(CONFIG_FILE)
        config = Psych.load_file CONFIG_FILE
      else
        config = Psych.load("foo: true\nbar: false")
      end
      version = '3859397'
      if config.has_key?('version')
        version = config['version']
      end
      if config['debug']
        @@logger.level = Logger::DEBUG
        @@logger.debug('We are in debug mode')
      end

      platform = 'linux'
      if config.has_key?('platform')
        platform = config['platform']
      end

      ignore_existing = false
      if config.has_key?('ignore_existing')
        ignore_existing = config['ignore_existing']
        @@logger.debug("Ignore existing set to #{ignore_existing}")
      end

      should_install = ENV['ANDROID_HOME'].nil? || ignore_existing
      if should_install
        install_command_line_sdk(platform, version)
      else
        @@logger.debug('ANDROID_HOME already set. Skipping command line tools install')
      end

      components = config['components']
      if components != nil
        components.each do |component|
          @@logger.debug('Installing component ' + component)
          output = `echo y | $ANDROID_HOME/tools/bin/sdkmanager "#{component}"`
          @@logger.debug(output)
          if output.include? 'Warning'
            puts "\nError installing component " + component + "\n"
            puts output
          end
        end
      end
    end
  end
end
