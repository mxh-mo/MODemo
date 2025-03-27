//
//  UITextView+MOOLocalizable.m
//  MODemo
//
//  Created by mikimo on 2025/3/8.
//  Copyright © 2025 Mobi Technology. All rights reserved.
//

#import "UITextView+MOOLocalizable.h"
#import <objc/runtime.h>
#import "MOOLocalizableManager.h"

@implementation UITextView (MOOLocalizable)

- (void)setTextLocalizableKey:(NSString * _Nonnull)textLocalizableKey {
    objc_setAssociatedObject(self, @selector(textLocalizableKey), textLocalizableKey, OBJC_ASSOCIATION_COPY);
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MOOLanguageDidChangeNotification object:nil];
    if (textLocalizableKey.length == 0) {
        self.text = nil;
        return;
    }
    __weak typeof(self) weakSelf = self;
    [[NSNotificationCenter defaultCenter] addObserverForName:MOOLanguageDidChangeNotification
                                                      object:nil
                                                       queue:nil
                                                  usingBlock:^(NSNotification * _Nonnull notification) {
        weakSelf.text = MOOLocalizableString(textLocalizableKey);
    }];
    self.text = MOOLocalizableString(textLocalizableKey);
}

- (NSString *)textLocalizableKey {
    return objc_getAssociatedObject(self, _cmd);
}

@end
