# PrinceOfVersions 4.0 Migration Guide

PrinceOfVersions 4.0 is the latest major release of PrinceOfVersions, library used for checking for updates using configurations from some other source.

## Benefits of Upgrading

* Multiple configurations now available

## Braking Changes

* `checkForUpdates` method is removed
* `loadConfiguration` method has been renamed to `checkForUpdates`
* JSON formatting has changed

## New Features

* added parameter `notificationFrequency` to `checkForUpdateFromAppStore` method which is used for setting desired update notification frequency
