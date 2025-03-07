//
//  MOOLocalizableManager.h
//  MODemo
//
//  Created by mikimo on 2025/3/8.
//  Copyright © 2025 Mobi Technology. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 获取本地化文案
NSString *MOOLocalizableString(NSString *key);

/// 语言枚举
typedef NS_ENUM(NSUInteger, MOOLocalizableLanguage) {
    MOOLocalizableLanguageUnknow,   // 未知
    MOOLocalizableLanguageChinese,  // 中文
    MOOLocalizableLanguageEnglish,  // 英文
};

/// 本地化管理类
@interface MOOLocalizableManager : NSObject

/// 单例
+ (instancetype)sharedInstance;

/// 获取当前语言文案
- (NSString *)localizedStringForKey:(NSString *)key;

/// 修改语言
- (void)updateLanguage:(MOOLocalizableLanguage)language;

@end

NS_ASSUME_NONNULL_END
