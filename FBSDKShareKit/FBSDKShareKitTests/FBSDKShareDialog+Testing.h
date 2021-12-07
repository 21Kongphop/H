/*
 * Copyright (c) Facebook, Inc. and its affiliates.
 * All rights reserved.
 *
 * This source code is licensed under the license found in the
 * LICENSE file in the root directory of this source tree.
 */

#if !TARGET_OS_TV

#import <FBSDKCoreKit/FBSDKCoreKit.h>

#import "FBSDKShareDialog+Internal.h"

@protocol FBSDKShareUtility;
@protocol FBSDKSocialComposeViewControllerFactory;

NS_ASSUME_NONNULL_BEGIN

@interface FBSDKShareDialog (Testing)

// UNCRUSTIFY_FORMAT_OFF
+ (void)configureWithInternalURLOpener:(id<FBSDKShareInternalURLOpening>)internalURLOpener
                       internalUtility:(id<FBSDKInternalUtility>)internalUtility
                              settings:(id<FBSDKSettings>)settings
                          shareUtility:(Class<FBSDKShareUtility>)shareUtility
               bridgeAPIRequestFactory:(id<FBSDKBridgeAPIRequestCreating>)bridgeAPIRequestFactory
                bridgeAPIRequestOpener:(id<FBSDKBridgeAPIRequestOpening>)bridgeAPIRequestOpener
    socialComposeViewControllerFactory:(id<FBSDKSocialComposeViewControllerFactory>)socialComposeViewControllerFactory
                          windowFinder:(id<FBSDKWindowFinding>)windowFinder
NS_SWIFT_NAME(configure(internalURLOpener:internalUtility:settings:shareUtility:bridgeAPIRequestFactory:bridgeAPIRequestOpener:socialComposeViewControllerFactory:windowFinder:));
// UNCRUSTIFY_FORMAT_ON

#if FBTEST && DEBUG
+ (void)resetClassDependencies;
#endif

@end

NS_ASSUME_NONNULL_END

#endif
