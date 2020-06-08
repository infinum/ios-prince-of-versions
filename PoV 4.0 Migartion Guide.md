# PrinceOfVersions 4.0 Migration Guide

PrinceOfVersions 4.0 is the latest major release of PrinceOfVersions, library used for checking for updates using configurations from some other source.

## Benefits of Upgrading

* **Multiple configurations:**

  * It is possible to define multiple configuration for the same platform
  * Appropriate configuration will be chosen based on the requirements


* **Defining requirements:**

  * Requirements are necessary conditions for a configuration to be chosen
  * User can decide whatever requirement they think it's necessary
  * `addRequirement` method used to provide requirement check closure
  * `required_os_version` built-in support for checking if required OS version requirement is met as long it is defined in JSON

## Braking Changes

* `checkForUpdates` method is removed
* `loadConfiguration` method has been renamed to `checkForUpdates`
* JSON formatting has changed

## New Features

* added parameter `notificationFrequency` to `checkForUpdateFromAppStore` method which is used for setting desired update notification frequency
