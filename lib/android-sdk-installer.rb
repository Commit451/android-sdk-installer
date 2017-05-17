require 'yaml'
require 'logger'
require 'net/http'

module AndroidInstaller
  # Installs components for building Android projects
  # noinspection RubyClassVariableUsageInspection
  class Installer

    def initialize
      @@logger = Logger.new(STDOUT)
      @@logger.level = Logger::WARN
    end

    def download_file(base_url, path, file_name)
      Net::HTTP.start(base_url) do |http|
        resp = http.get(path)
        open(file_name, "wb") do |file|
          file.write(resp.body)
        end
      end
    end

    def install
      key_sdk_tools = '{ANDROID_SDK_TOOLS}'
      key_platform = '{PLATFORM}'
      sdk_url = 'https://dl.google.com'
      sdk_path = '/android/repository/tools_r' + key_sdk_tools + '-' + key_platform + '.zip'
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
      sdk_path[key_sdk_tools] = version
      sdk_path[key_platform] = platform
      @@logger.debug('Installing version ' + version + ' for platform ' + platform + ' with url ' + sdk_url + sdk_path)
      # download_file(sdk_url, sdk_path, 'android-sdk.zip')
      #exec('unzip -q android-sdk.zip -d android-sdk')
      #exec('export ANDROID_HOME=$PWD/android-sdk')
      components = config['components']
      components.each {|component|
        @@logger.debug('Installing component ' + component)
        output = ''
        if Gem.win_platform?
          output = exec('echo y | %ANDROID_HOME%\tools\bin\sdkmanager ' + component)
          @@logger.debug(output)
        else
          output = exec('echo y | $ANDROID_HOME/tools/bin/sdkmanager ' + component)
          @@logger.debug(output)
        end
        puts output
        if output.include? 'Warning'
          puts "\nError installing component " + component + "\n"
          puts output
        end
      }
    end
  end
end
