//
//  scrollSideShowView.m
//  ScrollSideShow
//
//  Created by YeYiFeng on 2018/3/23.
//  Copyright © 2018年 叶子. All rights reserved.
//

#import "scrollSideShowView.h"
static const int btnCount = 3;
@interface scrollSideShowView()<UIScrollViewDelegate>
@property(nonatomic,strong) UIScrollView * scrollView;
@property(nonatomic,strong) UIPageControl * pageControl;
@property(nonatomic,strong) NSTimer *timer;

@end
@implementation scrollSideShowView

#pragma mark - 初始化方法
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        // 通过懒加载方式初始化页面控件
        [self addSubview:self.scrollView];
        [self addSubview:self.pageControl];
}
    return self;
}
#pragma mark - 重新布局方法
-(void)layoutSubviews
{
    [super layoutSubviews];
    // 设置scrollView的frame
    self.scrollView.frame = self.bounds;
    CGFloat width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;
    // 滑动区域
    self.scrollView.contentSize = CGSizeMake(btnCount*width, height);
    // 按钮的位置
    for (int i = 0; i<btnCount; i++) {
        UIButton * imgBtn = self.scrollView.subviews[i];
        [imgBtn addTarget:self action:@selector(imgBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        imgBtn.frame = CGRectMake(i*width, 0, width, height);
    }
    self.scrollView.contentOffset  = CGPointMake(width, 0);
    
    //pageControl的frame
    CGFloat W = 100;
    CGFloat H = 30;
    self.pageControl.frame = CGRectMake(width - W -20, height-H-20, W, H);
    
}
#pragma mark - 重写图片数组的set方法
- (void)setImgArrays:(NSArray *)imgArrays
{
    _imgArrays = imgArrays;
    self.pageControl.numberOfPages = imgArrays.count; // pageControl的个数等于图片数组个数
    self.pageControl.currentPage = 0;// 默认一开始显示的是第0页
    [self setShowContent];//开始页面显示
    [self startTimer];//开启定时器
}
// 设置pageControl的当前颜色
-(void)setCurrentColor:(UIColor *)currentColor
{
    _currentColor = currentColor;
    self.pageControl.currentPageIndicatorTintColor = currentColor;
}
// 设置pageControl的其他颜色
-(void)setPageColor:(UIColor *)pageColor
{
    _pageColor = pageColor;
    self.pageControl.pageIndicatorTintColor = pageColor;
}
#pragma mark - 显示展示的内容
-(void)setShowContent
{
//    self.pageControl.currentPage 此属性为重点，通过currentPage设置索引为显示的图片赋值
    for (int i = 0; i<self.scrollView.subviews.count; i++) {
        UIButton * btn = self.scrollView.subviews[i];// 拿到图片按钮
       NSInteger pageIndex = self.pageControl.currentPage;//显示图片的索引
        if (i == 0) { // //第一个btn，隐藏在当前显示的imageBtn的左侧
            pageIndex--;//当前页索引减1就是第一个imageBtn的图片索引
        }
        else if (i == 2) //第三个btn，隐藏在当前显示的imageBtn的右侧
        {
            pageIndex ++;//当前页索引加1就是第三个btn的图片索引
        }
#pragma mark - 重点 此处为无限循环
        if (pageIndex<0) { // 显示最后一张
            pageIndex = self.pageControl.numberOfPages -1;
        }
        else if (pageIndex == self.pageControl.numberOfPages) // 显示第一张
        {
            pageIndex =0;
        }
        btn.tag = pageIndex; // 根据设置的索引设为按钮的tag值
        // 为按钮图片赋值
        [btn setImage:self.imgArrays[pageIndex] forState:UIControlStateNormal];
        [btn setImage:self.imgArrays[pageIndex] forState:UIControlStateHighlighted];
    }
    
}
// 状态更新显示内容
-(void)updateContent
{
    CGFloat width = self.bounds.size.width;
    [self setShowContent];
    // 重新设置偏移量
    self.scrollView.contentOffset  = CGPointMake(width, 0);
    
}
#pragma mark - scrollViewDelegate
//滑动就会调用 操作：根据滑动偏移量摄者pageControl的当前页面
- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
{
    //拖动的时候，哪张图片最靠中间，也就是偏移量最小，就滑到哪页
    NSInteger page = 0;
    CGFloat minDistance = MAXFLOAT; // 参数用来记录偏移量
    //遍历三个imageView,看那个图片偏移最小，也就是最靠中间
    for (int i =0; i<self.scrollView.subviews.count; i++) {
        
        UIButton * imgBtn = self.scrollView.subviews[i];
        CGFloat distance = 0;
        // 用绝对值取值
        distance = ABS(imgBtn.frame.origin.x - scrollView.contentOffset.x);
        if (distance < minDistance) {
            minDistance = distance; // 这里赋值不要混淆，否则索引容易错乱
            page = imgBtn.tag;
        }
        self.pageControl.currentPage = page;
    }
}
// 开始拖拽时 关闭定时器
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView;
{
    [self closeTimer];
}
// 结束拖拽  开启定时器
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;
{
    [self startTimer];
}
// 结束拖拽 更新页面显示内容
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView;
{
    [self updateContent];
}
// 滑动动画结束 更新页面显示内容
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView;
{
    [self updateContent];
}
// 解决bug,因为拖拽时
// 开启定时器
-(void)startTimer
{
    NSTimer  * timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(nextImage) userInfo:nil repeats:YES];
    // 需要把定时器加入到runloop,这样就不会因为滑动而造成线阻塞
    [[NSRunLoop currentRunLoop]addTimer:timer forMode:NSRunLoopCommonModes];
    self.timer = timer;
}
// 销毁定时器
-(void)closeTimer
{
    [self.timer invalidate];
    self.timer = nil;
    
}
// 页面销毁时 需要销毁定时器
-(void)dealloc
{
    [self closeTimer];
}
// 定时器绑定方法
-(void)nextImage
{
    CGFloat width = self.bounds.size.width;
    [self.scrollView setContentOffset:CGPointMake(2 * width, 0) animated:YES];
    
}
// 图片按钮点击
-(void)imgBtnClick:(UIButton *)button
{
    // delegate回调和block回调之前，判断协议是否实现
    if ([self.delegate respondsToSelector:@selector(scrollViewWith:andSelectImage:)]) {
        [self.delegate scrollViewWith:self andSelectImage:button.tag];
    }
    
}
// 懒加载页面控件
-(UIScrollView *)scrollView
{
    if (!_scrollView) {
        // 初始化页面控件
        _scrollView = [[UIScrollView alloc]init];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator =NO;
        _scrollView.bounces = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
  
        for (int i = 0; i<btnCount; i++) {
            UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [_scrollView addSubview:btn];
        }
        
    }
    return _scrollView;
}
-(UIPageControl *)pageControl
{
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc]init];
    }
    return _pageControl;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
