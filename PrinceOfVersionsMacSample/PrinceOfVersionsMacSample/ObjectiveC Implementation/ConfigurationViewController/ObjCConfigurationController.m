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

@property (nonatomic, weak) IBOutlet NSTextField *updateVersionTextField;
@property (nonatomic, weak) IBOutlet NSTextField *updateStateTextField;
@property (nonatomic, weak) IBOutlet NSTextField *metaTextField;

@property (nonatomic, weak) IBOutlet NSTextField *requiredVersionTextField;
@property (nonatomic, weak) IBOutlet NSTextField *lastVersionAvailableTextField;
@property (nonatomic, weak) IBOutlet NSTextField *installedVersionTextField;
@property (nonatomic, weak) IBOutlet NSTextField *notificationTypeTextField;
@property (nonatomic, weak) IBOutlet NSTextField *requirementsTextField;

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

    PoVRequestOptions *options = [PoVRequestOptions new];
    [options addRequirementWithKey:@"region" requirementCheck:^BOOL (id value) {
        // Check OS localisation
        return [(NSString *)value isEqualToString:@"hr"];
    }];

    [options addRequirementWithKey:@"bluetooth" requirementCheck:^BOOL (id value) {
        // Check device bluetooth version
        return [(NSString *)value hasPrefix:@"5"];
    }];

    __weak __typeof(self) weakSelf = self;
    [PrinceOfVersions checkForUpdatesFromURL:princeOfVersionsURL options:options completion:^(UpdateResponse *updateResponse) {
        [weakSelf fillUIWithInfoResponse:updateResponse.result];
    } error:^(NSError *error) {
        // Handle error
    }];
}

// In sample app, error will occur as bundle ID
// of the app is not available on the App Store

- (void)checkAppStoreVersion
{
    [PrinceOfVersions checkForUpdateFromAppStoreWithTrackPhaseRelease:NO callbackQueue:dispatch_get_main_queue()  completion:^(AppStoreInfoObject *response) {
        // Handle success
    } error:^(NSError *error) {
        // Handle error
    }];
}

- (void)fillUIWithInfoResponse:(UpdateResultObject *)infoResponse
{
    self.updateVersionTextField.stringValue = infoResponse.updateVersion.description;
    self.updateStateTextField.stringValue = [self updateStateFromResult:infoResponse.updateState];
    self.metaTextField.stringValue = [NSString stringWithFormat:@"%@", infoResponse.metadata];;

    self.requiredVersionTextField.stringValue = infoResponse.versionInfo.updateData.requiredVersion.description;
    self.lastVersionAvailableTextField.stringValue = infoResponse.versionInfo.updateData.lastVersionAvailable.description;
    self.installedVersionTextField.stringValue = infoResponse.versionInfo.updateData.installedVersion.description;
    self.notificationTypeTextField.stringValue = infoResponse.versionInfo.notificationType == UpdateNotificationTypeOnce ? @"ONCE" : @"ALWAYS";
    self.requirementsTextField.stringValue = [NSString stringWithFormat:@"%@", infoResponse.versionInfo.updateData.requirements];
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
