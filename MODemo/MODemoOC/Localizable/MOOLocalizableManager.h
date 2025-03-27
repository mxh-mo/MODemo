//
//  MOOLocalizableManager.h
//  MODemo
//
//  Created by mikimo on 2025/3/8.
//  Copyright © 2025 Mobi Technology. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 语言已修改通知
FOUNDATION_EXTERN NSString *const MOOLanguageDidChangeNotification;

/// 获取本地化文案
NSString *MOOLocalizableString(NSString *key);

/// 语言枚举
typedef NS_ENUM(NSUInteger, MOOLanguage) {
    MOOLanguageAuto,     // 自动
    MOOLanguageChinese,  // 中文
    MOOLanguageChineseTraditional, // 中文繁体
    MOOLanguageEnglish,  // 英文
    MOOLanguageJapanese, // 日文
    MOOLanguageKorean,   // 韩文
};

/// 本地化管理类
@interface MOOLocalizableManager : NSObject

/// 当前资源包
@property (nonatomic, strong, readonly) NSBundle *currentBundle;

/// 单例
+ (instancetype)sharedInstance;

/// 获取当前语言文案
- (NSString *)localizedStringForKey:(NSString *)key;

/// 修改语言
- (void)updateLanguage:(MOOLanguage)language;

@end

NS_ASSUME_NONNULL_END
