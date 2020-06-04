//
//  ObjC-ConfigurationViewController.m
//  PrinceOfVersionsSample
//
//  Created by Jasmin Abou Aldan on 13/09/2019.
//  Copyright © 2019 infinum. All rights reserved.
//

#import "ObjCConfigurationViewController.h"
#import "PrinceOfVersionsIosSample-Swift.h"

@import PrinceOfVersions;

@interface ObjCConfigurationViewController ()

@property (nonatomic, weak) IBOutlet UILabel *updateVersionLabel;
@property (nonatomic, weak) IBOutlet UILabel *updateStateLabel;
@property (nonatomic, weak) IBOutlet UILabel *metaLabel;

@property (nonatomic, weak) IBOutlet UILabel *requiredVersionLabel;
@property (nonatomic, weak) IBOutlet UILabel *lastVersionAvailableLabel;
@property (nonatomic, weak) IBOutlet UILabel *installedVersionLabel;
@property (nonatomic, weak) IBOutlet UILabel *notificationTypeLabel;
@property (nonatomic, weak) IBOutlet UILabel *requirementsLabel;

@end

@implementation ObjCConfigurationViewController

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Do any additional setup after loading the view.
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

        if ([value isKindOfClass:[NSString class]]) {
            return [(NSString *)value isEqualToString:@"hr"];
        }

        return NO;
    }];

    [options addRequirementWithKey:@"bluetooth" requirementCheck:^BOOL (id value) {

        // Check device bluetooth version

        if ([value isKindOfClass:[NSString class]]) {
            return [(NSString *)value hasPrefix:@"5"];
        }

        return NO;
    }];

    __weak __typeof(self) weakSelf = self;
    [PrinceOfVersions checkForUpdatesFromURL:princeOfVersionsURL options:options completion:^(UpdateResponse *updateResponse) {
        [weakSelf fillUIWithInfoResponse:updateResponse.result];
    } error:^(NSError *error) {
        /* Handle error */
    }];
}

// In sample app, error will occur as bundle ID
// of the app is not available on the App Store

- (void)checkAppStoreVersion
{
    [PrinceOfVersions checkForUpdateFromAppStoreWithTrackPhasedRelease:NO completion:^(AppStoreUpdateResultObject *response) {
        // Handle success
    } error:^(NSError *error) {
        // Handle error
    }];
}

- (void)fillUIWithInfoResponse:(UpdateResultObject *)infoResponse
{
    self.updateVersionLabel.text = infoResponse.updateVersion.description;
    self.updateStateLabel.text = [self updateStateFromResult:infoResponse.updateState];
    self.metaLabel.text = infoResponse.metadata.description;

    UpdateInfoObject *versionInfo = infoResponse.updateInfo;

    self.requiredVersionLabel.text =
    versionInfo.requiredVersion.description;
    self.lastVersionAvailableLabel.text = versionInfo.lastVersionAvailable.description;
    self.installedVersionLabel.text = versionInfo.installedVersion.description;
    self.notificationTypeLabel.text = versionInfo.notificationType == UpdateNotificationTypeOnce ? @"ONCE" : @"ALWAYS";
    self.requirementsLabel.text = versionInfo.requirements.description;
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
