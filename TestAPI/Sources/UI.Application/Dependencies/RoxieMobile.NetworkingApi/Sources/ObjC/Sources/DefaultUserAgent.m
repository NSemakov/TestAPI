// ----------------------------------------------------------------------------
//
//  DefaultUserAgent.m
//
//  @author     Alexander Bragin <bragin-av@roxiemobile.com>
//  @copyright  Copyright (c) 2017, Roxie Mobile Ltd. All rights reserved.
//  @link       http://www.roxiemobile.com/
//
// ----------------------------------------------------------------------------

#import "DefaultUserAgent.h"

@import Alamofire;
//#import <Alamofire/Alamofire-umbrella.h>

// ----------------------------------------------------------------------------

const NSString *kUndefined = @"Undefined";

// NetworkingApi
#ifdef NETWORKINGAPI_FRAMEWORK_VERSION
const NSString *kNetworkingApiFrameworkVersion = NETWORKINGAPI_FRAMEWORK_VERSION;
#else
const NSString *kNetworkingApiFrameworkVersion = nil;
#endif

// Alamofire
#ifdef ALAMOFIRE_FRAMEWORK_VERSION
const NSString *kAlamofireFrameworkVersion = ALAMOFIRE_FRAMEWORK_VERSION;
#else
const NSString *kAlamofireFrameworkVersion = nil;
#endif

// ----------------------------------------------------------------------------

@implementation DefaultUserAgent

// ----------------------------------------------------------------------------

+ (nonnull NSArray<NSString *> *)components
{
    static NSArray<NSString *> *sharedComponents = nil;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        NSMutableArray<NSString *> *components = [[NSMutableArray alloc] init];

        // Add components of an ‘User-Agent’ HTTP header
        [components addObject:[NSString stringWithFormat:@"NetworkingApi/%@", kNetworkingApiFrameworkVersion ?: kUndefined]];
        [components addObject:[NSString stringWithFormat:@"Alamofire/%@", kAlamofireFrameworkVersion ?: kUndefined]];

        // Create immutable array
        sharedComponents = [[NSArray alloc] initWithArray: components];
    });

    // Done
    return sharedComponents;
}

// ----------------------------------------------------------------------------

+ (nonnull NSString *)value
{
    static NSString *sharedValue = nil;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        // Create string representation of an ‘User-Agent’ HTTP header
        sharedValue = [[DefaultUserAgent components] componentsJoinedByString:@" "];
    });

    // Done
    return sharedValue;
}

// ----------------------------------------------------------------------------

+ (instancetype)new
{
    NSString *message = [NSString stringWithFormat:@"+new is not a valid initializer for the class %@", NSStringFromClass([self class])];
    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:message userInfo:nil];
    return nil;
}

// ----------------------------------------------------------------------------

- (instancetype)init
{
    NSString *message = [NSString stringWithFormat:@"-init is not a valid initializer for the class %@", NSStringFromClass([self class])];
    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:message userInfo:nil];
    return nil;
}

// ----------------------------------------------------------------------------

@end

// ----------------------------------------------------------------------------
