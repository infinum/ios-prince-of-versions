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
    "ios": {
        "minimum_version": "1.2.3",
        "minimum_version_min_sdk": "8.0.0",
        "latest_version": {
            "version": "2.4.5",
            "notification_type": "ALWAYS",
            "min_sdk": "12.1.2"
        }
    },
    "macos": {
        "minimum_version": "1.2.3",
        "minimum_version_min_sdk": "10.9.0",
        "latest_version": {
            "version": "2.4.5",
            "notification_type": "ALWAYS",
            "min_sdk": "10.11.0"
        }
    },
    "android": {
        "minimum_version": "1.2.3",
        "latest_version": {
            "version": "2.4.5",
            "notification_type": "ONCE"
        }
    },
    "meta": {
        "key1": "value1",
        "key2": "value2"
    }
}
```

Depending on `notification_type` property, the user can be notified `ONCE` or `ALWAYS`. The library handles this for you, and if notification type is set to `ONCE`, it will notify you via `newUpdate(version: String, isMandatory: Bool, metadata: [String: AnyObject]?)` method only once. Every other time the library will return `noUpdate` for that specific version. 

By setting min required iOS version with `minimum_version_min_sdk` for mandatory updates and `min_sdk` for optional updates, library will notify you about new versions only if user have same or later version of iOS installed on device. If specified version is greater than installed one, library will return `noUpdate`.

Key-value pairs under `"meta"` key are optional metadata of which any amount can be sent accompanying the required fields.

## Usage

### Most common usage - loading from network resource

1. Getting all data

    ```swift
    let url = URL(string: "https://pastebin.com/raw/ZAfWNZCi")
        PrinceOfVersions().loadConfiguration(from: url) { response in
            switch response.result {
            case .success(let info):
                print("Minimum version: ", info.minimumRequiredVersion)
                print("Installed version: ", info.installedVersion)
                print("Is minimum version satisfied: ", info.isMinimumVersionSatisfied)
                print("Notification type: ", info.notificationType)

                if let latestVersion = info.latestVersion {
                    print("Is minimum version satisfied: ", latestVersion)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    ```

2. Automatic handling update frequency

    ```swift
    let url = URL(string: "https://pastebin.com/raw/ZAfWNZCi")
    PrinceOfVersions().checkForUpdates(from: url,
        newVersion: { (latestVersion, isMinimumVersionSatisfied, metadata) in
            ...
        },
        noNewVersion: { (isMinimumVersionSatisfied, metadata) in
            ...
        },
        error: { error in
            ...
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
