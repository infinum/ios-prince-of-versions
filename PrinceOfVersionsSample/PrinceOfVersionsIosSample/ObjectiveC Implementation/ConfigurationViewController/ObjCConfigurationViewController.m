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

@property (nonatomic, weak) IBOutlet UILabel *installedVersionLabel;
@property (nonatomic, weak) IBOutlet UILabel *iOSVersionLabel;

@property (nonatomic, weak) IBOutlet UILabel *updateVersionLabel;
@property (nonatomic, weak) IBOutlet UILabel *updateStateLabel;
@property (nonatomic, weak) IBOutlet UILabel *metaLabel;

@property (nonatomic, weak) IBOutlet UILabel *requiredVersionLabel;
@property (nonatomic, weak) IBOutlet UILabel *lastVersionAvailableLabel;
@property (nonatomic, weak) IBOutlet UILabel *installedVersionLabel1;
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

    __weak __typeof(self) weakSelf = self;
    [PrinceOfVersions checkForUpdatesFromURL:princeOfVersionsURL completion:^(UpdateResponse *updateResponse) {
        [weakSelf fillUIWithInfoResponse:updateResponse.result];
    } error:^(NSError *error) {
        /* Handle error */
    }];
}

// In sample app, error will occur as bundle ID
// of the app is not available on the App Store

- (void)checkAppStoreVersion
{
//    PoVRequestOptions *options = [PoVRequestOptions new];
//    options.trackPhaseRelease = NO;

//    [PrinceOfVersions checkForUpdateFromAppStoreWithOptions:options completion:^(AppStoreInfoObject *infoObject) {
//        // Handle success
//    } error:^(NSError *error) {
//        // Handle error
//    }];
}

- (void)fillUIWithInfoResponse:(UpdateResultObject *)infoResponse
{
    self.updateVersionLabel.text = infoResponse.updateVersion.description;
    self.updateStateLabel.text = [self updateStateFromResult:infoResponse.updateState];
    self.metaLabel.text = [NSString stringWithFormat:@"%@", infoResponse.metadata];;

    self.requiredVersionLabel.text = infoResponse.versionInfo.requiredVersion.description;
    self.lastVersionAvailableLabel.text = infoResponse.versionInfo.lastVersionAvailable.description;
    self.installedVersionLabel.text = infoResponse.versionInfo.installedVersion.description;
    self.notificationTypeLabel.text = infoResponse.versionInfo.notificationType == UpdateNotificationTypeOnce ? @"ONCE" : @"ALWAYS";
    self.requirementsLabel.text = [NSString stringWithFormat:@"%@", infoResponse.versionInfo.requirements];
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
