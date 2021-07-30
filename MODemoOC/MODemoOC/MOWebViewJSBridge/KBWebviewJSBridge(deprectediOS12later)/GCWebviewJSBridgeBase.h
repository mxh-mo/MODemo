//
//  GCWebviewJSBridgeBase.h
//  GCWebviewJSBridge
//
//  Created by 万鸿恩 on 16/6/7.
//  Copyright © 2016年 天易联. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kGCCustomProtocolScheme @"gcwvjsbscheme"
#define kGCQueuesHaveMessages @"__GC_WVJSB_QUEUE_MESSAGE__"
#define kGCBridgeLoaded @"__GC_BRIDGE_LOADED__"



/**
 *  定义回调block
 *
 *  @param responseData
 */
typedef void (^GCWVJSBResponseCallback)(id responseData);

/**
 *  定义回调处理block
 */
typedef void (^GCWVJSBHandler)(id data, GCWVJSBResponseCallback responseCallback);
/**
 *  message 字典
 */
typedef NSDictionary GCWVJSBMessage;



typedef NS_ENUM(NSInteger,GCBridgeActionType) {
    /**
     *  发送action
     */
    GCBridgeActionTypeSend = 1<<0, //1
    
    /**
     *  接收action
     */
    GCBridgeActionTypeReceived = 1<<1, //2
};


@protocol GCWebviewJSBridgeBaseDelegate <NSObject>
/**
 *  本地OC run script
 *
 *  @param script Javascript string
 *
 *  @return 传递script到代理
 */
- (NSString *)_evaluateJavascriptFromScriptString:(NSString *)script;
@end


@interface GCWebviewJSBridgeBase : NSObject

@property (weak,nonatomic) id <GCWebviewJSBridgeBaseDelegate> delegate;

//存储message
@property (nonatomic,strong) NSMutableArray *startupMessageQueues;

//存储回调
@property (nonatomic,strong) NSMutableDictionary *responseCallbacks;

//存储message handler
@property (nonatomic,strong) NSMutableDictionary *messageHandlers;

//message handler
@property (nonatomic,strong) GCWVJSBHandler messageHandler;

/**
 *  开始记录交互数据,default fasle
 */
+ (void)setEnableLogging;

/**
 *  能够记录交互数据的最大长度,default 1000
 */
+ (void)setLogMaxLength:(int)length;

//发送数据到js 以及对应额回调和处理方法
- (void)sendData:(id)data responseCallback:(GCWVJSBResponseCallback)responseCallback handlerName:(NSString *)handlerName;

//刷新队列信息
- (void)flushMessageQueue:(NSString *)messageQueueString;

//注入JS到web
- (void)injectJS;

//检测是否是correct协议中scheme,
- (BOOL)isCorrectURLProtocolScheme:(NSURL *)url;

//检测url是否是message队列消息
- (BOOL)isQueueMessageURL:(NSURL*)url;

//判断url 是否需要桥接
- (BOOL)isBridgeLoadedURL:(NSURL*)url;

//输入未知message
- (void)outputUnkownMessage:(NSURL*)url;

//return fetch信息的命令
- (NSString *)webViewJavascriptFetchMessageQueueCMD;


























@end
