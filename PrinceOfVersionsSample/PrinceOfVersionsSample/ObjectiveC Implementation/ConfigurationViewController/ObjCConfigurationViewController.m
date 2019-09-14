//
//  ObjC-ConfigurationViewController.m
//  PrinceOfVersionsSample
//
//  Created by Jasmin Abou Aldan on 13/09/2019.
//  Copyright © 2019 infinum. All rights reserved.
//

#import "ObjCConfigurationViewController.h"
#import "PrinceOfVersionsSample-Swift.h"

@import PrinceOfVersions;

@interface ObjCConfigurationViewController ()

@property (nonatomic, weak) IBOutlet UILabel *installedVersionLabel;
@property (nonatomic, weak) IBOutlet UILabel *iOSVersionLabel;

@property (nonatomic, weak) IBOutlet UILabel *minimumVersionLabel;
@property (nonatomic, weak) IBOutlet UILabel *minimumSDKLabel;
@property (nonatomic, weak) IBOutlet UILabel *latestVersionLabel;
@property (nonatomic, weak) IBOutlet UILabel *notificationTypeLabel;
@property (nonatomic, weak) IBOutlet UILabel *latestMinimumSDKLabel;
@property (nonatomic, weak) IBOutlet UILabel *metaLabel;

@end

@implementation ObjCConfigurationViewController

#pragma mark - View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
    [self checkAppVersion];
}

#pragma mark - Private methods

- (void)checkAppVersion
{

    NSURL *princeOfVersionsURL = [NSURL URLWithString:Constant.princeOfVersionsURL];

    __weak __typeof(self) weakSelf = self;
    [[PrinceOfVersions new] loadConfigurationFromURL:princeOfVersionsURL
                                          completion:^(UpdateResponse *updateResponse) {
                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                  [weakSelf fillUIWithInfoResponse:updateResponse.result];
                                              });
                                          } error:^(NSError *error) {
                                              // Handle error
                                          }];
}

- (void)fillUIWithInfoResponse:(UpdateInfoObject *)infoResponse
{
    self.installedVersionLabel.text = infoResponse.installedVersion.description;
    self.iOSVersionLabel.text = infoResponse.sdkVersion.description;
    self.minimumVersionLabel.text = infoResponse.minimumRequiredVersion.description;
    self.minimumSDKLabel.text = infoResponse.minimumSdkForMinimumRequiredVersion.description;
    self.latestVersionLabel.text = infoResponse.latestVersion.description;
    self.notificationTypeLabel.text = infoResponse.notificationType == UpdateNotificationTypeOnce ? @"Once" : @"Always";
    self.latestMinimumSDKLabel.text = infoResponse.minimumSdkForLatestVersion.description;
    self.metaLabel.text = [NSString stringWithFormat:@"%@", infoResponse.metadata];
}

@end
