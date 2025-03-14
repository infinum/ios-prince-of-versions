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
    [options addRequirementWithKey:@"region"
                            ofType:[NSString class]
                  requirementCheck:^BOOL(NSString *value) {
        // Check OS localisation
        return [value isEqualToString:@"hr"];
    }];

    [options addRequirementWithKey:@"bluetooth"
                            ofType:[NSString class]
                  requirementCheck:^BOOL(NSString *value) {
        // Check device bluetooth version
        return [value hasPrefix:@"5"];
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
    [PrinceOfVersions checkForUpdateFromAppStoreWithTrackPhasedRelease:NO completion:^(AppStoreUpdateResult *response) {
        // Handle success
    } error:^(NSError *error) {
        // Handle error
    }];
}

- (void)fillUIWithInfoResponse:(UpdateResult *)infoResponse
{
    self.updateVersionLabel.text = infoResponse.updateVersion.description;
    self.updateStateLabel.text = [self updateStateFromResult:infoResponse.updateState];
    self.metaLabel.text = infoResponse.metadata.description;

    UpdateInfo *versionInfo = infoResponse.updateInfo;

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
