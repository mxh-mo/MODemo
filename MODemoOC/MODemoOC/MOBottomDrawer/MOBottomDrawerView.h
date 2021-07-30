//
//  MOBottomDrawerView.h
//  MODemoOC
//
//  Created by MikiMo on 2020/12/18.
//

#import <UIKit/UIKit.h>
#define kSCREEN_WIDTH   [[UIScreen mainScreen] bounds].size.width
#define kSCREEN_HEIGHT  [[UIScreen mainScreen] bounds].size.height
#define kBottomMinY kSCREEN_HEIGHT - 300
#define kBottomMaxY kSCREEN_HEIGHT - 150

NS_ASSUME_NONNULL_BEGIN

@interface MOBottomDrawerView : UIView

- (void)close;
- (void)open;

@end

NS_ASSUME_NONNULL_END
