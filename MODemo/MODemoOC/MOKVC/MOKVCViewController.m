//
//  MOKVCViewController.m
//  MODemoOC
//
//  Created by MikiMo on 2020/12/18.
//

#import "MOKVCViewController.h"
#import "MOPerson.h"

typedef struct {
    float x, y, z;
} ThreeFloats;

@interface MOKVCViewController ()

@property (nonatomic, strong) NSMutableArray<MOPerson *> *persons;
@property (nonatomic, assign) ThreeFloats threeFloats;

@end

@implementation MOKVCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Key Value Coding
    // get
    // valueForKey: 传入NSString属性的名字。
    // valueForKeyPath: 属性的路径，xx.xx
    // valueForUndefinedKey 默认实现是抛出异常，可重写这个函数做错误处理
    
    // set
    // setValue:forKey:
    // setValue:forKeyPath:
    // setValue:forUnderfinedKey:
    // setNilValueForKey: 对非类对象属性设置nil时调用，默认抛出异常。
    
    [self setGet]; // 1. 访问对象属性
    //  [self collection]; // 2. 访问集合属性
    //  [self useOperators]; // 3. 使用集合运算符
    //  [self wrapUnwrap]; // 4. 包装和解包
    //  [self validation]; // 5. 属性验证 (Validating Properties)
    //  [self testAccess]; // 6. 测试访问顺序 (Access Order)
}

#pragma mark - 1. 访问对象属性

- (void)setGet {
    // getter
    MOPerson *person = [[MOPerson alloc] init];
    //  NSLog(@"%@ %@", [[person valueForKey:@"name"] class], [person valueForKey:@"name"]);
    //  [person valueForKeyPath:@"father.name"];
    //  NSDictionary *dic = [person dictionaryWithValuesForKeys:@[@"name", @"hobby"]];
    //  NSLog(@"%@", dic);
    
    // setter
    [person setValue:@"momo" forKey:@"name"];
    //  [person setValue:nil forKey:@"hidden"];
    //  [person setValue:nil forKeyPath:@"father.name"];
    //  [person setValuesForKeysWithDictionary:@{@"name":@"kiki", @"hobby":@"唱歌"}];
    //  NSLog(@"%@", dic);
}

#pragma mark - 2. 访问集合属性

- (void)collection {
    // 初始化数据
    MOPerson *child1 = [MOPerson personWithName:@"child1"];
    MOPerson *child2 = [MOPerson personWithName:@"child2"];
    
    MOPerson *p1 = [MOPerson personWithName:@"momo"];
    p1.childens = [@[child1, child2] mutableCopy];
    MOPerson *p2 = [MOPerson personWithName:@"lili"];
    p2.childens = [@[child2] mutableCopy];
    self.persons = [@[p1, p2] mutableCopy];
    
    // 访问
    NSLog(@"%@", [self mutableArrayValueForKey:@"persons"]);
    NSLog(@"%@", [self mutableArrayValueForKeyPath:@"persons.name"]);
    
    // 重点：
    // mutableArrayValueForKey addObject 可以触发KVO (调用完后地址会发生变化)
    [self addObserver:self forKeyPath:@"persons" options:NSKeyValueObservingOptionNew context:nil];
    //  [self.persons addObject: [MOPerson personWithName:@"coco"]];
    [[self mutableArrayValueForKey:@"persons"] addObject:[MOPerson personWithName:@"momo"]];
    NSLog(@"%@", self.persons);
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    NSLog(@"keyPath: %@\n object: %@\n change: %@", keyPath, object, change);
}

#pragma mark - 3. 使用集合运算符

