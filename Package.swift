// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

// Copyright (c) 2016-present, Facebook, Inc. All rights reserved.
//
// You are hereby granted a non-exclusive, worldwide, royalty-free license to use,
// copy, modify, and distribute this software in source code or binary form for use
// in connection with the web services and APIs provided by Facebook.
//
// As with any software that integrates with the Facebook platform, your use of
// this software is subject to the Facebook Developer Principles and Policies
// [http://developers.facebook.com/policy/]. This copyright notice shall be
// included in all copies or substantial portions of the software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
// FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
// COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
// IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
// CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

import PackageDescription

let package = Package(
    name: "Facebook",
    platforms: [
        .iOS(.v9),
        .tvOS(.v10)
    ],
    products: [
         // The Kernel of the SDK. Must be included as a runtime dependency.
        .library(
            name: "FacebookBasics",
            targets: ["FBSDKCoreKit_Basics"]
        ),

        /*
          The Core SDK library that provides two importable modules:

            - FacebookCore which includes the most current interface and
              will contain interfaces for new features written in Swift

            - FBSDKCoreKit which contains legacy Objective-C interfaces
              that will be used to maintain backwards compatibility with
              types that have been converted to Swift.
              This will not contain interfaces for new features written in Swift.
        */
        .library(
            name: "FacebookCore",
            targets: ["FacebookCore", "FBSDKCoreKit"]
        ),

        //  The Facebook Login SDK
        .library(
            name: "FacebookLogin",
            targets: ["FacebookLogin"]
        ),

        //  The Facebook Share SDK
        .library(
            name: "FacebookShare",
            targets: ["FBSDKShareKit", "FacebookShare"]
        ),

        //  The Facebook Gaming Services SDK
        .library(
            name: "FacebookGamingServices",
            targets: ["FacebookGamingServices", "FBSDKGamingServicesKit"]
        ),

        // The Facebook AEM Kit
        .library(
            name: "FacebookAEM",
            targets: ["FBAEMKit", "FacebookAEM"]
        )
    ],
    targets: [
        // The kernel of the SDK
        .binaryTarget(
            name: "FBSDKCoreKit_Basics",
            url: "https://github.com/facebook/facebook-ios-sdk/releases/download/v12.0.0/FBSDKCoreKit_Basics-Static_XCFramework.zip",
            checksum: "f49ae8b2f60ecb915f2487d080f2aaa0f8188d8aac9a8ca6f3b025705225045c"
        ),

        /*
          The legacy Objective-C implementation that will be converted to Swift.
          This will not contain interfaces for new features written in Swift.
        */
        .binaryTarget(
            name: "FBAEMKit",
            url: "https://github.com/facebook/facebook-ios-sdk/releases/download/v12.0.0/FBAEMKit-Static_XCFramework.zip",
            checksum: "15e1fb07bc1b412698d1b8257c4cb2cde72d7d188554d981301233610f22cb81"
        ),

        // The main AEM module
        .target(
          name: "FacebookAEM",
          dependencies: ["FBAEMKit"]
        ),

        /*
          The legacy Objective-C implementation that will be converted to Swift.
          This will not contain interfaces for new features written in Swift.
        */
        .binaryTarget(
            name: "FBSDKCoreKit",
            url: "https://github.com/facebook/facebook-ios-sdk/releases/download/v12.0.0/FBSDKCoreKit-Static_XCFramework.zip",
            checksum: "8ca083df465bcab4227f749382535c4fd3badaca32b1bdc407202c0d9106d057"
        ),

        // The main Core SDK module
        .target(
            name: "FacebookCore",
            dependencies: ["FBSDKCoreKit"],
            linkerSettings: [
                .linkedLibrary("c++"),
                .linkedLibrary("z"),
                .linkedFramework("Accelerate")
            ]
        ),

        /*
          The legacy Objective-C implementation that will be converted to Swift.
          This will not contain interfaces for new features written in Swift.
        */
        .binaryTarget(
            name: "FBSDKLoginKit",
            url: "https://github.com/facebook/facebook-ios-sdk/releases/download/v12.0.0/FBSDKLoginKit-Static_XCFramework.zip",
            checksum: "a109e8384d70bd5f68a61ce4daf27f560e0bd81d9ea58603df384796bc215ac2"
        ),

        // The main Login SDK module
        .target(
            name: "FacebookLogin",
            dependencies: ["FacebookCore", "FBSDKLoginKit"]
        ),

        /*
          The legacy Objective-C implementation that will be converted to Swift.
          This will not contain interfaces for new features written in Swift.
        */
        .binaryTarget(
            name: "FBSDKShareKit",
            url: "https://github.com/facebook/facebook-ios-sdk/releases/download/v12.0.0/FBSDKShareKit-Static_XCFramework.zip",
            checksum: "eca15dcef95c012235fde2c2161531073f681a8fbdc3f062f5c0716d42a540c1"
        ),

        // The main Share SDK module
        .target(
            name: "FacebookShare",
            dependencies: ["FacebookCore", "FBSDKShareKit"]
        ),

        // The main Facebook Gaming Services module
        .binaryTarget(
            name: "FacebookGamingServices",
            url: "https://github.com/facebook/facebook-ios-sdk/releases/download/v12.0.0/FacebookGamingServices-Static_XCFramework.zip",
            checksum: "516b30ba6f670bab900630ff4710652bded4155da99d044c4923d6b7e3af8a88"
        ),

        /*
          The legacy Objective-C implementation that will be converted to Swift.
          This will not contain interfaces for new features written in Swift.
        */
        .target(
            name: "FBSDKGamingServicesKit",
            dependencies: ["FacebookGamingServices"],
            exclude: ["Exported"]
        ),
    ],
    cxxLanguageStandard: CXXLanguageStandard.cxx11
)
