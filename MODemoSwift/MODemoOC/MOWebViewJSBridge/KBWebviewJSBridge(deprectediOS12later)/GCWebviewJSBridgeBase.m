//
//  GCWebviewJSBridgeBase.m
//  GCWebviewJSBridge
//
//  Created by 万鸿恩 on 16/6/7.
//  Copyright © 2016年 天易联. All rights reserved.
//

#import "GCWebviewJSBridgeBase.h"
#import "GCWebviewJSBridge_JS.h"
@interface GCWebviewJSBridgeBase (){
    id _webViewDelegate;
}

@end


static BOOL logging = NO;
static int logMaxLength = 1000;

@implementation GCWebviewJSBridgeBase

+ (void)setEnableLogging{
    logging = YES;
}

+ (void)setLogMaxLength:(int)length{
    logMaxLength = length;
}

- (id)init{
    self = [super init];
    if (self) {
        self.startupMessageQueues = [NSMutableArray array];
        self.messageHandlers = [NSMutableDictionary dictionary];
        self.responseCallbacks = [NSMutableDictionary dictionary];
    }
    return self;
}


- (void)dealloc{
    self.startupMessageQueues = nil;
    self.messageHandlers = nil;
    self.responseCallbacks = nil;
}

- (void)sendData:(id)data responseCallback:(GCWVJSBResponseCallback)responseCallback handlerName:(NSString *)handlerName{
    NSMutableDictionary *message = [NSMutableDictionary dictionary];
    if (data) {
        message[@"data"] = data;
    }
    
    if (responseCallback) {
        //毫秒级时间戳
        UInt64 timeStamp = [[NSDate date] timeIntervalSince1970]*1000;
        NSString *callbackId = [NSString stringWithFormat:@"gc_objc_cy_%llu",timeStamp];
        self.responseCallbacks[callbackId] = [responseCallback copy];
        message[@"callbackId"] = callbackId;
    }
    if (handlerName) {
        message[@"handlerName"] = handlerName;
    }
    [self _queueMessage:message];
}

//处理当前的message:是向js发送，还是接收
- (void)_queueMessage:(GCWVJSBMessage*)message{
    if (self.startupMessageQueues) {
        [self.startupMessageQueues addObject:message];
    }else{
        [self sendMessageToJs:message];
    }
}

//向js发送message
- (void)sendMessageToJs:(GCWVJSBMessage *)message{
    NSString *messageJson = [self serializeMessage:message Whitespace:NO];
    
    [self logWithAction:GCBridgeActionTypeSend json:messageJson];
    
    messageJson = [messageJson stringByReplacingOccurrencesOfString:@"\\" withString:@"\\\\"];
    messageJson = [messageJson stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    messageJson = [messageJson stringByReplacingOccurrencesOfString:@"\'" withString:@"\\\'"];
    messageJson = [messageJson stringByReplacingOccurrencesOfString:@"\n" withString:@"\\n"];
    messageJson = [messageJson stringByReplacingOccurrencesOfString:@"\r" withString:@"\\r"];
    messageJson = [messageJson stringByReplacingOccurrencesOfString:@"\f" withString:@"\\f"];
    messageJson = [messageJson stringByReplacingOccurrencesOfString:@"\u2028" withString:@"\\u2028"];
    messageJson = [messageJson stringByReplacingOccurrencesOfString:@"\u2029" withString:@"\\u2029"];
    
    NSString *scriptCmd = [self webviewJavascriptCMDFromObjCWithJsonString:messageJson];
    if ([[NSThread currentThread] isMainThread]) {
        [self evaluateJavascript:scriptCmd];
    }else{
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self evaluateJavascript:scriptCmd];
        });
    }
    
}

