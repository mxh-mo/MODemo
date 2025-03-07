//
//  MOOLocalizableManager.m
//  MODemo
//
//  Created by mikimo on 2025/3/8.
//  Copyright © 2025 Mobi Technology. All rights reserved.
//

#import "MOOLocalizableManager.h"

/// 获取本地化文案
NSString *MOOLocalizableString(NSString *key) {
    return [[MOOLocalizableManager sharedInstance] localizedStringForKey:key];
}

@interface MOOLocalizableManager()

/// 当前语言
@property (nonatomic, assign) MOOLocalizableLanguage currentLanguage;

/// 当前资源包
@property (nonatomic, strong) NSBundle *currentBundle;

@end

@implementation MOOLocalizableManager

#pragma mark - Public Methods

- (NSString *)localizedStringForKey:(NSString *)key {
    return [self.currentBundle localizedStringForKey:key value:@"" table:@"Localizable"];
}

- (void)updateLanguage:(MOOLocalizableLanguage)language {
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
        _currentLanguage = MOOLocalizableLanguageChinese;
        [self updateBoundle];
    }
    return self;
}

- (void)updateBoundle {
    NSString *resourceName = [MOOLocalizableManager resourceNameWithLanguage:self.currentLanguage];
    NSString *boundlePath = [[NSBundle mainBundle] pathForResource:resourceName
                                                            ofType:@"lproj"];
    self.currentBundle = [NSBundle bundleWithPath:boundlePath];
}

+ (NSString *)resourceNameWithLanguage:(MOOLocalizableLanguage)language {
    switch (language) {
        case MOOLocalizableLanguageUnknow:
        case MOOLocalizableLanguageChinese: return @"zh-Hans";
        case MOOLocalizableLanguageEnglish: return @"en";
    }
}

@end
