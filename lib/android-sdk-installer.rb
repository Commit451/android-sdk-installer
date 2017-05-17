require 'yaml'
require 'logger'

module AndroidInstaller
  # Installs components for building Android projects
  # noinspection RubyClassVariableUsageInspection
  class Installer

    def initialize
      @@logger = Logger.new(STDOUT)
      @@logger.level = Logger::WARN
    end

    def install
      # Why is it formatted like this?
      key_sdk_tools = '{ANDROID_SDK_TOOLS}'
      key_platform = '{PLATFORM}'
      sdk_url = 'https://dl.google.com'
      sdk_path = '/android/repository/sdk-tools-' + key_platform + '-' + key_sdk_tools + '.zip'
      # Validation
      unless File.file?('android-sdk-installer.yml')
        puts "\nNo config file found. You need a file called `android-sdk-installer.yml` with the configuration. See the README for details\n\n"
        exit(1)
      end
      config = YAML.load_file('android-sdk-installer.yml')
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
      sdk_path[key_sdk_tools] = version
      sdk_path[key_platform] = platform
      @@logger.debug('Downloading version ' + version + ' for platform ' + platform + ' with url ' + sdk_url + sdk_path)
      `wget --quiet --output-document=android-sdk.zip #{sdk_url + sdk_path}`
      # TODO: error out here if file not found
      @@logger.debug('Unzipping android-sdk.zip')
      `unzip -q android-sdk.zip -d $PWD/android-sdk`
      `rm android-sdk.zip`
      `export ANDROID_HOME=$PWD/android-sdk`
      components = config['components']
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
