/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 * All rights reserved.
 *
 * This source code is licensed under the license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import <XCTest/XCTest.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>

#import "FBSDKCoreKitTests-Bridging-Header.h"

NS_ASSUME_NONNULL_BEGIN

@interface FBSDKTestURLOpener: NSObject <FBSDKInternalURLOpener>
@end

@implementation FBSDKTestURLOpener

- (BOOL)canOpenURL:(nonnull NSURL *)url {
  return true;
}

- (BOOL)openURL:(nonnull NSURL *)url {
  return true;
}

- (void)openURL:(nonnull NSURL *)url options:(nonnull NSDictionary<UIApplicationOpenExternalURLOptionsKey,id> *)options completionHandler:(nullable void (^)(BOOL))completion {
  completion(true);
}

@end

@interface FBSDKAppLinkNavigationTests : XCTestCase
@property (nullable, nonatomic) FBSDKAppLinkNavigation *appLinkNavigation;
@property (nullable, nonatomic) FBSDKAppLink *appLink;
@property (nullable, nonatomic) NSDictionary<NSString*, id> *extras;
@property (nullable, nonatomic) NSDictionary<NSString*, id> *appLinkData;
@property (nullable, nonatomic) id<FBSDKSettings> settings;
@property (nullable, nonatomic) NSURL *url;
@end

@implementation FBSDKAppLinkNavigationTests

- (void)setUp {
  [super setUp];
  self.url = [NSURL URLWithString:@"https://www.example.com"];
  self.appLink = [[FBSDKAppLink alloc] initWithSourceURL:self.url targets:@[] webURL:nil];
  self.settings = FBSDKSettings.sharedSettings;
  self.appLinkNavigation = [FBSDKAppLinkNavigation navigationWithAppLink:self.appLink
                                                                  extras:@{} appLinkData:@{}
                                                                settings:self.settings];
  [FBSDKAppLinkNavigation configureWithSettings:FBSDKSettings.sharedSettings
                                      urlOpener:[FBSDKTestURLOpener new]
                             appLinkEventPoster:[FBSDKMeasurementEvent new]
                                appLinkResolver:[FBSDKWebViewAppLinkResolver sharedInstance]];
}

- (void)tearDown {
    
  self.url = nil;
  self.appLink = nil;
  self.extras = nil;
  self.appLinkData = nil;
  self.settings = nil;
  self.appLinkNavigation = nil;
  [FBSDKAppLinkNavigation reset];
  [super tearDown];
}

- (void)testNavigateWithErrorAndNavigationTypeFailure {
  
  FBSDKAppLinkTarget *appLinkTarget = [[FBSDKAppLinkTarget alloc] initWithURL:self.url
                                                                   appStoreId:nil
                                                                      appName:@"appname"];
  FBSDKAppLink *link = [[FBSDKAppLink alloc] initWithSourceURL:self.url
                                                       targets:@[appLinkTarget]
                                                        webURL:nil];
  NSMutableDictionary *appLinkData = [NSMutableDictionary dictionaryWithDictionary:@{@"Bad input": [NSDate date]}];
  self.appLinkNavigation = [FBSDKAppLinkNavigation navigationWithAppLink:link
                                                                  extras:@{}
                                                             appLinkData:appLinkData
                                                                settings:self.settings];
  NSError *error;
  
  FBSDKAppLinkNavigationType navigationType = [self.appLinkNavigation navigate:&error];
  XCTAssertNotNil(error);
  XCTAssertEqual(navigationType, FBSDKAppLinkNavigationTypeFailure);
}

