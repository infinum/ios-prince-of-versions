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
github "infinum/iOS-prince-of-versions"Â
```

Run `carthage update`.

#### Swift Package Manager

To install Prince of Versions from the Swift Package Manager, you should:
* In Xcode 11+ select File → Packages → Add Package Dependency
* Enter project's URL: https://github.com/infinum/iOS-prince-of-versions.git

For more information, check [Swift Package Manager](https://swift.org/package-manager/) .

## JSON File

* [JSON File Specification](JSON.md)

## Usage

### Loading from network resource

#### Getting all data

  ```swift
  let princeOfVersionsURL = URL(string: https://pastebin.com/raw/0MfYmWGu)!

  PrinceOfVersions.checkForUpdates(from: princeOfVersionsURL, completion: { [unowned self] response in
      switch response.result {
      case .success(let updateResultData):
        print("Update version: ", updateResultData.updateVersion)
        print("Installed version: ", updateResultData.updateInfo.installedVersion)
        print("Update status: ", updateResultData.updateStatus)
      case .failure:
          // Handle error
          break
      }
  })
  ```

#### Adding-requirements

For each requirement key listed in a configuration, there has to exist a requirement check closure. If you don't provide it, requirement will be considered as not met, and whole configuration will be discarded.

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

  let princeOfVersionsURL = URL(string: https://pastebin.com/raw/0MfYmWGu)!

  PrinceOfVersions.checkForUpdates(from: princeOfVersionsURL, options: options, completion: { [unowned self] response in
      switch response.result {
      case .success(let updateResultData):
        print("Update version: ", updateResultData.updateVersion)
        print("Installed version: ", updateResultData.updateInfo.installedVersion)
        print("Update status: ", updateResultData.updateStatus)
      case .failure:
          // Handle error
          break
      }
  })
  ```

If you consider following JSON example and requirement checks added in example above, first configurtion will be considered as not appropriate since requirement check for `free-memory` is not defined. However, all requirements in second configurtion are met and it's values will be returned.

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

If you don't want to manage the JSON configuration file required by `loadConfiguration` or `checkForUpdates`, you can use `checkForUpdateFromAppStore`. This method will automatically get your app BundleID and it will return version info fetched from the App Store.

However, `updateStatus` result can only assume values `UpdateStatus.noUpdateAvailable` and `UpdateStatus.newUpdateAvailable`. It is not possible to check if update is mandatory by using this method and data provided by the AppStore.

```swift
PrinceOfVersions.checkForUpdateFromAppStore(
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
})
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
