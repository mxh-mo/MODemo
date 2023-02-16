//
//  MOOCMockDemo.m
//  MODemoOC
//
//  Created by MikiMo on 2021/6/29.
//

#import "MOOCMockDemo.h"
#import "MOPerson+Tests.h"

@implementation MOOCMockDemo

+ (void)handleLoadFinished:(NSDictionary *)info {
    MOPerson *person = [MOPerson personWithInfo:info];
    if ([person isValid]) {
        [self handleLoadSuccessWithPerson:person];
        [self showError:NO];
    } else {
        [self handleLoadFailWithPerson:person];
        [self showError:YES];
    }
}

+ (void)handleLoadSuccessWithPerson:(MOPerson *)person {
    // do something
}

+ (void)handleLoadFailWithPerson:(MOPerson *)person {
    // do something
}

+ (void)showError:(BOOL)error {
    // do something
}

@end
