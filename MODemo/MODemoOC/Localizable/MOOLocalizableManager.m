//
//  MOOLocalizableManager.m
//  MODemo
//
//  Created by mikimo on 2025/3/8.
//  Copyright © 2025 Mobi Technology. All rights reserved.
//

#import "MOOLocalizableManager.h"

NSString *const MOOLanguageDidChangeNotification = @"LanguageDidChangeNotification";

/// 获取本地化文案
NSString *MOOLocalizableString(NSString *key) {
    return [[MOOLocalizableManager sharedInstance] localizedStringForKey:key];
}

@interface MOOLocalizableManager()

/// 当前语言
@property (nonatomic, assign) MOOLanguage currentLanguage;

/// 当前资源包
@property (nonatomic, strong) NSBundle *currentBundle;

@end

@implementation MOOLocalizableManager

#pragma mark - Public Methods

- (NSString *)localizedStringForKey:(NSString *)key {
    return [self.currentBundle localizedStringForKey:key value:@"" table:@"Localizable"];
}

- (void)updateLanguage:(MOOLanguage)language {
    _currentLanguage = language;
    [self updateBoundle];
}

+ (instancetype)sharedInstance {
    static MOOLocalizableManager *shared = nil;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        shared = [[MOOLocalizableManager alloc] init];
    });
    return shared;
}

#pragma mark - Private Methods

- (instancetype)init {
    self = [super init];
    if (self) {
        NSNumber *language = [[NSUserDefaults standardUserDefaults] objectForKey:@"MOOLanguageEnum"];
        _currentLanguage = language.unsignedIntegerValue;
        [self updateBoundle];
    }
    return self;
}

- (void)updateBoundle {
    NSString *resourceName = [MOOLocalizableManager resourceNameWithLanguage:self.currentLanguage];
    NSString *boundlePath = [[NSBundle mainBundle] pathForResource:resourceName ofType:@"lproj"];
    _currentBundle = [NSBundle bundleWithPath:boundlePath];
    
    // 修改 App 语言，但需要启动后才生效（仅影响 info.plist 文件的权限获取文案）
    [[NSUserDefaults standardUserDefaults] setObject:@(self.currentLanguage) forKey:@"MOOLanguageEnum"];
    [[NSUserDefaults standardUserDefaults] setObject:@[resourceName] forKey:@"AppleLanguages"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:MOOLanguageDidChangeNotification object:self];
}

+ (NSString *)resourceNameWithLanguage:(MOOLanguage)language {
    switch (language) {
        case MOOLanguageAuto: // TODO: mikimo 跟产品要默认语言决策逻辑
        case MOOLanguageChinese: return @"zh-Hans";
        case MOOLanguageChineseTraditional: return @"zh-Hant";
        case MOOLanguageEnglish: return @"en";
        case MOOLanguageJapanese: return @"ja";
        case MOOLanguageKorean: return @"ko";
    }
}

@end
