//
//  MOStudent.h
//  MODemoOC
//
//  Created by MikiMo on 2020/12/18.
//

#import <Foundation/Foundation.h>
#import "NSObject+arrayContain.h"

NS_ASSUME_NONNULL_BEGIN

@interface MOStudent : NSObject <NSObjectDelegate, NSCoding>

@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSNumber *age;
@property (nonatomic, strong) NSArray *friends;

- (void)thinking;


@end

NS_ASSUME_NONNULL_END
