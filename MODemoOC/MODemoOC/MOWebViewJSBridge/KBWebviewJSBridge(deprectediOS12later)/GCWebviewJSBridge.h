//
//  GCWebviewJSBridge.h
//  GCWebviewJSBridge
//
//  Created by 万鸿恩 on 16/6/7.
//  Copyright © 2016年 天易联. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "GCWebviewJSBridgeBase.h"

@interface GCWebviewJSBridge : NSObject<UIWebViewDelegate,GCWebviewJSBridgeBaseDelegate>

/**
 *  创建bridge为webView
 */
+ (id)bridgeForWebView:(UIWebView *)webView;

/**
 *  开始记录交互数据,default fasle
 */
+ (void)setEnableLogging;

/**
 *  能够记录交互数据的最大长度,default 1000
 */
+ (void)setLogMaxLength:(int)length;


/**
 *  ObjC 调用JS端
 *
 *  @param handlerName JS端handler的名字
 *  @param data        (optional) parameters (can be nil)
 *  @param callback    (optional) JS回调ObjC block，包含JS返回的 responseData (can be nil)
 */
- (void)callHandler:(NSString *)handlerName data:(id)data responseCallback:(GCWVJSBResponseCallback)callback;


/**
 *  ObjC注册本地方法，以供JS调用
 *
 *  @param handlerName ObjC本地方法名字
 *  @param handler     (id data, GCWVJSBResponseCallback responseCallback)，其中data为JS传递过来的参数;responseCallback为ObjC回调JS,包含ObjC返回的 responseData
 */
- (void)registerObjCHandler:(NSString *)handlerName  handler:(GCWVJSBHandler)handler;

/**
 *  设置代理.如果不需要实现代理，可以不设置
 *
 *  @param webViewDelegate
 */
- (void)setwebViewDelegate:(NSObject<UIWebViewDelegate> *)webViewDelegate;

@end
