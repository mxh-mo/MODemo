//
//  GCWebviewJSBridge_JS.m
//  GCWebviewJSBridge
//
//  Created by 万鸿恩 on 16/6/12.
//  Copyright © 2016年 天易联. All rights reserved.
//


#import "GCWebviewJSBridge_JS.h"



NSString *GCWebviewJSBridge_JS(){
    
#define __gcwvjsb_js_func__(x) #x
    
    //开始预处理js code
    
    static NSString * preprocessorJSCode = @__gcwvjsb_js_func__(
                                                             ;(function() {
        if (window.GCWebviewJSBridge) {
            return;
        }
        window.GCWebviewJSBridge = {
        init:init,
        registerHandler: registerHandler,
        callHandler: callHandler,
        _fetchQueue: _fetchQueue,
        _handleMessageFromNative: _handleMessageFromNative
        };
        
        var messagingIframe;
        var sendMessageQueue = [];
        var messageHandlers = {};
        
        var CUSTOM_PROTOCOL_SCHEME = 'gcwvjsbscheme';
        var QUEUE_HAS_MESSAGE = '__GC_WVJSB_QUEUE_MESSAGE__';
        
        var responseCallbacks = {};
        
        
        function registerHandler(handlerName, handler) {
            messageHandlers[handlerName] = handler;
        }
        
        function callHandler(handlerName, data, responseCallback) {
            if (arguments.length == 2 && typeof data == 'function') {
                responseCallback = data;
                data = null;
            }
            _doSend({ handlerName:handlerName, data:data }, responseCallback);
        }
        
        function _doSend(message, responseCallback) {
            if (responseCallback) {
                var nowtimeStamp = new Date().getTime();
                var callbackId = 'gc_js_cy_'+'_'+nowtimeStamp;
                responseCallbacks[callbackId] = responseCallback;
                message['callbackId'] = callbackId;
            }
            sendMessageQueue.push(message);
            messagingIframe.src = CUSTOM_PROTOCOL_SCHEME + '://' + QUEUE_HAS_MESSAGE;
        }
        
        function _fetchQueue() {
            var messageQueueString = JSON.stringify(sendMessageQueue);
            sendMessageQueue = [];
            return messageQueueString;
        }
        
        function init(){
            return;
        }
        
        
        function _dispatchMessageFromObjC(messageJSON) {
            setTimeout(function _timeoutDispatchMessageFromObjC() {
                var message = JSON.parse(messageJSON);
                var messageHandler;
                var responseCallback;
                
                if (message.responseId) {
                    responseCallback = responseCallbacks[message.responseId];
                    if (!responseCallback) {
                        return;
                    }
                    responseCallback(message.responseData);
                    delete responseCallbacks[message.responseId];
                } else {
                    if (message.callbackId) {
                        var callbackResponseId = message.callbackId;
                        responseCallback = function(responseData) {
                            _doSend({ responseId:callbackResponseId, responseData:responseData });
                        };
                    }
                    
                    var handler = messageHandlers[message.handlerName];
                    try {
                        handler(message.data, responseCallback);
                    } catch(exception) {
                        console.log(" WARNING: javascript handler threw.", message, exception);
                    }
                    if (!handler) {
                        console.log("WARNING: no handler for message from ObjC:", message);
                    }
                }
            });
        }
        
        function _handleMessageFromNative(messageJSON) {
            _dispatchMessageFromObjC(messageJSON);
        }
        
        messagingIframe = document.createElement('iframe');
        messagingIframe.style.display = 'none';
        messagingIframe.src = CUSTOM_PROTOCOL_SCHEME + '://' + QUEUE_HAS_MESSAGE;
        document.documentElement.appendChild(messagingIframe);
        
        setTimeout(_callWVJBCallbacks, 0);
        function _callWVJBCallbacks() {
            var callbacks = window.KBWVJSBCallBacks;
            delete window.KBWVJSBCallBacks;
            for (var i=0; i<callbacks.length; i++) {
                callbacks[i](GCWebviewJSBridge);
            }
        }
        

        
    })();
                                                             );
    
    
    
    //结束预处理
    
#undef __gcwvjsb_js_func__
    return preprocessorJSCode;
    
};


