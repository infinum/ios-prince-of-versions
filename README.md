 # Prince of Versions

![Bitrise](https://img.shields.io/bitrise/b0d8da8839bc2c85?token=bKDksnKBaI6oQRD861aYBg) ![GitHub](https://img.shields.io/github/license/infinum/iOS-prince-of-versions) ![Cocoapods](https://img.shields.io/cocoapods/v/PrinceOfVersions)[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage) [![Swift Package Manager compatible](https://img.shields.io/badge/Swift%20Package%20Manager-compatible-brightgreen.svg)](https://github.com/apple/swift-package-manager) ![Cocoapods platforms](https://img.shields.io/cocoapods/p/PrinceOfVersions)

<p align="center">
    <img src="./prince-of-versions.svg" width="300" max-width="50%" alt="PoV"/>
</p>

## Description

Library checks for updates using configuration from some resource.

### Features

* Load update configuration from **network** resource
* Use predefined parser for parsing update configuration in **JSON format**
* Make **asynchronous** loading and use **callback** for notifying result

## Table of contents

* [Requirements](#requirements)
* [Getting started](#getting-started)
* [Usage](#usage)
* [Privacy](#privacy)
* [Contributing](#contributing)
* [License](#license)
* [Credits](#credits)

## Requirements

* iOS 11.0+
* macOS 10.13+
* Xcode 14.0+

## Getting started

The easiest way to use Prince of versions in your project is using the CocaPods package manager.

#### CocoaPods

See installation instructions for [CocoaPods](http://cocoapods.org) if not already installed

To integrate the library into your Xcode project specify the pod dependency to your `Podfile`:

```ruby
platform :ios, '11.0'
use_frameworks!

pod 'PrinceOfVersions'
```

or

```ruby
platform :osx, '10.13'
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
github "infinum/ios-prince-of-versions"
```

Run `carthage update`.

#### Swift Package Manager

To install Prince of Versions from the Swift Package Manager, you should:
* In Xcode 11+ select File → Packages → Add Package Dependency
* Enter project's URL: https://github.com/infinum/ios-prince-of-versions.git

For more information, check [Swift Package Manager](https://swift.org/package-manager/) .

## JSON File

For JSON file details and formatting, read [JSON specification](JSON.md).

## Usage

### Loading from network resource

#### Getting all data

  ```swift
    let princeOfVersionsURL = URL(string: "https://pastebin.com/raw/0MfYmWGu")!

    PrinceOfVersions.checkForUpdates(
        from: princeOfVersionsURL,
        completion: { [unowned self] response in
            switch response.result {
            case .success(let updateResultData):
                print("Update version: \(updateResultData.updateVersion)")
                print("Installed version: \(updateResultData.updateInfo.installedVersion)")
                print("Update status: \(updateResultData.updateStatus)")
            case .failure:
                // Handle error
                break
            }
        }
    )
  ```
  
#### Request cache policy

When checking for updates, be it for AppStore or other sources, you can provide a *cachePolicy* parameter. The *cachePolicy* parameter determines which request cache policy will be used for network requests.

The initial value for the default `URLSession` configuration uses **.useProtocolCachePolicy**, which shouldn't be the default behavior for Prince of Versions; we want to refresh the data from the server every time. That's why we defaulted the value to **.reloadIgnoringLocalCacheData**. If you want to change the default behavior, you can always provide a different cache policy that suits your needs.

#### Adding-requirements

For each requirement key listed in a configuration, there should exist a requirement check closure. If you don't provide it, the requirement will be considered as not met, and the whole configuration will be discarded. However, if you provide requirement check, but JSON doesn't contain requirement key for your check, the check will be ignored.

> If the JSON contains `required_os_version` key under requirements, the library itself will handle checking if that requirement is met. You don't need to provide a closure.

Here is the example of how to add requirement check closures.

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

  let princeOfVersionsURL = URL(string: "https://pastebin.com/raw/0MfYmWGu")!

  PrinceOfVersions.checkForUpdates(from: princeOfVersionsURL, options: options, completion: { [unowned self] response in
      switch response.result {
      case .success(let updateResultData):
          print("Update version: \(updateResultData.updateVersion)")
          print("Installed version: \(updateResultData.updateInfo.installedVersion)")
          print("Update status: \(updateResultData.updateStatus)")
      case .failure:
          // Handle error
          break
      }
  })
  ```

If you consider following JSON example and requirement checks added in the example above, the first configuration will be considered as not appropriate since requirement check for `free-memory` is not defined. However, all requirements in the second configuration are met and its values will be returned.

```json
...
      {
         "required_version":"1.2.3",
         "last_version_available":"1.9.0",
         "notify_last_version_frequency":"ALWAYS",
         "requirements":{
            "required_os_version":"8.0.0",
            "region":"hr",
            "bluetooth":"5.0",
            "free-memory":"80MB"
         },
      },
      {
         "required_version":"1.2.3",
         "last_version_available":"2.4.5",
         "notify_last_version_frequency":"ALWAYS",
         "requirements":{
            "required_os_version":"12.1.2",
            "region":"hr",
            "bluetooth":"5.0"
         },
      }
...
```

### Automatic check with data from the App Store

If you don't want to manage the JSON configuration file required by `checkForUpdates`, you can use `checkForUpdateFromAppStore`. This method will automatically get your app BundleID and it will return version info fetched from the App Store.

However, `updateStatus` result can only assume values `UpdateStatus.noUpdateAvailable` and `UpdateStatus.newUpdateAvailable`. It is not possible to check if update is mandatory by using this method and data provided by the AppStore.

```swift
PrinceOfVersions.checkForUpdateFromAppStore(
    trackPhaseRelease: false,
    notificationFrequency: .once,
    completion: { result in
        switch result {
        case .success(let appStoreResult):
            print("Update version: \(appStoreResult.updateVersion)")
            print("Installed version: \(appStoreResult.updateInfo.installedVersion)")
            print("Update status: \(appStoreResult.updateStatus)")
        case .failure:
            // Handle error
        }
})
```

It is possible to define update notification frequency with the parameter `notificationFrequency`. If you set the parameter value to `NotificationType.once`, only the first time this methods is called, it will return `UpdateStatus.newUpdateAvailable` if a new version exists, every subsequent call it will return `UpdateStatus.noUpdateAvailable` for that specific version. If described behaviour doesn't suit your needs, you can always set this parameter to `NotificationType.always` and have updateStatus as `UpdateStatus.newUpdateAvailable` when a new version is available.

### Multiple targets

If your application has multiple targets you might need more than one JSON configuration file. If that is the case, do not forget to set a different URL for each target.

### Security certificate pinning

If you use certificate pinning for secure communication with the server holding your JSON version file, put the certificate in the app Resource folder (make sure that the certificate has one these extensions: `".cer"`, `".CER"`, `".crt"`, `".CRT"`, `".der"`, `".DER"`).
Prince Of Versions will look for all the certificates in the main bundle. Then set the `shouldPinCertificates` parameter to `true` in the `loadConfiguration` method call.

```swift
let url = URL(string: "https://pastebin.com/raw/0MfYmWGu")
PrinceOfVersions.checkForUpdates(from: url, shouldPinCertificates: true) { (response) in
    switch response.result {
    case .success(let result):
        if let latestVersion = result.updateInfo.latestVersion {
            print("Is minimum version satisfied: ", latestVersion)
        }
    case .failure(let error):
        print(error.localizedDescription)
    }
}
```

## Privacy

PrinceOfVersions does not collect any user data. We have provided a [privacy manifest](https://github.com/infinum/ios-prince-of-versions/blob/master/Sources/PrinceOfVersions/SupportingFiles/PrivacyInfo.xcprivacy) file that can be included in your app.

## Contributing

We believe that the community can help us improve and build better a product.
Please refer to our [contributing guide](CONTRIBUTING.md) to learn about the types of contributions we accept and the process for submitting them.

To ensure that our community remains respectful and professional, we defined a [code of conduct](CODE_OF_CONDUCT.md) and [coding standards](<https://github.com/infinum/swift-style-guide>) that we expect all contributors to follow.

We appreciate your interest and look forward to your contributions.

## License

```text
Copyright 2024 Infinum

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```

## Credits

Maintained and sponsored by [Infinum](http://www.infinum.com).
<p align="center">
  <a href='https://infinum.com'>
    <picture>
        <source srcset="https://assets.infinum.com/brand/logo/static/white.svg" media="(prefers-color-scheme: dark)">
        <img src="https://assets.infinum.com/brand/logo/static/default.svg">
    </picture>
  </a>
</p>
