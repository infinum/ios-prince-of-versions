//
//  ObjCAutomaticCheckViewController.m
//  PrinceOfVersionsSample
//
//  Created by Jasmin Abou Aldan on 13/09/2019.
//  Copyright © 2019 infinum. All rights reserved.
//

#import "ObjCAutomaticCheckViewController.h"
#import "PrinceOfVersionsIosSample-Swift.h"

//@import PrinceOfVersions;
#import <PrinceOfVersions/PrinceOfVersions-Swift.h>

@interface ObjCAutomaticCheckViewController ()

@property (nonatomic, weak) IBOutlet UILabel *appStateLabel;
@property (nonatomic, weak) IBOutlet UILabel *metaLabel;

@end

@implementation ObjCAutomaticCheckViewController

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Do any additional setup after loading the view.
    [self checkAppVersion];
}

#pragma mark - Private methods

- (void)checkAppVersion
{
    NSURL *princeOfVersionsURL = [NSURL URLWithString:Constant.princeOfVersionsURL];

    __weak __typeof(self) weakSelf = self;
    [[PrinceOfVersions new] checkForUpdatesFromURL:princeOfVersionsURL
                                           options:nil
                                        newVersion:^(Version *versionData, BOOL isMinimumVersionSatisfied, NSDictionary *meta) {
                                            // versionData is same as in `ObjCConfigurationViewController`. Check example there
                                            NSString *typeOfUpdate = isMinimumVersionSatisfied ? @"optional" : @"mandatory";
                                            NSString *stateText = [NSString stringWithFormat:@"New %@ version is available.", typeOfUpdate];
                                            [weakSelf fillUIWithAppState:stateText andMeta:meta];
                                        } noNewVersion:^(BOOL isMinimumVersionSatisfied, NSDictionary *meta) {

                                            NSMutableString *stateText = [NSMutableString stringWithString:@"There is no new app versions."];
                                            if (!isMinimumVersionSatisfied) {
                                                [stateText appendString:@"But minimum version is not satisfied."];
                                            }

                                            [weakSelf fillUIWithAppState:stateText andMeta:meta];

                                        } error:^(NSError *error) {
                                            // Handle error
                                        }];
}

- (void)fillUIWithAppState:(NSString *)appState andMeta:(NSDictionary *)meta
{
    self.appStateLabel.text = appState;
    self.metaLabel.text = [NSString stringWithFormat:@"%@", meta];
}

@end
