# Redmine Close Issue Button Plugin

This plugin adds the **Close** button to the issue toolbar in Redmine.

## Compatibility

This plugin is tested against Redmine **5.1**, **6.0**, **6.1** and **7.0** using the
official Redmine Docker images (see [Testing](#testing)). Older versions are not
tested, but may still work.

## Installation

*These installation instructions are based on Redmine 2.6.0. For instructions for previous versions, see [Redmine wiki](http://www.redmine.org/projects/redmine/wiki/Plugins).*

1. To install the plugin
    * Download the .ZIP archive, extract files and copy the plugin directory into *#{REDMINE_ROOT}/plugins*.
    
    Or

    * Change you current directory to your Redmine root directory:  

            cd {REDMINE_ROOT}
 
      Copy the plugin from GitHub using the following command:

            git clone https://github.com/Undev/redmine_close_button.git plugins/redmine_close_button

2. Update the Gemfile.lock file by running the following commands:  

         rm Gemfile.lock  
         bundle install

3. Restart Redmine.

Now you should be able to see the plugin in **Administration > Plugins**.
 
## Usage

This plugin adds the **Close** button to the issue toolbar in Redmine. The **Close** button is displayed if the following conditions are met:

* A user is allowed to close the issue.
* The issue is neither closed nor rejected.

To close the issue, click the **Close** button on the issue toolbar.
![close link on toolbar](close_button_1.PNG)

This will change the issue status to **Closed** and its progress to **100%**.
![close link result](close_button_2.PNG)

## Testing

The plugin is verified against the official [Redmine Docker images](https://hub.docker.com/_/redmine).
With Docker available, run:

```bash
test/docker/run.sh          # all supported Redmine versions
test/docker/run.sh 7.0      # a single version
```

Each run starts `redmine:<version>` with this directory mounted as
`plugins/redmine_close_button` and asserts that the plugin registers and that the
close button and its assets are rendered on an issue page. The same tests run in CI
for every push and pull request.

## Versioning and releases

The `VERSION` file is the single source of truth for the plugin version; `init.rb`
reads it when registering the plugin. To release:

1. Bump `VERSION`.
2. Add a matching `### <version>` section at the top of `CHANGES.md`.
3. Push a `v<version>` tag. The release workflow validates that the tag matches
   `VERSION`, builds `redmine_close_button-<version>.zip` and publishes a GitHub
   release with the changelog section as release notes.

## Maintainers

Akzhan Abdulin, [github.com/akzhan](https://github.com/akzhan)

## License

Copyright (c) 2015 Undev

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
