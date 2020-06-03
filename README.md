 # Prince of Versions

![Bitrise](https://img.shields.io/bitrise/b0d8da8839bc2c85?token=bKDksnKBaI6oQRD861aYBg) ![GitHub](https://img.shields.io/github/license/infinum/iOS-prince-of-versions) ![Cocoapods](https://img.shields.io/cocoapods/v/PrinceOfVersions)[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage) [![Swift Package Manager compatible](https://img.shields.io/badge/Swift%20Package%20Manager-compatible-brightgreen.svg)](https://github.com/apple/swift-package-manager) ![Cocoapods platforms](https://img.shields.io/cocoapods/p/PrinceOfVersions)

<p align="center">
    <img src="./prince-of-versions.svg" width="300" max-width="50%" alt="PoV"/>
</p>

Library checks for updates using configuration from some resource.

## Features

* Load update configuration from **network** resource
* Use predefined parser for parsing update configuration in **JSON format**
* Make **asynchronous** loading and use **callback** for notifying result
* Loading and verifying versions happen **outside of UI thread**

## Requirements

* iOS 8.0+
* macOS 10.10+
* Xcode 10.0+
* Swift 5.0

## Installation

The easiest way to use Prince of versions in your project is using the CocaPods package manager.

#### CocoaPods

See installation instructions for [CocoaPods](http://cocoapods.org) if not already installed

To integrate the library into your Xcode project specify the pod dependency to your `Podfile`:

```ruby
platform :ios, '8.0'
use_frameworks!

pod 'PrinceOfVersions'
```

or

```ruby
platform :osx, '10.10'
use_frameworks!

pod 'PrinceOfVersions'
```

run pod install

```bash
pod install
```

#### Carthage

For the Carthage installation and usage instruction, you can check official [quick start documentation](https://github.com/Carthage/Carthage#quick-start).

To integrate the library into your Xcode project, specify it in your `Cartfile`:

```
github "infinum/iOS-prince-of-versions"
```

Run `carthage update`.

#### Swift Package Manager

To install Prince of Versions from the Swift Package Manager, you should:
* In Xcode 11+ select File → Packages → Add Package Dependency
* Enter project's URL: https://github.com/infinum/iOS-prince-of-versions.git

For more information, check [Swift Package Manager](https://swift.org/package-manager/) .

## JSON file

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
      },
      {
         "required_version":"1.2.3",
         "last_version_available":"2.4.5",
         "notify_last_version_frequency":"ALWAYS",
         "requirements":{
            "required_os_version":"12.1.2"
         },
         "meta":{
            "key3":"value3",
         }
      }
   ],
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
            "bluetooth":"5.0"
         }
      },
      {
         "required_version":"9.0",
         "last_version_available":"11.0",
         "notify_last_version_frequency":"ONCE",
         "requirements":{
            "required_os_version":"10.14.2",
            "region":"us"
         }
      }
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

### Supporting older versions

It is possible to support older versions of PrinceOfVersions, but in that case JSON file will look somewhat different.

JSON still has to follow [Semantic Versioning](http://semver.org/). To specify a configuration for older PrinceOfVersions version, you have to provide an configuration object which conforms older PrinceOfVersions specification under key `ios` or `macos`, depending on a platform, and for current PrinceOfVersions, you have to specify configuration described in previous section under key `ios2` or `macos2`.

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

#### Older PrinceOfVersions configuration form
```json
...
"ios":{
   "minimum_version":"1.2.3",
   "minimum_version_min_sdk":"8.0.0",
   "latest_version":{
      "version":"2.4.5",
      "notification_type":"ALWAYS",
      "min_sdk":"12.1.2"
   }
},
...
```

## Usage

### Loading from network resource

#### Getting all data

  ```swift
  let princeOfVersionsURL = URL(string: https://pastebin.com/raw/0MfYmWGu)!

  PrinceOfVersions.checkForUpdates(from: princeOfVersionsURL, completion: { [unowned self] response in
      switch response.result {
      case .success(let updateResultData):
          self.fillUI(with: updateResultData)
      case .failure:
          // Handle error
          break
      }
  })
  ```

#### Adding-requirements

  ```swift
  let options = PoVRequestOptions()

  options.addRequirement(key: "region") { (value) -> Bool in
      guard let value = value as? String else { return false }
      // Check OS localisation
      return value == "hr"
  }

  options.addRequirement(key: "bluetooth") { (value) -> Bool in
      guard let value = value as? String else { return false }
      // Check device bluetooth version
      return value.starts(with: "5")
  }

  let princeOfVersionsURL = URL(string: https://pastebin.com/raw/0MfYmWGu)!

  PrinceOfVersions.checkForUpdates(from: princeOfVersionsURL, options: options, completion: { [unowned self] response in
      switch response.result {
      case .success(let updateResultData):
          self.fillUI(with: updateResultData)
      case .failure:
          // Handle error
          break
      }
  })
  ```

### Automatic check with data from the App Store

If you don't want to manage the JSON configuration file required by `loadConfiguration` or `checkForUpdates`, you can use `checkForUpdateFromAppStore`. This method will automatically get your app BundleID and it will return version info fetched from the App Store.

However, `updateStatus` result can only assume values `UpdateStatus.noUpdateAvailable` and `UpdateStatus.newUpdateAvailable`. It is not possible to check if update is mandatory by using this method and data provided by the AppStore.

```swift
PrinceOfVersions().checkForUpdateFromAppStore(
    trackPhaseRelease: false,
    completion: { result in
        switch result {
        case .success(let appStoreResult):
        print("Update version: ", appStoreResult.updateVersion)
        print("Installed version: ", appStoreResult.updateInfo.installedVersion)
        print("Update status: ", appStoreResult.updateStatus)
        case .failure:
            // Handle error
        }
    }
)
```

### Multiple targets

If your application has multiple targets you might need more than one JSON configuration file. If that is the case, do not forget to set a different URL for each target.

### Security certificate pinning

If you use certificate pinning for secure communication with the server holding your JSON version file, put the certificate in the app Resource folder (make sure that the certificate has one these extensions: `".cer"`, `".CER"`, `".crt"`, `".CRT"`, `".der"`, `".DER"`).
Prince Of Versions will look for all the certificates in the main bundle. Then set the `shouldPinCertificates` parameter to `true` in the `loadConfiguration` method call.

```swift
let url = URL(string: "https://pastebin.com/raw/ZAfWNZCi")
PrinceOfVersions().loadConfiguration(from: url, shouldPinCertificates: true) { (response) in
    switch response.result {
    case .success(let info):
        if let latestVersion = info.latestVersion {
            print("Is minimum version satisfied: ", latestVersion)
        }
    case .failure(let error):
        print(error.localizedDescription)
    }
}
```

## Contributing

Feedback and code contributions are very much welcome. Just make a pull request with a short description of your changes. By making contributions to this project you give permission for your code to be used under the same [license](https://github.com/infinum/Android-prince-of-versions/blob/dev/LICENCE).
