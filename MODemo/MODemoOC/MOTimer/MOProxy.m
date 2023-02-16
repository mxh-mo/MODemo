//
//  MOProxy.m
//  MODemoOC
//
//  Created by MikiMo on 2021/1/14.
//

#import "MOProxy.h"

@implementation MOProxy

/// 消息转发的第二次机会
- (id)forwardingTargetForSelector:(SEL)aSelector {
    return _target; // 如果target为nil，则触发第三次机会
}

/// 消息转发的第三次机会
- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel {
    return [NSObject instanceMethodSignatureForSelector:@selector(init)]; // 获取了init方法的方法签名
}

- (void)forwardInvocation:(NSInvocation *)invocation {
    void *null = NULL;
    [invocation setReturnValue:&null]; // 给nil发送init方法，不会crash
}

@end
