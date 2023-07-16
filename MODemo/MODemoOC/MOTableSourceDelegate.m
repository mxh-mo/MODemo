//
//  MOTableSourceDelegate.m
//  LiveHoverKit_Example
//
//  Created by mikimo on 2023/7/15.
//  Copyright © 2023 Tencent Inc. All rights reserved.
//

#import "MOTableSourceDelegate.h"
#import "MOConveniences.h"

@implementation MOCellModel

/// Initialize a cell model
/// - Parameters:
///   - title: cell title
///   - jumpVCName: the name of the VC that jumps to when clicked
///   - clickedHandler: block triggered when clicked
+ (instancetype)modelWithTitle:(NSString *)title
                    jumpVCName:(nullable NSString *)jumpVCName
                clickedHandler:(nullable MOCellClickedHandler)clickedHandler {
    MOCellModel *model = [[MOCellModel alloc] init];
    model.title = title;
    model.jumpVCName = jumpVCName;
    model.clickedHandler = clickedHandler;
    return model;
}

/// Initialize a push vc cell model
/// - Parameters:
///   - title: cell title
///   - jumpVCName: the name of the VC that jumps to when clicked
+ (instancetype)modelWithTitle:(NSString *)title
                    jumpVCName:(nullable NSString *)jumpVCName {
    MOCellModel *model = [[MOCellModel alloc] init];
    model.title = title;
    model.jumpVCName = jumpVCName;
    return model;
}

@end

NSString *const MOTestCellIdentifier = @"UITableViewCell";

@implementation MOTableSourceDelegate

/// Initialize a table's data source and proxy
/// - Parameters:
///   - dataSource: data source for table view
+ (instancetype)tableSourceWithDataSource:(NSArray<NSArray<MOCellModel *> *> *)dataSource {
    MOTableSourceDelegate *source = [[MOTableSourceDelegate alloc] init];
    source.dataSource = dataSource;
    return source;
}

- (MOCellModel *)modelAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section >= self.dataSource.count) {
        MOLog(@"index beyond bounds for section");
        return nil;
    }
    NSArray *cells = [self.dataSource objectAtIndex:indexPath.section];
    if (indexPath.row >= cells.count) {
        MOLog(@"index beyond bounds for row");
        return nil;
    }
    MOCellModel *model = [cells objectAtIndex:indexPath.row];
    return model;
}

#pragma mark - UITableViewDataSource

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MOTestCellIdentifier
                                                            forIndexPath:indexPath];
    MOCellModel *model = [self modelAtIndexPath:indexPath];
    cell.textLabel.text = model.title;
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section >= self.dataSource.count) {
        MOLog(@"index beyond bounds for section");
        return 0;
    }
    NSArray *cells = [self.dataSource objectAtIndex:section];
    return cells.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MOCellModel *model = [self modelAtIndexPath:indexPath];
    if (self.clickedCellHandler) {
        self.clickedCellHandler(model);
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