- (void)testNavigateWithErrorAndNavigationTypeFailureWithWebURL {
  
  FBSDKAppLinkTarget *appLinkTarget = [[FBSDKAppLinkTarget alloc] initWithURL:self.url
                                                                   appStoreId:nil
                                                                      appName:@"appname"];
  FBSDKAppLink *link = [[FBSDKAppLink alloc] initWithSourceURL:self.url
                                                       targets:@[appLinkTarget]
                                                        webURL:self.url];
  NSMutableDictionary *appLinkData = [NSMutableDictionary dictionaryWithDictionary:@{@"Bad input": [NSDate date]}];
  self.appLinkNavigation = [FBSDKAppLinkNavigation navigationWithAppLink:link
                                                                  extras:@{}
                                                             appLinkData:appLinkData
                                                                settings:self.settings];
  NSError *error;
  
  FBSDKAppLinkNavigationType navigationType = [self.appLinkNavigation navigate:&error];
  XCTAssertNotNil(error);
  XCTAssertEqual(navigationType, FBSDKAppLinkNavigationTypeFailure);
}

- (void)testNavigateWithErrorAndNavigationTypeFailureWithWebURLNoTargetURL {
  
  FBSDKAppLink *link = [[FBSDKAppLink alloc] initWithSourceURL:self.url targets:@[] webURL:self.url];
  NSMutableDictionary *appLinkData = [NSMutableDictionary dictionaryWithDictionary:@{@"Bad input": [NSDate date]}];
  self.appLinkNavigation = [FBSDKAppLinkNavigation navigationWithAppLink:link
                                                                  extras:@{}
                                                             appLinkData:appLinkData
                                                                settings:self.settings];
  NSError *error;
  
  FBSDKAppLinkNavigationType navigationType = [self.appLinkNavigation navigate:&error];
  XCTAssertNotNil(error);
  XCTAssertEqual(navigationType, FBSDKAppLinkNavigationTypeFailure);
}

- (void)testNavigateWithErrorNilAndNavigationTypeFailure {
  
  FBSDKAppLink *link = [[FBSDKAppLink alloc] initWithSourceURL:self.url targets:@[] webURL:nil];

  self.appLinkNavigation = [FBSDKAppLinkNavigation navigationWithAppLink:link
                                                                  extras:@{}
                                                             appLinkData:@{}
                                                                settings:self.settings];
  NSError *error;
  
  FBSDKAppLinkNavigationType navigationType = [self.appLinkNavigation navigate:&error];
  XCTAssertNil(error);
  XCTAssertEqual(navigationType, FBSDKAppLinkNavigationTypeFailure);
}

- (void)testNavigateWithErrorNilAndNavigationTypeApp {
  
  FBSDKAppLinkTarget *appLinkTarget = [[FBSDKAppLinkTarget alloc] initWithURL:self.url
                                                                   appStoreId:@"13434"
                                                                      appName:@"appName"];
  FBSDKAppLink *link = [[FBSDKAppLink alloc] initWithSourceURL:self.url targets:@[appLinkTarget] webURL:nil];

  self.appLinkNavigation = [FBSDKAppLinkNavigation navigationWithAppLink:link
                                                                  extras:@{}
                                                             appLinkData:@{}
                                                                settings:self.settings];
  NSError *error;
  
  FBSDKAppLinkNavigationType navigationType = [self.appLinkNavigation navigate:&error];
  XCTAssertNil(error);
  XCTAssertEqual(navigationType, FBSDKAppLinkNavigationTypeApp);
}

- (void)testNavigateWithErrorNilAndNavigationTypeBrowser {
  
  FBSDKAppLink *link = [[FBSDKAppLink alloc] initWithSourceURL:self.url targets:@[] webURL:self.url];

  self.appLinkNavigation = [FBSDKAppLinkNavigation navigationWithAppLink:link
                                                                  extras:@{}
                                                             appLinkData:@{}
                                                                settings:self.settings];
  NSError *error;
  
  FBSDKAppLinkNavigationType navigationType = [self.appLinkNavigation navigate:&error];
  XCTAssertNil(error);
  XCTAssertEqual(navigationType, FBSDKAppLinkNavigationTypeBrowser);
}

@end

NS_ASSUME_NONNULL_END
