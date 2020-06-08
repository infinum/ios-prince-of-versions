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

        if (![value isKindOfClass:[NSString class]]) {
            return NO;
        }

        return [(NSString *)value isEqualToString:@"hr"];
    }];

    [options addRequirementWithKey:@"bluetooth" requirementCheck:^BOOL (id value) {

        // Check device bluetooth version

        if (![value isKindOfClass:[NSString class]]) {
            return NO;
        }

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
    [PrinceOfVersions checkForUpdateFromAppStoreWithTrackPhasedRelease:NO completion:^(AppStoreUpdateResult *response) {
        // Handle success
    } error:^(NSError *error) {
        // Handle error
    }];
}

- (void)fillUIWithInfoResponse:(UpdateResult *)infoResponse
{
    self.updateVersionTextField.stringValue = infoResponse.updateVersion.description;
    self.updateStateTextField.stringValue = [self updateStateFromResult:infoResponse.updateState];
    self.metaTextField.stringValue = infoResponse.metadata.description;

    self.requiredVersionTextField.stringValue = infoResponse.updateInfo.requiredVersion.description;
    self.lastVersionAvailableTextField.stringValue = infoResponse.updateInfo.lastVersionAvailable.description;
    self.installedVersionTextField.stringValue = infoResponse.updateInfo.installedVersion.description;
    self.notificationTypeTextField.stringValue = infoResponse.updateInfo.notificationType == UpdateNotificationTypeOnce ? @"ONCE" : @"ALWAYS";
    self.requirementsTextField.stringValue = infoResponse.updateInfo.requirements.description;
}

- (NSString *)updateStateFromResult:(UpdateStatus)type
{
    switch (type) {
        case UpdateStatusNoUpdateAvailable:
            return @"No Update Available";
        case UpdateStatusRequiredUpdateNeeded:
            return @"Required Update Needed";
        case UpdateStatusNewUpdateAvailable:
            return @"New Update Available";
    }
}

@end
