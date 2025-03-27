//
//  UIButton+MOOLocalizable.m
//  MODemo
//
//  Created by mikimo on 2025/3/8.
//  Copyright © 2025 Mobi Technology. All rights reserved.
//

#import "UIButton+MOOLocalizable.h"
#import <objc/runtime.h>
#import "MOOLocalizableManager.h"

@implementation UIButton (MOOLocalizable)

- (void)setTitleLocalizableKey:(NSString *)localizableKey
                      forState:(UIControlState)state {
    NSMutableDictionary<NSNumber *,NSString *> *titleLocalizableKeys = [self.titleLocalizableKeys mutableCopy];
    if (!titleLocalizableKeys) {
        titleLocalizableKeys = [NSMutableDictionary dictionary];
    }
    if (localizableKey.length == 0) {
        [titleLocalizableKeys removeObjectForKey:@(state)];
    } else {
        [titleLocalizableKeys setObject:localizableKey forKey:@(state)];
        [self setTitle:MOOLocalizableString(localizableKey) forState:state];
    }
    self.titleLocalizableKeys = [titleLocalizableKeys copy];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MOOLanguageDidChangeNotification object:nil];
    if (self.titleLocalizableKeys.count == 0) {
        return;
    }
    __weak typeof(self) weakSelf = self;
    [[NSNotificationCenter defaultCenter] addObserverForName:MOOLanguageDidChangeNotification
                                                      object:nil
                                                       queue:nil
                                                  usingBlock:^(NSNotification * _Nonnull notification) {
        [weakSelf updateLocalizableLanguage];
    }];
}

#pragma mark - Private Methods

- (void)updateLocalizableLanguage {
    [self.titleLocalizableKeys enumerateKeysAndObjectsUsingBlock:^(NSNumber * _Nonnull key,
                                                                   NSString * _Nonnull obj,
                                                                   BOOL * _Nonnull stop) {
        [self setTitle:MOOLocalizableString(obj) forState:[key unsignedIntegerValue]];
    }];
}

- (void)setTitleLocalizableKeys:(NSDictionary<NSNumber *,NSString *> *)titleLocalizableKeys {
    objc_setAssociatedObject(self, @selector(titleLocalizableKeys), titleLocalizableKeys, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSDictionary<NSNumber *,NSString *> *)titleLocalizableKeys {
    return objc_getAssociatedObject(self, _cmd);
}

@end
