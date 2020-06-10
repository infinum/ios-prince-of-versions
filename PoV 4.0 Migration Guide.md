# PrinceOfVersions 4.0 Migration Guide

PrinceOfVersions 4.0 is the latest major release of PrinceOfVersions, library used for checking for updates using configurations from some other source.

## Benefits of Upgrading

* **Multiple configurations:**

  * It is possible to define multiple configuration for the same platform
  * Appropriate configuration will be chosen based on the requirements - if defined in JSON

* **Defining requirements:**

  * Requirements are conditions that have to be met for a configuration to be chosen
  * It is not mandatory for a configuration to have requirements
  * User can decide whatever requirement they think it's necessary
  * `addRequirement` method used to provide requirement check closure
  * `required_os_version` built-in support for checking if required OS version requirement is met as long it is defined in JSON

* **Supporting older versions**

  * If you decide to upgrade PoV to version >= 4.0, both type of users (the ones who have app version with PoV < 4.0 and the ones who have app version with PoV >= 4.0) can be supported with only one JSON, for more information, please check out **JSON Formatting** section.

## Breaking Changes

* **JSON Formatting**

  * JSON formatting has changed, see more [here](JSON.md)

* **Methods**

  * Both `checkForUpdates` and `loadConfiguration` methods are now unified in one method `checkForUpdates`.
  * Return type of new `checkForUpdates` method is `UpdateResult` (see more info under **Return types**).

  * Achieving behaviour from old `checkForUpdates` and `loadConfiguration`:

    * Return type `UpdateInfo` in `loadConfiguration` can be found as a property in `UpdateResult` struct.
    * Closures that were available in old `checkForUpdates` method have been replaced by `UpdateStatus` enum (see more info under **New Features**) which can also be found in `UpdateResult` struct under property `updateStatus`.

* **Return types**

  * Each method for checking whether update exists comes with compatible return type (`UpdateResult`, `AppStoreUpdateResult`).
  * Each return type, in addition to its essential properties `updateStatus`, `updateVersion`, `updateInfo`, possesses some unique properties specialised for method of getting versioning info.

  * `UpdateResult`

    * New return type which contains all information necessary for the update, to use previous `UpdateInfo` just access `updateInfo` property on returned `UpdateResult` struct.
    * Used when getting the versioning information from JSON.
    * `metadata` returns global metadata defined in JSON joined with metadata from the chosen configuration.

  * `AppStoreUpdateResult`

    * Used when getting the versioning information from the AppStore Connect.
    * `phaseReleaseInProgress` returns bool value if phased release period is in progress.

## New Features

* Added parameter `notificationFrequency` to `checkForUpdateFromAppStore` method which is used for setting desired update notification frequency.

* **UpdateStatus**

  * New enum which determines if update exists and if it is mandatory.
  * Contained in `UpdateResult` struct.
  * Replaces closures in old `checkForUpdates` method.
  * Possible values are `noUpdateAvailable`, `requiredUpdateNeeded`, `newUpdateAvailable`.