- (void)useOperators {
    // 1. 聚合运算符：`Aggregation Operators`
    // @avg平均值 @sum求和 @max @min @count
    NSNumber *avgAge = [self.persons valueForKeyPath:@"@avg.age"];
    NSLog(@"avgAge: %@", avgAge);
    
    // 2. 数组运算符：`Array Operators`
    // @distinctUnionOfObjects 返回一个数组，枚举所有取值(去重)
    NSArray *duNames = [self.persons valueForKeyPath:@"@distinctUnionOfObjects.name"];
    NSLog(@"duNames: %@", duNames);
    
    // @unionOfObjects 返回一个数组，枚举所有取值 (不去重)
    NSArray *unNames = [self.persons valueForKeyPath:@"@unionOfObjects.name"];
    NSLog(@"unNames: %@", unNames);
    
    // 3. 嵌套运算符：`Nesting Operators` (集合中包含集合的情况)
    // @distinctUnionOfArrays: 把嵌套数组中所有的值全部放到一个数组中 (去重)
    NSArray *disChilds = [self.persons valueForKeyPath:@"@distinctUnionOfArrays.childens"];
    NSLog(@"disChilds: %@", disChilds);
    
    // @unionOfArrays: 把嵌套数组中所有的值全部放到一个数组中 (不去重)
    NSArray *uniChilds = [self.persons valueForKeyPath:@"@unionOfArrays.childens"];
    NSLog(@"uniChilds: %@", uniChilds);
    
    //   @distinctUnionOfSets: 和@distinctUnionOfArrays类似。因为Set本身就不支持重复
    
    // 补充一下：Array的KVC还能这样用：
    NSArray *arrStrs = @[@"english", @"franch", @"chinese"];
    NSLog(@"%@", [arrStrs valueForKey:@"capitalizedString"]);
    NSLog(@"%@", [arrStrs valueForKey:@"length"]);
}

#pragma mark - 4. 包装和解包

- (void)wrapUnwrap {
    // Wrapping and Unwrapping Structures: NSPoint、NSRange、NSRect、NSSize、NSValue
    // getter
//    NSValue *threeFloat = [self valueForKey:@"threeFloats"];
    // setter
    ThreeFloats floats = {1., 2., 3.};
    NSValue *value = [NSValue valueWithBytes:&floats objCType:@encode(ThreeFloats)];
    [self setValue:value forKey:@"threeFloats"];
}

#pragma mark - 5. 属性验证 (Validating Properties)

- (void)validation {
    // 由于特定于属性的验证方法 通过引用接收的值和错误参数，因此验证有三种可能的结果：
    // 验证 value 对于给定的 key 是否有效
    // 1) 有效返回YES.
    // 2) 无效返回NO, 且会将 error 指针指向 NSError 对象指示失败的原因.
    // 3) 无效, 但是创建一个新的可以有效作为替换的参数, 方法返回 YES, 同时保持错误对象不变。在返回之前，该方法修改值引用以指向新值对象。当它进行修改值时，该方法总是创建一个新对象，而不是修改旧对象，即使值对象是可变的。
    MOPerson *person = [MOPerson personWithName:@"momo"];
    NSError *error = nil;
//    NSString *name = @"J";
    // validateValue: forKey:
    // validateValue: forKeyPath:
    // 返回一个bool, 表示 给定的参数(value)针对于属性(key)是否有效
    //  NSLog(@"forKey: name %i", [person validateValue:&name forKey:@"name" error:&error]);
    //  NSLog(@"forKey: error %@", error);
    
    NSNumber *age = @(-1);
    error = nil;
    NSLog(@"forKey: age %i", [person validateValue:&age forKey:@"age" error:&error]);
    if (error != nil) {
        NSLog(@"forKey: error %@", error);
    }
    NSLog(@"age: %zd", person.age);
    
    //  error = nil;
    //  NSLog(@"forKeyPath: father.name %i", [person validateValue:&name forKeyPath:@"father.name" error:&error]);
    //  NSLog(@"forKeyPath: error %@", error);
    
    
    //  if ([person validateValue:&name forKey:@"name" error:&error]) {
    //    NSLog(@"%@", error);
    //  }
    // 注意: 永远不要在 set<Key>: 方法中调用 Validating Properties 中描述的验证方法.
}

#pragma mark - 6. 测试访问顺序 (Access Order)

- (void)testAccess {
    MOPerson *p1 = [MOPerson new];
    //  [MOPerson personWithName:@"lili" number:@(5)];
    //  NSLog(@"%@", [p1 valueForKey:@"name"]);
    NSArray *name = [p1 valueForKey:@"name"];
    NSLog(@"name: %@", name);
}

@end
