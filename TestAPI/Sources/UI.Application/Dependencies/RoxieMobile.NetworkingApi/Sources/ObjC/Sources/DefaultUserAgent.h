// ----------------------------------------------------------------------------
//
//  DefaultUserAgent.h
//
//  @author     Alexander Bragin <bragin-av@roxiemobile.com>
//  @copyright  Copyright (c) 2017, Roxie Mobile Ltd. All rights reserved.
//  @link       http://www.roxiemobile.com/
//
// ----------------------------------------------------------------------------

#import <Foundation/Foundation.h>

// ----------------------------------------------------------------------------

@interface DefaultUserAgent: NSObject {
    // Do nothing
}

@property (class, nonatomic, copy, readonly, nonnull) NSArray<NSString *> *components;

@property (class, nonatomic, copy, readonly, nonnull) NSString *value;

+ (instancetype _Nonnull) new  UNAVAILABLE_ATTRIBUTE;

- (instancetype _Nonnull) init UNAVAILABLE_ATTRIBUTE;

@end

// ----------------------------------------------------------------------------
