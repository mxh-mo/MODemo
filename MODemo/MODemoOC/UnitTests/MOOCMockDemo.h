//
//  MOOCMockDemo.h
//  MODemoOC
//
//  Created by MikiMo on 2021/6/29.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class MOPerson;

@interface MOOCMockDemo : NSObject

+ (void)handleLoadFinished:(NSDictionary *)info;

+ (void)handleLoadSuccessWithPerson:(MOPerson *)person;

+ (void)handleLoadFailWithPerson:(MOPerson *)person;

+ (void)showError:(BOOL)error;

@end

NS_ASSUME_NONNULL_END
