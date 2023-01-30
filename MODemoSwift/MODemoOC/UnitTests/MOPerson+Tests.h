//
//  MOPerson+Tests.h
//  MODemoOC
//
//  Created by MikiMo on 2021/6/29.
//

#import "MOPerson.h"

NS_ASSUME_NONNULL_BEGIN

@interface MOPerson (Tests)

/*  以下，OCMock Tests 使用 */
- (void)loadFriendsWithError:(NSError **)error;
- (void)deviceWithComplete:(void(^)(NSString *value))complete;
- (void)addChilden:(MOPerson * _Nullable)person;
- (BOOL)takeMoney:(NSUInteger *)money;
- (void)changeWithSelector:(SEL)selector;
- (NSString *)mo_className;
+ (NSString *)mo_className;

/*  以下，OCMock Demo 使用 */
+ (MOPerson * _Nullable)personWithInfo:(NSDictionary * _Nullable)info;
- (BOOL)isValid;

@end

NS_ASSUME_NONNULL_END
