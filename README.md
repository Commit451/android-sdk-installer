# android-sdk-installer
Easy Android SDK installation for CI servers

[![Build Status](https://travis-ci.org/Commit451/android-sdk-installer.svg?branch=master)](https://travis-ci.org/Commit451/android-sdk-installer)
[![Gem](https://img.shields.io/gem/v/android-sdk-installer.svg)](https://rubygems.org/gems/android-sdk-installer)

## Setup
Install the gem:
```
gem install android-sdk-installer
```

## Usage
The installer looks for a `android-sdk-installer.yml` file in order to configure where the artifacts are and where they should go.
For example:
```yaml
platform: linux
components:
  - build-tools;25.0.3
  - platforms;android-25
  - extras;android;m2repository # support libs
  - extras;google;m2repository # google play services lib
```
After creating this configuration, all you need to do is run:
```shell
android-sdk-installer
```
If you run `android-sdk-installer` with no `android-sdk-installer.yml` present, the [sdkmanager](https://developer.android.com/studio/command-line/sdkmanager.html) will be installed.

## Version
Version is the SDK Tools version, defaulting to 26.0.2 (3859397). The latest version number can be found at the bottom of the page [here](https://developer.android.com/studio/index.html) as a part of the download URL.

## Platform
Currently supported platforms are `linux` and `darwin` (macosx). `windows` is not supported. Defaults to `linux`. Assumes that [unzip](https://linux.die.net/man/1/unzip) is available (may require install).

## Components
The components are defined by the [sdkmanager](https://developer.android.com/studio/command-line/sdkmanager.html) command line tool. You can get a list of available components by running:
```shell
sdkmanager --list
```
on a machine with the Android SDK installed.

## Config
Additional configuration can be added to `android-sdk-installer.yml`. The following is a complete example with all possible values:
```yaml
platform: linux # the platform
version: 3859397 # the version
debug: true # more logs
ignore_existing: true # command line tools will not install if ANDROID_HOME is found. Forces installation 
components: # list of the components to install
  - build-tools;25.0.3
```
If no `android-sdk-installer.yml` file is found, the default command line tools will be installed (for linux)

## Options
In addition to configuration within `android-sdk-installer.yml`, some configuration can be done via command line arguments. To see a list of the options, run `android-sdk-installer -h`

## Travis
Usage with Travis can be a little odd due to the fact that `ANDROID_HOME` needs to be set before install. Here is an example configuration:
```yml
language: java

env:
  - ANDROID_HOME=$PWD/android-sdk

jdk:
  - oraclejdk8

before_install:
  - rvm install 2.3.4
  - gem install android-sdk-installer
  - android-sdk-installer -i

script: "./gradlew build"
```

## Test
Just run `ruby test/test.rb`. Set up your `android-sdk-installer.yml` as desired.

## Deployment
1. Adjust the version in the gemspec
2. `gem build android-sdk-installer.gemspec`
3. `gem push android-sdk-installer-version.number.here.gem`
4. Tag release in git

## Note
This tool will automatically accept licenses for the Android SDK, and will add files indicating that you have accepted the Android SDK licenses. Please read and understand these licenses before using this tool and assure you agree with the terms. 

## Thanks
Thanks to the following for being a great reference on how to create a command line Ruby Gem:
  - http://robdodson.me/how-to-write-a-command-line-ruby-gem/
  - https://github.com/cesarferreira/dryrun

## License

android-sdk-installer is available under the MIT license. See the LICENSE file for more info.
