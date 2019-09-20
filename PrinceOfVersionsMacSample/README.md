# Prince of Versions Sample App

## Features

* Check info set in https://pastebin.com/raw/LNVA8Gse
* Check app configuration

## Usage

You'll find 2 ViewControllers from where you can check how Prince of Versions could be used. In `ConfigurationViewController` you'll get all informations stored on server as well as current version of the app, while in `AutomaticCheckViewController` you'll only get an info if update is available and if update is mandatory or optional.

You can change the app version from `AppConfiguration.xcconfig` file and Swift/Objective-C version of the `ViewControllers` from the `AppDelegate`.

1. Getting all data

Used in `ConfigurationViewController`.  

```swift
    let url = URL(string: "https://pastebin.com/raw/LNVA8Gse")
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

Used in `AutomaticCheckViewController`. 

```swift
    let url = URL(string: "https://pastebin.com/raw/LNVA8Gse")
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

### Contributing

Feedback and code contributions are very much welcome. Just make a pull request with a short description of your changes. By making contributions to this project you give permission for your code to be used under the same [license](https://github.com/infinum/Android-prince-of-versions/blob/dev/LICENCE).
