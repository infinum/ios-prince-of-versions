# JSON File

## JSON-format

JSON file in your application has to follow [Semantic Versioning](http://semver.org/) and it has to look like this:

```json
{
   "ios":[
      {
         "required_version":"1.2.3",
         "last_version_available":"1.9.0",
         "notify_last_version_frequency":"ALWAYS",
         "requirements":{
            "required_os_version":"8.0.0",
            "region":"hr",
            "bluetooth":"5.0"
         },
         "meta":{
            "key1":"value1",
            "key2":2
         }
      }
   ],
   "macos":[
      {
         "required_version":"10.10.0",
         "last_version_available":"11.0",
         "notify_last_version_frequency":"ALWAYS",
         "requirements":{
            "required_os_version":"10.12.1",
            "region":"hr",
            "bluetooth":"5.0"
         }
      },
   ],
   "meta":{
      "key3":true,
      "key4":"value2"
   }
}
```

Library will decide which configuration to use based on the platform used and requirements listed under `requirements` key.
> First configuration that meets all the requirements will be used to determine update status.

In the `requirements` array, parameter `required_os_version` is **mandatory** for every configuration. Every other parameter is optional, and it is on the user to decide which requirements are needed to be satisfied. Requirements (besides `required_os_version`) will be checked with closures provided by the user. Closure can be provided by `addRequirement` [method](#Adding-requirements) in `PoVRequestOptions` class. If requirement closure is not supplied for a given requirement key, library will consider that requirement as **not satisfied**.

If there is not even one configuration that satisfies all requirements (including `required_os_version`), library will set `updateStatus` value to `UpdateStatus.noUpdateAvailable`.

Depending on `notify_last_version_frequency` property, the user can be notified `ONCE` or `ALWAYS`. The library handles this for you. If notification frequency is set to `ONCE`, in the result values which are returned, the value of `updateStatus` will be set to `UpdateStatus.newUpdateAvailable`. Every subsequent call, the library will set the value of `updateStatus` to `UpdateStatus.noUpdateAvailable` for that specific version.

Key-value pairs under `"meta"` key are optional metadata of which any amount can be sent accompanying the required fields. Metadata can be specified for each configuration and it can also be specified on a global level. In the return values, global metadata and metadata from the appropriate configuration will be merged. If there is not an appropriate configuration, only global metadata will be returned.

## Supporting older versions (< 4.0)

To support PrinceOfVersions versions less than 4.0, JSON file will look somewhat different.

JSON still has to follow [Semantic Versioning](http://semver.org/).

* PrinceOfVersions version < 4.0

  You have to provide an configuration object which conforms older PrinceOfVersions (< 4.0) specification under key `ios` or `macos`, depending on a platform.

* PrinceOfVersions version >= 4.0

  You have to specify configuration described in [previous section](#JSON-format) under key `ios2` or `macos2`.

Described JSON format is displayed below:

```json
{
   "ios":{
      "minimum_version":"1.2.3",
      "minimum_version_min_sdk":"8.0.0",
      "latest_version":{
         "version":"2.4.5",
         "notification_type":"ALWAYS",
         "min_sdk":"12.1.2"
      }
   },
   "ios2":[
      {
         "required_version":"1.2.3",
         "last_version_available":"1.9.0",
         "notify_last_version_frequency":"ALWAYS",
         "requirements":{
            "required_os_version":"8.0.0",
            "region":"hr",
            "bluetooth":"5.0"
         },
         "meta":{
            "key1":"value1",
            "key2":2
         }
      }
   ],
   "macos":{
      "minimum_version":"1.2.3",
      "minimum_version_min_sdk":"10.9.0",
      "latest_version":{
         "version":"2.4.5",
         "notification_type":"ALWAYS",
         "min_sdk":"10.11.0"
      }
   },
   "macos2":[
      {
         "required_version":"10.10.0",
         "last_version_available":"11.0",
         "notify_last_version_frequency":"ALWAYS",
         "requirements":{
            "required_os_version":"10.12.1"
         }
      }
   ],
   "meta":{
      "key3":true,
      "key4":"value2"
   }
}
```
