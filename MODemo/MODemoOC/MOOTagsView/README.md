
# 1. 演示录屏

## 1.1. whole show
![whole_show](/assets/whole_show.gif)

## 1.2. select likage
![select_linkage](/assets/select_linkage.gif)

## 1.3. lick item at bar style
![lick_item_at_bar_style](/assets/lick_item_at_bar_style.gif)


# 2. 方案决策

1）为什么要用 `scrollView`，而不用 `collectionView`？

* 主要原因：展开时`收起按钮`需要挤到最后一个`item`的位置。最后一行能放下`最后一个item `和`收起按钮`则放；否则都不放，另起一行
* 次要原因：展开态每行的 `item` 需要左对齐，调整后会跟 收起态 `item` 的尺寸和间距 不同，导致动画时能明显看出跳变

2）为什么要用两个实例？

为了动画的流畅性和选中态的联动


# 3. 关键点实现

1）标签栏选中滑动
```objective-c
/// 滑动到选中的按钮
- (void)scrollToSelectedButton:(UIButton *)button {
    CGFloat width = CGRectGetWidth(self.scrollView.frame);
    CGFloat contentWidth = self.scrollView.contentSize.width;
    CGFloat centerX = CGRectGetMidX(button.frame) - (width / 2.0);
    if (centerX < 0.0) { // 避免滑出左侧
        centerX = 0.0;
    } else if (centerX > contentWidth - width) { // 避免滑出右侧
        centerX = contentWidth - width;
    }
    [self.scrollView setContentOffset:CGPointMake(centerX, 0.0) animated:YES];
}
```

2）标签列表左对齐
```
// 按钮右侧X轴坐标值
CGFloat maxX = contentWidth + obj.size.width + MOOTagsViewPadding;
if (idx == strongSelf.categories.count - 1) { // 若为最后一个，需要给收起按钮留空间
    maxX += MOOTagsViewFoldBtnLeftMarginListType + MOOTagsViewFoldButtonSize;
}
if (maxX > CGRectGetWidth(strongSelf.bounds)) { // 若超出宽度，则另起一行
    contentWidth = MOOTagsViewPadding;
    itemOriginY += MOOTagsViewItemHeight + MOOTagsViewPadding;
}
frame = CGRectMake(contentWidth, itemOriginY, obj.size.width, obj.size.height);
contentWidth += obj.size.width + MOOTagsViewPadding;
```

3）侧滑手势兼容

问题：若当前 `ViewController` 有侧滑手势，且滑动手势在 本标签视图缩小态上时，就会存在手势冲突问题。
解决：判断触摸点在 `scrollView` 内时，则禁用侧滑能力

为当前 VC 实现一个函数，表示是否禁用侧滑能力：
```
/// 滑动的是`分类视图`时屏蔽`侧滑手势`
- (BOOL)responseDragbackAtScreenPoint:(CGPoint)screenPoint {
    if (self.categoriesBarView.alpha > 0.0 &&
        CGRectContainsPoint(self.categoriesBarView.frame, screenPoint)) {
        return NO;
    }
    return YES;
}
```
在 `UINavigationViewController` 的手势方法里，判断是否响应侧滑手势：
```
- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)panGestureRecognizer {
    UIViewController *controller = self.viewControllers.lastObject;
    CGPoint location = [panGestureRecognizer locationInView:self.view];   
    if (![controller responseDragbackAtScreenPoint:location]) {
        return NO;
    }
    return YES;
}
```

# 4. Demo地址

[github demo 地址](https://github.com/mxh-mo/MODemo/tree/main/MODemo/MODemoOC/MOOTagsView)
