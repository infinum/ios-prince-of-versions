////
////  ObjCAutomaticCheckController.m
////  PrinceOfVersionsMacSample
////
////  Created by Jasmin Abou Aldan on 20/09/2019.
////  Copyright © 2019 infinum. All rights reserved.
////
//
//#import "ObjCAutomaticCheckController.h"
//#import "PrinceOfVersionsMacSample-Swift.h"
//
//@import PrinceOfVersions;
//
//@interface ObjCAutomaticCheckController ()
//
// @property (nonatomic, weak) IBOutlet NSTextField *appStateTextField;
// @property (nonatomic, weak) IBOutlet NSTextField *metaTextField;
//
//@end
//
//@implementation ObjCAutomaticCheckController
//
//#pragma mark - View Lifecycle
//
//- (void)viewDidLoad
//{
//    [super viewDidLoad];
//    // Do view setup here.
//    [self checkAppVersion];
//}
//
//#pragma mark - Private methods
//
//- (void)checkAppVersion
//{
//    NSURL *princeOfVersionsURL = [NSURL URLWithString:Constant.princeOfVersionsURL];
//
//    __weak __typeof(self) weakSelf = self;
//    [[PrinceOfVersions new] checkForUpdatesFromURL:princeOfVersionsURL
//                                           options:nil
//                                        newVersion:^(Version *versionData, BOOL isMinimumVersionSatisfied, NSDictionary *meta) {
//                                            // versionData is same as in `ObjCConfigurationController`. Check example there
//                                            NSString *typeOfUpdate = isMinimumVersionSatisfied ? @"optional" : @"mandatory";
//                                            NSString *stateText = [NSString stringWithFormat:@"New %@ version is available.", typeOfUpdate];
//                                            [weakSelf fillUIWithAppState:stateText andMeta:meta];
//                                        } noNewVersion:^(BOOL isMinimumVersionSatisfied, NSDictionary *meta) {
//
//                                            NSMutableString *stateText = [NSMutableString stringWithString:@"There is no new app versions."];
//                                            if (!isMinimumVersionSatisfied) {
//                                                [stateText appendString:@"But minimum version is not satisfied."];
//                                            }
//                                            [weakSelf fillUIWithAppState:stateText andMeta:meta];
//                                        } error:^(NSError *error) {
//                                            // Handle error
//                                        }];
//}
//
//- (void)fillUIWithAppState:(NSString *)appState andMeta:(NSDictionary *)meta
//{
//    self.appStateTextField.stringValue = appState;
//    self.metaTextField.stringValue = [NSString stringWithFormat:@"%@", meta];
//}
//
//@end
