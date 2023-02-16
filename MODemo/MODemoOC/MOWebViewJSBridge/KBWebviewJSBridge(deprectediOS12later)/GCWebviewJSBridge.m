//
//  GCWebviewJSBridge.m
//  GCWebviewJSBridge
//
//  Created by 万鸿恩 on 16/6/7.
//  Copyright © 2016年 天易联. All rights reserved.
//

#import "GCWebviewJSBridge.h"

#if __has_feature(objc_arc_weak)
#define GCWVJSB_WEAK __weak
#else
#define GCWVJSB_WEAK __unsafe_unretained
#endif

@interface GCWebviewJSBridge (){
    GCWebviewJSBridgeBase *_base;
    long uniqueId;
    GCWVJSB_WEAK UIWebView *_webView;
    GCWVJSB_WEAK id _webViewDelegate;
}

@end

@implementation GCWebviewJSBridge

/**
 *  创建bridge为webView
 */
+ (id)bridgeForWebView:(UIWebView *)webView{
    GCWebviewJSBridge *bridge = [[self alloc] init];
    [bridge setup:webView];
    return bridge;
}

/**
 *  开始记录交互数据,default fasle
 */
+ (void)setEnableLogging{
    [GCWebviewJSBridgeBase setEnableLogging];
}

/**
 *  能够记录交互数据的最大长度,default 1000
 */
+ (void)setLogMaxLength:(int)length{
    [GCWebviewJSBridgeBase setLogMaxLength:length];
}


/**
 *  ObjC 调用JS端
 *
 *  @param handlerName JS端handler的名字
 *  @param data        (optional) parameters (can be nil)
 *  @param callback    (optional) JS回调ObjC block，包含JS返回的 responseData (can be nil)
 */
- (void)callHandler:(NSString *)handlerName data:(id)data responseCallback:(GCWVJSBResponseCallback)callback{
    [_base sendData:data responseCallback:callback handlerName:handlerName];
}


/**
 *  ObjC注册本地方法，以供JS调用
 *
 *  @param handlerName ObjC本地方法名字
 *  @param handler     (id data, GCWVJSBResponseCallback responseCallback)，其中data为JS传递过来的参数;responseCallback为ObjC回调JS,包含ObjC返回的 responseData
 */
- (void)registerObjCHandler:(NSString *)handlerName  handler:(GCWVJSBHandler)handler{
    _base.messageHandlers[handlerName] = [handler copy];
}

/**
 *  设置代理.如果不需要实现代理，可以不设置
 *
 *  @param webViewDelegate
 */
- (void)setwebViewDelegate:(NSObject<UIWebViewDelegate> *)webViewDelegate{
    _webViewDelegate = webViewDelegate;
}


#pragma mark - private method
- (void)setup:(UIWebView *)webView{
    _webView = webView;
    _webView.delegate = self;
    _base = [[GCWebviewJSBridgeBase alloc] init];
    _base.delegate = self;
}

- (void)dealloc{
    _webView = nil;
    _base = nil;
    _webViewDelegate = nil;
    _webView.delegate = nil;
}

#pragma mark - GCWebviewJSBridgeBaseDelegate
- (NSString *)_evaluateJavascriptFromScriptString:(NSString *)script{
    return [_webView stringByEvaluatingJavaScriptFromString:script];
}



#pragma mark - UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView{
    if (webView != _webView) {
        return;
    }
    __strong NSObject<UIWebViewDelegate> *strongDelegate = _webViewDelegate;
    if (strongDelegate && [strongDelegate respondsToSelector:@selector(webViewDidStartLoad:)]) {
        [strongDelegate webViewDidStartLoad:webView];
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    if (webView != _webView) {
        return;
    }
    __strong NSObject<UIWebViewDelegate> *strongDelegate = _webViewDelegate;
    if (strongDelegate && [strongDelegate respondsToSelector:@selector(webViewDidFinishLoad:)]) {
        [strongDelegate webViewDidFinishLoad:webView];
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    if (webView != _webView) {
        return;
    }
    __strong NSObject<UIWebViewDelegate> *strongDelegate = _webViewDelegate;
    if (strongDelegate && [strongDelegate respondsToSelector:@selector(webView:didFailLoadWithError:)]) {
        [strongDelegate webView:webView didFailLoadWithError:error];
    }
}


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    if (webView != _webView) {
        return YES;
    }
    __strong NSObject<UIWebViewDelegate> *strongDelegate = _webViewDelegate;
    NSURL *url = [request URL];
    
    NSLog(@"scheme === %@",[url scheme]);
    
    if ([_base isCorrectURLProtocolScheme:url]) {
        //需要桥接
        if ([_base isBridgeLoadedURL:url]) {
            [_base injectJS];
        }else if ([_base isQueueMessageURL:url]){
            NSString *msgQueueStr = [self _evaluateJavascriptFromScriptString:[_base webViewJavascriptFetchMessageQueueCMD]];
            [_base flushMessageQueue:msgQueueStr];
        }else{
            [_base outputUnkownMessage:url];
        }
        
        return NO;
    }else if (strongDelegate && [strongDelegate respondsToSelector:@selector(webView:shouldStartLoadWithRequest:navigationType:)]){
        return [strongDelegate webView:webView shouldStartLoadWithRequest:request navigationType:navigationType];
    }else{
        return YES;
    }
    
}



@end
