//
//  UIButton+MOOLocalizable.h
//  MODemo
//
//  Created by mikimo on 2025/3/8.
//  Copyright © 2025 Mobi Technology. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIButton (MOOLocalizable)

/// {@(UIControlState): titleLocalizableKey}
@property (nonatomic, strong, readonly) NSDictionary<NSNumber *, NSString *> *titleLocalizableKeys;

- (void)setTitleLocalizableKey:(NSString *)localizableKey
                      forState:(UIControlState)state;

@end

NS_ASSUME_NONNULL_END
