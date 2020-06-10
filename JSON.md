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

For more details about requirements, check out [this section](#Requirements).

* **Notification frequency**

Depending on `notify_last_version_frequency` property, the user can be notified `ONCE` or `ALWAYS`. The library handles this for you. If notification frequency is set to `ONCE`, in the result values which are returned, the value of `updateStatus` will be set to `UpdateStatus.newUpdateAvailable`. Every subsequent call, the library will set the value of `updateStatus` to `UpdateStatus.noUpdateAvailable` for that specific version.

* **Metadata**

Key-value pairs under `"meta"` key are optional metadata of which any amount can be sent accompanying the required fields. Metadata can be specified for each configuration and it can also be specified on a global level. In the return values, global metadata and metadata from the appropriate configuration will be merged. If there is not an appropriate configuration, only global metadata will be returned.

## Supporting older versions (< 4.0)

To support PrinceOfVersions versions less than 4.0, JSON file will look somewhat different.

JSON still has to follow [Semantic Versioning](http://semver.org/).

* **PrinceOfVersions version < 4.0**

  You have to provide an configuration object which conforms older PrinceOfVersions (< 4.0) specification under key `ios` or `macos`, depending on a platform.

* **PrinceOfVersions version >= 4.0**

  You have to specify configuration described in [previous section](#JSON-format). Configuration should be stored under key `ios2` or `macos2`.

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

## Requirements

For every configuration, there is a possibility to define requirements. Based on the provided requirements and user-provided requirements checks, the appropriate configuration will be chosen and evaluated for update status.

> If you don't provide any requirements for a configuration in JSON, that configuration will be classified as valid.

Defining requirements is possible through `requirements array`. It is up to you to choose which requirements are necessary for your configuration. However, for setting required operating system version requirement, you can use key `required_os_version`. By using that key, library will provide requirement check so the user doesn't have to define it. Every other requirement in configuration will be checked with closures provided by the user. Closure can be provided by `addRequirement` [method](README.md#Adding-requirements) in `PoVRequestOptions` class.  If requirement closure is not supplied for a given requirement key, library will consider that requirement as **not satisfied**.

> If there is not even one configuration that satisfies all requirements (including `required_os_version`), library will set `updateStatus` value to `UpdateStatus.noUpdateAvailable`.

So to sum up, chosen configuration depends on requirements in JSON, requirement checks provided by the user and it's position in configurations array in JSON. For more info, please check [example section](#Examples).

### Examples

* Configurations without requirements

```json
  ...
   "ios":[
      {
         "required_version":"1.2.4",
         "last_version_available":"1.8.0",
         "notify_last_version_frequency":"ALWAYS"
      },
      {
         "required_version":"1.2.3",
         "last_version_available":"1.8.0",
         "notify_last_version_frequency":"ONCE"
      }
   ]
   ...
```

In this example, first configuration will always be chosen whether or not user provides requirement checks.

* Configurations with increasing requirements count

```json
{
   "macos":[
      {
         "required_version":"10.10.0",
         "last_version_available":"11.0",
         "notify_last_version_frequency":"ALWAYS",
         "requirements":{
            "required_os_version":"10.12.1"
         }
      },
      {
         "required_version":"9.1",
         "last_version_available":"11.0",
         "notify_last_version_frequency":"ALWAYS",
         "requirements":{
            "required_os_version":"10.11.1",
            "region":"hr",
         }
      },
      {
         "required_version":"9.0",
         "last_version_available":"11.0",
         "notify_last_version_frequency":"ONCE",
         "requirements":{
            "required_os_version":"10.14.2",
            "region":"us",
            "bluetooth":"5.0"
         }
      },
   ]
}
```

For the sake of this example, let's say that all required OS versions are met. In this example, the first configuration will always be chosen since all requirements are met, second and third configuration won't be evaluated no matter if user defined requirement checks for `region` or `Bluetooth`.

* Configuration with decreasing requirements count

```json
{
   "macos":[
      {
         "required_version":"9.0",
         "last_version_available":"11.0",
         "notify_last_version_frequency":"ONCE",
         "requirements":{
            "required_os_version":"10.14.2",
            "region":"us",
            "bluetooth":"5.0"
         }
      },
      {
         "required_version":"9.1",
         "last_version_available":"11.0",
         "notify_last_version_frequency":"ALWAYS",
         "requirements":{
            "required_os_version":"10.11.1",
            "region":"hr"
         }
      },
      {
         "required_version":"10.10.0",
         "last_version_available":"11.0",
         "notify_last_version_frequency":"ALWAYS",
         "requirements":{
            "required_os_version":"10.12.1"
         }
      }
   ]
}
```

Here we will also consider `required_os_version` requirement as met. If user provided requirement checks for both region and Bluetooth and they are both met, first configuration will be chosen. If user provided check only for `region`, only second and third configuration would be considered, since `bluetooth` requirement is not met.

## Final thoughts

* You can define requirements in any kind of way that you want and in any sort of order, but be aware that their order profoundly affects the way they are chosen.
* Best practice would be to put configuration without any requirements (or only with `required_os_version` requirement) on the bottom of the list since all other configurations after this one will be ignored.


[:arrow_left: Go back](README.md)
