# Description

This cookbook installs and configures localshop, a pypi server which automatically mirrors and proxies pypi packages and supports the local uploading of private packages.

localshop upstream source is on [github](https://github.com/mvantellingen/localshop).

# Requirements

This cookbook depends on the Opscode `application_python` cookbook.

As of 0.2.0 this cookbook assumes you are using [Needle's fork of localshop](https://github.com/needle/localshop/commits/needle) which implements some changes not yet merged by the upstream maintainers. This fork contains changes required to make localshop more easily deployable as a Django web application.

# Usage

# Attributes

# Recipes

* `default` - installs localshop running under gunicorn and celery
* `nginx_proxy` - installs localshop as above, proxied by nginx

# Author and License

Author:: Cameron Johnston <cameron@needle.com>

Copyright:: 2013, Needle Inc. <cookbooks@needle.com>

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
