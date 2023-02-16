//
//  MOBlockViewController.m
//  MODemoOC
//
//  Created by MikiMo on 2020/12/18.
//

#import "MOBlockViewController.h"
#import "MOPerson.h"

int globalCount = 0; // 全局变量

@interface MOManager : NSObject

@property (nonatomic, copy) NSString *name;

@end

@implementation MOManager

+ (instancetype)sharedInstance {
    static MOManager *shared = nil;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        shared = [[MOManager alloc] init];
    });
    return shared;
}

@end

@interface MOBlockViewController ()

@property (nonatomic, retain) NSString *property;

@end

@implementation MOBlockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Block的三种类型
    //  [self blockType];
    
    // 捕获变量
    // 1、全局变量、全局静态变量: 直接使用，不会改变block结构
    // 2、局部静态变量: 拷贝指针，在block结构体中强引用
    // 3、局部变量:
    // 3.1、基本数据类型对象: 拷贝值
    // 3.2、OC对象: 拷贝指针
    // 重新赋值: 需要 __block 修饰
    // __block 会创建一个 __Block_byref_***_0 的结构体，将变量用这个结构体包裹着，传入block中使用
    // Self的循环引用：捕获了self的指针，copy到block结构体中（强引用）
    [self captureVariables];
}

- (void)blockType {
    // NSGlobalBlock：存储于全局数据区，由系统管理
    // 没有访问auto变量(也叫自动变量，离开作用域就销毁的变量)
    // 如：没有访问任何变量 或 访问了全局变量 或 访问了静态局部变量
    static int localCount = 0; // 静态局部变量
    void(^blockA)(void) = ^{
        NSLog(@"blockA"); // 没有访问任何变量
        NSLog(@"%@", [MOManager sharedInstance].name); // 访问了全局变量
        NSLog(@"%d", localCount); // 访问了静态局部变量
    };
    NSLog(@"blockA: %@", [blockA class]);
    
    // NSStackBlock 栈
    // 访问了auto变量(即：栈区变量/局部变量), 并且 没有被`强指针`引用时!!!
    int count = 0; // 局部变量
    MOPerson *obj = [[MOPerson alloc] init]; // 局部变量
    NSLog(@"blockB: %@", [^{
        NSLog(@"%d", count); // 访问了局部变量
        NSLog(@"%@", obj.name); // 访问了局部变量
        NSLog(@"%@", self.property); // 访问了局部变量
    } class]);
    
    // NSMallocBlock 堆
    // 访问了auto变量，并且 被`强指针`引用时!!!
    void(^blockC)(void) = ^{
        NSLog(@"%d", count); // 访问了局部变量
        NSLog(@"%@", obj.name); // 访问了局部变量
        NSLog(@"%@", self.property); // 访问了局部变量
    };
    NSLog(@"blockC: %@", [blockC class]);
}

- (void)captureVariables {
    static int localCount = 0; // 静态局部变量
    int count = 0; // 局部变量
    MOPerson *obj = [[MOPerson alloc] init];
    NSMutableArray *arr = [NSMutableArray array];
    
    __block int blockCount = count;
    __block MOPerson *blockObj = obj;
    __block typeof(arr) blockArr = arr;
    
    void (^aBlock)(void) = ^{
        // 直接访问
        NSLog(@"%d", globalCount); // 访问全局变量：直接使用，结构不变
        NSLog(@"%d", localCount); // 访问静态局部变量：拷贝指针 到block的结构体 中使用
        NSLog(@"%d", count); // 访问局部基本数据类型：拷贝值 到block的结构体 中使用
        NSLog(@"%@", obj.name); // 访问alloc对象：拷贝指针 到block的结构体 中使用
        NSLog(@"%@", arr); // 访问alloc对象：拷贝指针 到block的结构体 中使用
        
        // 可直接修改的变量：
        globalCount = 1; // 全局变量
        localCount = 2; // 静态局部变量
        obj.name = @"momo"; // 局部变量的属性 (仅修改，而不是重指向)
        [arr addObject:@1]; // 局部可变collection(仅修改，而不是重指向)
        
        // 需要__block修饰，才能修改的
        // 会创建__Block_byref_XX_0结构体包装该变量，将此对象的指针拷贝到block结构体中使用
        blockCount = 3; // 局部基本数据类型
        blockObj = [[MOPerson alloc] init]; // 局部alloc变量
        blockArr = [NSMutableArray array];
    };
    aBlock();
}

@end