//刷新队列信息
- (void)flushMessageQueue:(NSString *)messageQueueString{
    if (messageQueueString == nil || messageQueueString.length == 0) {
        NSLog(@"WARNING: ObjC got nil value while fetching the message queue JSON from webview. This can happen if the WebViewJavascriptBridge JS is not currently present in the webview, e.g if the webview just loaded a new page.");
        return;
    }
    
    id messages = [self deserializeMessage:messageQueueString];
    
    for (GCWVJSBMessage *message in messages) {
        if (![message isKindOfClass:[GCWVJSBMessage class]]) {
            NSLog(@"Invalid: %@ received:%@",[message class],message);
            continue;
        }
        [self logWithAction:GCBridgeActionTypeReceived json:message];
        NSString *responseId = message[@"responseId"];
        if (responseId) {
            GCWVJSBResponseCallback responseCallback = _responseCallbacks[responseId];
            responseCallback(message[@"responseData"]);
            [self.responseCallbacks removeObjectForKey:responseId];
        }else{
            GCWVJSBResponseCallback responseCallback = NULL;
            NSString *callbackId = message[@"callbackId"];
            if (callbackId) {
                responseCallback = ^(id responseData) {
                    if (responseData == nil) {
                        responseData = [NSNull null];
                    }
                    
                    GCWVJSBMessage* msg = @{ @"responseId":callbackId, @"responseData":responseData };
                    [self _queueMessage:msg];
                };
            } else {
                responseCallback = ^(id ignoreResponseData) {
                    // Do nothing
                };
            }
            
            GCWVJSBHandler handler = self.messageHandlers[message[@"handlerName"]];
            if (!handler) {
                NSLog(@"No Handler for message from JS:%@",message);
                continue;
            }
            handler(message[@"data"],responseCallback);
            
        }
    }
}

//注入JS到web
- (void)injectJS{
    NSString *script = GCWebviewJSBridge_JS();
    
//    NSLog(@"script==== %@",script);
    
    [self evaluateJavascript:script];
    
    if (self.startupMessageQueues) {
        NSArray *queues = self.startupMessageQueues;
        self.startupMessageQueues = nil;
        for (id queue in queues) {
            [self sendMessageToJs:queue];
        }
    }
}

//判断url 是否需要桥接
- (BOOL)isBridgeLoadedURL:(NSURL*)url{
    return ([[url scheme] isEqualToString:kGCCustomProtocolScheme] && [[url host] isEqualToString:kGCBridgeLoaded]);
}

//检测url是否是message队列消息
- (BOOL)isQueueMessageURL:(NSURL*)url{
    if ([[url host] isEqualToString:kGCQueuesHaveMessages]) {
        return YES;
    }
    return NO;
}

//检测是否是correct协议中scheme,
- (BOOL)isCorrectURLProtocolScheme:(NSURL *)url{
    if ([[url scheme] isEqualToString:kGCCustomProtocolScheme]) {
        return YES;
    }
    return NO;
}

//输入未知message
- (void)outputUnkownMessage:(NSURL*)url{
    NSLog(@"Received unknown web url %@://%@",kGCCustomProtocolScheme,[url path]);
}



/**
 *  将json数据转为data之后把data转为字符串
 *
 *  @param message
 *  @param pretty  Yes:有空格; No:无
 *
 *  @return
 */
- (NSString *)serializeMessage:(id)message Whitespace:(BOOL)pretty{
    return [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:message options:(NSJSONWritingOptions)(pretty?NSJSONWritingPrettyPrinted:0) error:nil] encoding:NSUTF8StringEncoding];
}


/**
 *  将json数据转为Array
 *  @return
 */
- (NSArray *)deserializeMessage:(NSString *)json{
    return [NSJSONSerialization JSONObjectWithData:[json dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
}



/**
 *  记录数据
 *
 *  @param action 1发送或者2接收
 *  @param json   json
 */
- (void)logWithAction:(GCBridgeActionType)action json:(id)json{
    if (!logging) {
        return;
    }
    
    NSString *typeaction = @"Send";
    if (action == GCBridgeActionTypeReceived) {
        typeaction = @"Received";
    }
    
    if (![json isKindOfClass:[NSString class]]) {
        json = [self serializeMessage:json Whitespace:YES];
    }
    if ([json length] > logMaxLength) {
        NSLog(@"action:%@ 的数据超出了最大可记录长度，json: %@",typeaction,json);
    }else{
        NSLog(@"action:%@, 数据为:%@",typeaction,json);
    }
}

//返回OC 向js操作的script
- (NSString *)webviewJavascriptCMDFromObjCWithJsonString:(NSString *)jsonStr{
    return [NSString stringWithFormat:@"GCWebviewJSBridge._handleMessageFromNative('%@');",jsonStr];
}


//return fetch信息的命令
- (NSString *)webViewJavascriptFetchMessageQueueCMD{
    return [NSString stringWithFormat:@"GCWebviewJSBridge._fetchQueue();"];
}


//发送指令delegate
- (void)evaluateJavascript:(NSString *)script{
    if (self.delegate && [self.delegate respondsToSelector:@selector(_evaluateJavascriptFromScriptString:)]) {
        [self.delegate _evaluateJavascriptFromScriptString:script];
    }
}



@end
