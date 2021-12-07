/*
 * Copyright (c) Facebook, Inc. and its affiliates.
 * All rights reserved.
 *
 * This source code is licensed under the license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import <Foundation/Foundation.h>

#import "FBSDKAdvertiserIDProviding.h"
#import "FBSDKAppEventDropDetermining.h"
#import "FBSDKAppEventParametersExtracting.h"
#import "FBSDKAppEventsConfigurationProviding.h"
#import "FBSDKAppEventsFlushReason.h"
#import "FBSDKDeviceInformationProviding.h"
#import "FBSDKLoggingNotifying.h"

NS_ASSUME_NONNULL_BEGIN

@class FBSDKAccessToken;

NS_SWIFT_NAME(AppEventsUtility)
@interface FBSDKAppEventsUtility : NSObject <FBSDKAdvertiserIDProviding, FBSDKAppEventDropDetermining, FBSDKAppEventParametersExtracting, FBSDKLoggingNotifying>

#if !DEBUG
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;
#endif

@property (class, nonatomic) FBSDKAppEventsUtility *shared;
@property (nullable, nonatomic, readonly, copy) NSString *advertiserID;
@property (nonatomic, readonly) NSTimeInterval unixTimeNow;
@property (nonatomic, readonly) BOOL isDebugBuild;
@property (nonatomic, readonly) BOOL shouldDropAppEvents;
@property (nullable, nonatomic) id<FBSDKAppEventsConfigurationProviding> appEventsConfigurationProvider;
@property (nullable, nonatomic) id<FBSDKDeviceInformationProviding> deviceInformationProvider;

- (NSMutableDictionary<NSString *, id> *)activityParametersDictionaryForEvent:(NSString *)eventCategory
                                                    shouldAccessAdvertisingID:(BOOL)shouldAccessAdvertisingID
                                                                       userID:(nullable NSString *)userID
                                                                     userData:(nullable NSString *)userData;

- (void)ensureOnMainThread:(NSString *)methodName className:(NSString *)className;
- (NSString *)flushReasonToString:(FBSDKAppEventsFlushReason)flushReason;
- (nullable NSString *)tokenStringToUseFor:(nullable FBSDKAccessToken *)token
                      loggingOverrideAppID:(nullable NSString *)loggingOverrideAppID;
- (BOOL)validateIdentifier:(nullable NSString *)identifier;
- (BOOL)isSensitiveUserData:(NSString *)text;
- (BOOL)isStandardEvent:(nullable NSString *)event;
- (NSTimeInterval)convertToUnixTime:(nullable NSDate *)date;

#if DEBUG && FBTEST
- (void)reset;
#endif

@end

NS_ASSUME_NONNULL_END
