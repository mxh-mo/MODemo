//
//  MOTableSourceDelegate.h
//  LiveHoverKit_Example
//
//  Created by mikimo on 2023/7/15.
//  Copyright © 2023 Tencent Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MOCellModel;

NS_ASSUME_NONNULL_BEGIN

typedef void(^MOCellClickedHandler)(MOCellModel *model);

@interface MOCellModel : NSObject

/// cell title
@property (nonatomic, copy, nullable) NSString *title;

/// the name of the VC that jumps to when clicked
@property (nonatomic, copy, nullable) NSString *jumpVCName;

/// a block triggered when clicked
@property (nonatomic, copy, nullable) MOCellClickedHandler clickedHandler;

/// Initialize a cell model
/// - Parameters:
///   - title: cell title
///   - jumpVCName: the name of the VC that jumps to when clicked
///   - clickedHandler: block triggered when clicked
+ (instancetype)modelWithTitle:(NSString *)title
                    jumpVCName:(nullable NSString *)jumpVCName
                clickedHandler:(nullable MOCellClickedHandler)clickedHandler;

/// Initialize a push vc cell model
/// - Parameters:
///   - title: cell title
///   - jumpVCName: the name of the VC that jumps to when clicked
+ (instancetype)modelWithTitle:(NSString *)title
                    jumpVCName:(nullable NSString *)jumpVCName;

@end


FOUNDATION_EXPORT NSString *const MOTestCellIdentifier;

typedef void(^MODidClickCellHandler)(MOCellModel *cellModel);

@interface MOTableSourceDelegate : NSObject <UITableViewDataSource, UITableViewDelegate>

/// table view data source
@property (nonatomic, strong) NSArray<NSArray<MOCellModel *> *> *dataSource;

/// clicked cell call back
@property (nonatomic, copy, nullable) MODidClickCellHandler clickedCellHandler;

/// Initialize a table's data source and proxy
/// - Parameters:
///   - dataSource: data source for table view
+ (instancetype)tableSourceWithDataSource:(NSArray<NSArray<MOCellModel *> *> *)dataSource;

@end

NS_ASSUME_NONNULL_END
