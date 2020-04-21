//
//  ObjCConfigurationController.m
//  PrinceOfVersionsMacSample
//
//  Created by Jasmin Abou Aldan on 20/09/2019.
//  Copyright © 2019 infinum. All rights reserved.
//

#import "ObjCConfigurationController.h"
#import "PrinceOfVersionsMacSample-Swift.h"

@import PrinceOfVersions;

@interface ObjCConfigurationController ()

 @property (nonatomic, weak) IBOutlet NSTextField *installedVersionTextField;
 @property (nonatomic, weak) IBOutlet NSTextField *macOSVersionTextField;

 @property (nonatomic, weak) IBOutlet NSTextField *minimumVersionTextField;
 @property (nonatomic, weak) IBOutlet NSTextField *minimumSDKTextField;
 @property (nonatomic, weak) IBOutlet NSTextField *latestVersionTextField;
 @property (nonatomic, weak) IBOutlet NSTextField *notificationTypeTextField;
 @property (nonatomic, weak) IBOutlet NSTextField *updateStatusTextField;
 @property (nonatomic, weak) IBOutlet NSTextField *latestMinimumSDKTextField;
 @property (nonatomic, weak) IBOutlet NSTextField *metaTextField;

@end

@implementation ObjCConfigurationController

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do view setup here.
    [self checkAppVersion];
    [self checkAppStoreVersion];
}

#pragma mark - Private methods

- (void)checkAppVersion
{
    NSURL *princeOfVersionsURL = [NSURL URLWithString:Constant.princeOfVersionsURL];

    __weak __typeof(self) weakSelf = self;
    [[PrinceOfVersions new] checkForUpdatesFromURL:princeOfVersionsURL completion:^(UpdateResponse *updateResponse) {
        [weakSelf fillUIWithInfoResponse:updateResponse.result];
    } error:^(NSError *error) {
        // Handle error
    }];
}

// In sample app, error will occur as bundle ID
// of the app is not available on the App Store

- (void)checkAppStoreVersion
{
    PoVOptions *options = [PoVOptions new];
    options.trackPhaseRelease = NO;

    [[[PrinceOfVersions alloc] initWithOptions:options] checkForUpdateFromAppStoreWithCompletion:^(AppStoreInfoObject *response) {
        // Handle success
    } error:^(NSError *error) {
        // Handle error
    }];
}

- (void)fillUIWithInfoResponse:(UpdateResultObject *)infoResponse
{
    self.installedVersionTextField.stringValue = infoResponse.versionInfo.installedVersion.description;
//    self.macOSVersionTextField.stringValue = infoResponse.sdkVersion.description;
    self.minimumVersionTextField.stringValue = infoResponse.versionInfo.requiredVersion.description;
//    self.minimumSDKTextField.stringValue = infoResponse.minimumSdkForMinimumRequiredVersion.description;
    self.latestVersionTextField.stringValue = infoResponse.versionInfo.lastVersionAvailable.description;
    self.notificationTypeTextField.stringValue = infoResponse.versionInfo.notificationType == UpdateNotificationTypeOnce ? @"Once" : @"Always";
//    self.latestMinimumSDKTextField.stringValue = infoResponse.minimumSdkForLatestVersion.description;
    self.updateStatusTextField.stringValue = [self updateStateFromResult:infoResponse.updateState];
    self.metaTextField.stringValue = [NSString stringWithFormat:@"%@", infoResponse.metadata];
}

- (NSString *)updateStateFromResult:(UpdateStatusType)type
{
    switch (type) {
        case UpdateStatusTypeNoUpdateAvailable:
            return @"No Update Available";
        case UpdateStatusTypeRequiredUpdateNeeded:
            return @"Required Update Needed";
        case UpdateStatusTypeNewUpdateAvailable:
            return @"New Update Available";
    }
}

@end
