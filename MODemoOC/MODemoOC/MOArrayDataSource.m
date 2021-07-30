//
//  MOArrayDataSource.m
//  MODemoOC
//
//  Created by MikiMo on 2020/12/18.
//

#import "MOArrayDataSource.h"

@implementation MOCellModel
+ (instancetype)modelWithTitle:(NSString *)title vcName:(NSString *)vcName {
    return [[[self class] alloc] initWithTitle:title vcName:vcName];
}

- (instancetype)initWithTitle:(NSString *)title vcName:(NSString *)vcName {
    self = [super init];
    if (self) {
        self.title = title;
        self.vcName = vcName;
    }
    return self;
}

+ (instancetype)modelWithTitle:(NSString *)title selectedCell:(MOSelectedCell)selectedCell {
    return [[[self class] alloc] initWithTitle:title selectedCell:selectedCell];
}

- (instancetype)initWithTitle:(NSString *)title selectedCell:(MOSelectedCell)selectedCell {
    self = [super init];
    if (self) {
        self.title = title;
        self.selectedCell = selectedCell;
    }
    return self;
}
@end


@interface MOArrayDataSource() <UITableViewDataSource>

@property (nonatomic, strong) NSArray *sections;
@property (nonatomic, copy) NSString *cellIndentifier;
@property (nonatomic, copy) MOConfigureCell configureCell;

@end

@implementation MOArrayDataSource

- (instancetype)initSections:(NSArray *)sections cellIndentifier:(NSString *)cellIndentifier configureCell:(MOConfigureCell)configureCell {
    self = [super init];
    if (self) {
        self.sections = sections;
        self.cellIndentifier = cellIndentifier;
        self.configureCell = configureCell;
    }
    return self;
}

- (MOCellModel *)modelAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *cells = self.sections[indexPath.section];
    return cells[indexPath.row];
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.cellIndentifier forIndexPath:indexPath];
    MOCellModel *model = [self modelAtIndexPath:indexPath];
    self.configureCell(cell, model);
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
   return self.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *cells = self.sections[section];
    return cells.count;
}

@end
