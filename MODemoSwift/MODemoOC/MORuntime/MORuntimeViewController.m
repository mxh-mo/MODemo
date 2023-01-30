//
//  MORuntimeViewController.m
//  MODemoOC
//
//  Created by MikiMo on 2020/12/18.
//

#import <objc/runtime.h>

#import "MORuntimeViewController.h"
#import "NSObject+property.h"
#import "UITableView+Placeholder.h"
#import "UIImage+image.h"
#import "MOStudent.h"

@interface MORuntimeViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, strong) MOStudent *xiaoMing;
@property (nonatomic, copy) NSMutableDictionary *dic;

@end

@implementation MORuntimeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    //  [self runtime1];
    [self runtime2];
}

- (void)runtime2 {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    //  self.tableView.ifNeedCheckEmpty = YES;
    __weak typeof(self) weakSelf = self;
    [self.tableView setReloadBlock:^{
        [weakSelf reloadData];
    }];
    [self.view addSubview:self.tableView];
    [self reloadData];
}

- (void)reloadData {
    //  self.tableView.ifNeedCheckEmpty = YES;
    self.tableView.state = MOPlaceholderLoadingState;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.tableView.state = MOPlaceholderNoNetworkState;
        [self.tableView reloadData];
    });
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *indetify = @"UITableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indetify forIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indetify];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%@", indexPath];
    return cell;
}


- (void)runtime1 {
    [self.dic setObject:@"ss" forKey:@"hh"];
    
    // --------   1、替换系统方法   --------
    UIImageView *imgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"IMG_0991"]];
    [self.view addSubview:imgV];
    imgV.frame = CGRectMake(100, 100, 100, 100);
    
    // --------   2、给分类添加属性   --------
    NSObject *objc = [[NSObject alloc] init];
    objc.name = @"hehe";
    NSLog(@"%@", objc.name);
    
    // --------   字典转模型   --------
    NSDictionary *friend = @{@"name":@"huhu", @"age":@25};
    NSDictionary *dic = @{@"name":@"momo", @"age":@24, @"friends":@[friend, friend]};
    MOStudent *stu = [MOStudent modelWithDict:dic];
    NSLog(@"%@", stu.name);
    NSLog(@"%@", [stu class]);
    
    // --------   4、动态添加方法   --------
    // 应用场景：如果一个类方法非常多，加载类到内存的时候也比较耗费资源，需要给每个方法生成映射表，可以使用动态给某个类，添加方法解决
    // 需求：runtime 动态添加方法处理调用一个未实现的方法 和 去除报错
    [stu performSelector:@selector(run:) withObject:@10];
    
    stu.nickName = @"aaa";
    NSLog(@"nickName %@", stu.nickName);
    
    // --------   5、动态变量控制   --------
    self.xiaoMing = [MOStudent modelWithDict:@{@"name":@"xiaoming", @"age":@22}];
    unsigned int count = 0;
    Ivar *ivar = class_copyIvarList([self.xiaoMing class], &count);
    for (int i = 0; i < count; i++) {
        Ivar var = ivar[i];
        // 成员变量 -> 属性名
        const char *varName = ivar_getName(var);
        NSString *name = [NSString stringWithUTF8String:varName];
        
        // 属性名 -> 成员变量
        Ivar ivar = class_getClassVariable([self.xiaoMing class], varName);
        
        if ([name isEqualToString:@"_name"]) {
            // 也可对私有变量赋值
            object_setIvar(self.xiaoMing, var, @"xiaohong");
        }
        if ([name isEqualToString:@"_age"]) {
            object_setIvar(self.xiaoMing, var, @20);
        }
    }
    NSLog(@"xiaoMing %@", self.xiaoMing.age);
    NSLog(@"xiaoMing %@", self.xiaoMing.name);
    
    // --------   6、实现NSCoding的归档和解档   --------
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *filePath = [path stringByAppendingString:[NSString stringWithFormat:@"MOStudent:%@", stu.name]];
    [NSKeyedArchiver archiveRootObject:stu toFile:filePath];    // 写
    stu = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath]; // 读
    
    // --------   7、获取属性和方法列表   --------
    // 属性列表
    objc_property_t *propertyList = class_copyPropertyList([self.xiaoMing class], &count);
    for (int i = 0; i < count; i++) {
        const char *name = property_getName(propertyList[i]);
        NSLog(@"property : %@", [NSString stringWithUTF8String:name]);
    }
    Class MOStudentClass = object_getClass([stu class]);
    // 成员变量列表
    Ivar *allIvar = class_copyIvarList(MOStudentClass, &count);
    
    // 方法列表
    Method *methodList = class_copyMethodList([self.xiaoMing class], &count);
    for (int i = 0; i < count; i++) {
        Method method = methodList[i];
        NSLog(@"method : %@", NSStringFromSelector(method_getName(method)));
    }
    // 类方法
    Method *allMethod = class_copyMethodList(MOStudentClass, &count); // 类的所有方法
    SEL oriSEL = @selector(arrayContainModelClass);
    Method oriMethod = class_getClassMethod(MOStudentClass, oriSEL);
    NSLog(@"class method : %@", NSStringFromSelector(method_getName(oriMethod)));
    
    // 实例方法
    SEL instanceSEL = @selector(thinking);
    Method instanceMethod = class_getInstanceMethod([stu class], instanceSEL);
    NSLog(@"instance method : %@", NSStringFromSelector(method_getName(instanceMethod)));
    
    // 协议
    __unsafe_unretained Protocol **protocolList = class_copyProtocolList([stu class], &count);
    for (int i = 0; i < count; i++) {
        Protocol *protocol = protocolList[i];
        const char *protocolName = protocol_getName(protocol);
        NSLog(@"protocol : %@", [NSString stringWithUTF8String:protocolName]);
    }
    
    // 添加方法
    Method cusMethod;
    BOOL addFunc = class_addMethod(MOStudentClass, oriSEL, method_getImplementation(cusMethod), method_getTypeEncoding(cusMethod));
    
    // 替换原方法
    class_replaceMethod(MOStudentClass, cusMethod, method_getImplementation(oriMethod), method_getTypeEncoding(oriMethod));
    
    // 交换两个方法
    method_exchangeImplementations(oriMethod, cusMethod);
    
    // --------   8、动态添加方法   --------
    class_addMethod([MOStudent class], @selector(sayHi), (IMP)myAddingFunction, 0);
    if ([self.xiaoMing respondsToSelector:@selector(sayHi)]) {
        [self.xiaoMing performSelector:@selector(sayHi) withObject:nil];
    }
    
    [[MOStudent alloc] init];
}

void myAddingFunction(id self, SEL _cmd) {
    NSLog(@"hi");
}

@end
