//
//  ViewController.m
//  MODemoOC
//
//  Created by MikiMo on 2020/12/18.
//

#import "ViewController.h"
#import "MOArrayDataSource.h"
#import "MOPerson.h"

@interface ViewController () <UITableViewDelegate>

@property (nonatomic, strong) MOArrayDataSource *dataSource;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
}

- (void)setupView { //
    NSArray *section1 = @[
        [MOCellModel modelWithTitle:@"UIView Test" vcName:@"MOViewTestViewController"],
        [MOCellModel modelWithTitle:@"Water Ripple" vcName:@"MOWaterRippleViewController"],
        [MOCellModel modelWithTitle:@"CricleLoading" vcName:@"MOCricleLoadingViewController"],
        [MOCellModel modelWithTitle:@"Control Center" vcName:@"MOControlCenterViewController"],
        [MOCellModel modelWithTitle:@"UITableView Optimize" vcName:@"MOTableViewOptimizeViewController"],
        [MOCellModel modelWithTitle:@"Private API" vcName:@"MOPrivateAPIViewController"],
        [MOCellModel modelWithTitle:@"Locks" vcName:@"MOLocksViewController"],
        [MOCellModel modelWithTitle:@"MultiThread" vcName:@"MOMultiThreadViewController"],
        [MOCellModel modelWithTitle:@"KVC" vcName:@"MOKVCViewController"],
        [MOCellModel modelWithTitle:@"Runtime" vcName:@"MORuntimeViewController"],
        [MOCellModel modelWithTitle:@"Block" vcName:@"MOBlockViewController"],
        [MOCellModel modelWithTitle:@"Timer" vcName:@"MOTimerViewController"],
        [MOCellModel modelWithTitle:@"Responder响应者" vcName:@"MOResponderViewController"],
        [MOCellModel modelWithTitle:@"ImageButton" vcName:@"MOImageButtonViewController"],
        [MOCellModel modelWithTitle:@"NativeNetwork" vcName:@"MONativeNetworkViewController"],
        [MOCellModel modelWithTitle:@"MenuButton" vcName:@"MOMenuButtonViewController"],
        [MOCellModel modelWithTitle:@"DrawerView" vcName:@"MODrawerViewController"],
        [MOCellModel modelWithTitle:@"UIWebViewJSBridge" vcName:@"MOWebViewJSBridgeViewController"]
    ];
    self.dataSource = [[MOArrayDataSource alloc] initSections:@[section1] cellIndentifier:@"UITableViewCell" configureCell:^(UITableViewCell * _Nonnull cell, id  _Nonnull model) {
        MOCellModel *m = (MOCellModel *)model;
        cell.textLabel.text = m.title;
    }];
    self.tableView.dataSource = self.dataSource;
    [self.view addSubview:self.tableView];
    [self.tableView reloadData];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        MOCellModel *model = [self.dataSource modelAtIndexPath:indexPath];
        UIViewController *vc = [[NSClassFromString(model.vcName) alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)viewSafeAreaInsetsDidChange {
    [super viewSafeAreaInsetsDidChange];
    UIEdgeInsets insets = self.view.safeAreaInsets;
    CGRect bounds = [UIScreen mainScreen].bounds;
    self.tableView.frame = CGRectMake(insets.left, insets.top, bounds.size.width - insets.left - insets.right, bounds.size.height - insets.top - insets.bottom);
    [self.tableView reloadData];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    }
    _tableView.delegate = self;
    return _tableView;
}

@end
