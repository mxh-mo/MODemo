//
//  MOTableViewOptimizeViewController.m
//  MODemoOC
//
//  Created by MikiMo on 2020/12/18.
//

#import "MOTableViewOptimizeViewController.h"

@interface MOTableViewOptimizeViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tabelView;
@end

@implementation MOTableViewOptimizeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 提前计算并缓存好高度
    // 滑动时按需加载, 防止卡顿 配合SDWebImage https://github.com/johnil/VVeboTableViewDemo
    //  dispatch_async(DISPATCH_QUEUE_PRIORITY_DEFAULT, ^{
    //    // 异步绘制
    //  });
    // 缓存一切可以缓存的
    
    
    // 默认高度44 定高的cell最好指定高度, 减少不必要的计算
    self.tabelView.rowHeight = 88;
    // 减少视图数目
    // 减少多余的绘制操作
    // 不给cell动态添加subView 用hidden属性 控制显示/隐藏
    // 网络请求, 图片加载 开启多线程
    // willDisplayCell 可以将数据绑定放在cell显示出来之后再执行 以提高效率
    // 缓存不便于重用的view (存model里)
    
    // --------   自适应高度   --------
    // 尽量提高计算效率, 已计算过的高度需要进行缓存, 没必要进行第二次运算
    // 必须满足3个条件
    // 1. cell.contentView 四边与内部元素有约束关系(Autolayout)
    // 2. 指定estimatedRowHeight属性的默认值
    self.tabelView.estimatedRowHeight = 44;
    // 3. 指定rowHeight属性为 automatic dimension
    self.tabelView.rowHeight = UITableViewAutomaticDimension;
    
    // --------   离屏渲染: 圆角/阴影   --------
    // 离屏渲染: 圆角/阴影, 另外开辟渲染缓冲区, 消耗性能 (多: 缓冲区频繁合并 上下文频繁切换, 导致掉帧)
    UIImageView *imgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"placeholder"]];
    imgV.frame = CGRectMake(100, 100, 100, 100);
    [self.view addSubview:imgV];
    
    // 优化方案1: (推荐使用) CAShapeLayer UIBezierPath 结合, 可设置单个圆角
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:imgV.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:imgV.bounds.size];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    // 设置大小
    maskLayer.frame = imgV.bounds;
    // 设置图形样子
    maskLayer.path = maskPath.CGPath;
    imgV.layer.mask = maskLayer;
    // 说明: AShapeLayer动画渲染直接提交到手机的GPU当中，相较于view的drawRect方法使用CPU渲染而言，其效率极高，能大大优化内存使用情况
    
    // 优化方案2: 使用贝塞尔曲线UIBezierPath Core Graphics框架画出一个圆角
    // 开始对imageView进行画图
    UIGraphicsBeginImageContextWithOptions(imgV.bounds.size, NO, 1.0);
    // 使用 贝赛尔曲线 画出一个圆形图
    [[UIBezierPath bezierPathWithRoundedRect:imgV.bounds cornerRadius:imgV.frame.size.width] addClip];
    [imgV drawRect:imgV.bounds];
    imgV.image = UIGraphicsGetImageFromCurrentImageContext();
    // 结束画图
    UIGraphicsEndImageContext();
    
    // shadow shadowPath优化
    imgV.layer.shadowColor = [UIColor redColor].CGColor;
    imgV.layer.shadowOpacity = 0.8;
    imgV.layer.shadowRadius = 2.0;
    imgV.layer.shadowOffset = CGSizeMake(0, 0);
    CGFloat width = 3;
    CGRect imgFrame = imgV.bounds;
    CGRect shadowFrame = CGRectMake(imgFrame.origin.x - width, imgFrame.origin.y - width, imgFrame.size.width + 2*width, imgFrame.size.height + 2*width);
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:shadowFrame];
    imgV.layer.shadowPath = path.CGPath;
    
    // 使用异步进行layer渲染（Facebook开源的异步绘制框架AsyncDisplayKit）
    // 设置layer的opaque(不透明)值为YES，减少复杂图层合成
    // 尽量使用不包含透明（alpha）通道的图片资源
    // 尽量设置layer的大小值为整形值
    
    // --------   Core Animation工具检测离屏渲染   --------
    // Xcode->Open Develeper Tools->Instruments
    // https://blog.csdn.net/hmh007/article/details/54907560
}

/// 可以将数据绑定放在cell显示出来之后再执行 以提高效率
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIncdentify = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIncdentify];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIncdentify];
    }
    // tableView停止滑动的时候异步加载图片
    if (tableView.dragging == NO && tableView.decelerating == NO) {
        // 开始异步加载图片
        NSArray *visiblePaths = [tableView indexPathsForVisibleRows];
//        for (NSIndexPath *indexPath in visiblePaths) {
            // 获取dataSource里的对象, 并且判断加载完成是不需要再次异步加载
//        }
    }
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

@end
