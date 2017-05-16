# dropbox-deployment
Deploy your CI artifacts to Dropbox

[![Build Status](https://travis-ci.org/Jawnnypoo/dropbox-deployment.svg?branch=master)](https://travis-ci.org/Jawnnypoo/dropbox-deployment)
[![Gem](https://img.shields.io/gem/v/dropbox-deployment.svg)](https://rubygems.org/gems/dropbox-deployment)

## Setup
Install the gem:
```
gem install dropbox-deployment
```
This may vary in where this should go depending on your CI setup.
If you are using Travis, it would look something like:
```
before_install:
- rvm install 2.2.6
- gem install dropbox-deployment
```
## Usage
Similar to the [dropbox_api](https://github.com/Jesus/dropbox_api), you need to have an environment variable called `DROPBOX_OAUTH_BEARER`

You can create a OAUTH token here:
https://www.dropbox.com/developers/apps/create

Deployment looks for a `dropbox-deployment.yml` file in order to configure where the artifacts are and where they should go.
For example:
```yml
deploy:
  dropbox_path: /Builds # The path to the folder on Dropbox where the files will go
  artifacts_path: artifacts # can be a single file, or a path
  debug: true # if you want to see more logs
```
After creating this configuration, all you need to do is run:
```shell
dropbox-deployment
```
This place where this goes also can vary depending on the CI setup.
If you are using Travis, you would want this as follows:
```
after_success:
  - dropbox-deployment
```

## Limitations
Since we rely on a certain function of the Ruby Dropbox API client, we are limited to 150 MB per file size. See more [here](http://jesus.github.io/dropbox_api/DropboxApi/Client.html#upload-instance_method)

## Test Locally
Just run `ruby test/test.rb`. Set up your `dropbox-deployment.yml` as desired, as well as your `.env` file for your OAUTH token.

## Deployment
1. Adjust the version in the gemspec
2. `gem build dropbox-deployment.gemspec`
3. `gem push dropbox-deployment-version.number.here.gem`
4. Tag release in git

## Thanks
Thanks to the following for being a great reference on how to create a command line Ruby Gem:
  - http://robdodson.me/how-to-write-a-command-line-ruby-gem/

## License

dropbox-deployment is available under the MIT license. See the LICENSE file for more info.
