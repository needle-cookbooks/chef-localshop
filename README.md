# Description

This cookbook installs and configures localshop, a pypi server which automatically mirrors and proxies pypi packages and supports the local uploading of private packages.

localshop upstream source is on [github](https://github.com/mvantellingen/localshop).

# Requirements

This cookbook depends on the Opscode `application_python` cookbook.

As of this writing, the cookbook assumes you are using Needle's forks of the [application_python](https://github.com/needle-cookbooks/application_python/commits/needle) cookbook and [localshop](https://github.com/needle/localshop/commits/needle), both of which implement some changes not yet merged by the respective upstream maintainers.

The `application_python` fork includes fixes for [COOK-2330](http://tickets.opscode.com/browse/COOK-2330) and [COOK-2337](http://tickets.opscode.com/browse/COOK-2337), and the localshop fork contains changes required to make localshop more easily deployable as a Django web application.

# Usage

Add `localshop::default` to your run list.

The app will create an sqlite3 database for storing data. After installation you will need to manually configure superuser credentials before you can use localshop.

## Creating a superuser

1. Use 'su' to become the localshop user

    ```su - nobody```

2. Activate the python virtualenv

    ```. /opt/localshop/shared/env/bin/activate```

3. Set the LOCALSHOP_HOME environment variable

    ```export LOCALSHOP_HOME="/opt/localshop/shared"```

4. Run the 'createsuperuser' manage command

    ```/opt/localshop/current/manage.py createsuperuser```

# Attributes

* localshop.dir - root directory for deploying localshop (defaults to '/opt/localshop')
* localshop.storage_dir - directory for storing localshop packages (defaults to '/opt/localshop/shared/storage')
* localshop.user - user to deploy localshop as (defaults to 'nobody')
* localshop.group - group for ownership permissions (defaults to 'nogroup')
* localshop.address - ip address to bind to (defaults to 0.0.0.0)
* localshop.port - port to bind to (int required, defaults to 8080)
* localshop.delete_files - controls cleanup of files after deleting a package or release (defaults to false)
* localshop.distribution_storage - dotted import path of Django storage class to be used (defaults to 'storages.backends.overwrite.OverwriteStorage')
* localshop.tz - timezone to use (defaults to 'Etc/UTC')
* localshop.repository - git repository to deploy from
* localshop.revision - git revision to deploy
* localshop.secret_key - secret key passed to localshop.conf.py (default is randomly generated)

# Recipes

* `default` - installs localshop running under gunicorn and celery

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
