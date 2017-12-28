//
//  BBBannerView.m
//  BBBannerView
//
//  Created by ibabyblue on 2017/12/27.
//  Copyright © 2017年 mbp. All rights reserved.
//

#import "BBBannerView.h"

#pragma mark - 宏定义
#define kWidth self.frame.size.width
#define kHeight self.frame.size.height

typedef void(^clickFeedBack)(NSUInteger index);

@interface BBBannerView ()<UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView      *scrollView;
@property (nonatomic, strong) UIPageControl     *pageControl;
@property (nonatomic, strong) NSMutableArray    *imageViews;
@property (nonatomic, strong) NSArray           *images;
@property (nonatomic, assign) NSUInteger        currentIndex;
@property (nonatomic, copy) clickFeedBack       clickFeedBack;
@end

@implementation BBBannerView
#pragma mark - 懒加载
- (NSArray *)images{
    if (_images == nil) {
        _images = [[NSArray alloc] init];
    }
    return _images;
}

- (NSMutableArray *)imageViews{
    if (_imageViews == nil) {
        _imageViews = [[NSMutableArray alloc] init];
    }
    return _imageViews;
}

- (UIScrollView *)scrollView{
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _scrollView;
}

- (UIPageControl *)pageControl{
    if (_pageControl == nil) {
        _pageControl = [[UIPageControl alloc] init];
        _pageControl.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _pageControl;
}

#pragma mark - setter方法
- (void)setIsNeedPageControl:(BOOL)isNeedPageControl{
    _isNeedPageControl = isNeedPageControl;
    if (![self.pageControl isHidden]) {
        [self.pageControl setHidden:YES];
    }
}

- (void)setPageControlPosition:(BBBannerViewPageControlPosition)pageControlPosition{
    
    _pageControlPosition = pageControlPosition;
    [self setNeedsDisplay];
    
}

- (void)setCurrentPageTintColor:(UIColor *)currentPageTintColor{
    
    _currentPageTintColor = currentPageTintColor;
    self.pageControl.currentPageIndicatorTintColor = currentPageTintColor;
    [self setNeedsDisplay];
    
}

- (void)setPageTintColor:(UIColor *)pageTintColor{
    
    _pageTintColor = pageTintColor;
    self.pageControl.pageIndicatorTintColor = pageTintColor;
    [self setNeedsDisplay];
    
}

- (void)setOffsetRight:(CGFloat)offsetRight{
    _offsetRight = offsetRight;
    [self updateConstraints];
}

- (void)setOffsetBottom:(CGFloat)offsetBottom{
    _offsetBottom = offsetBottom;
    [self updateConstraints];
}
#pragma mark - 初始化方法
- (instancetype)initWithFrame:(CGRect)frame images:(NSArray *)images clickFeedBack:(void (^)(NSUInteger))clickFeedBack{
    
    if (self = [super initWithFrame:frame]) {
        //1.保存数据
        self.images = images;
        self.clickFeedBack = clickFeedBack;
        //2.初始化界面
        [self setupUI];
        
        //3.更新约束
        [self setNeedsUpdateConstraints];
        
    }
    return self;
    
}

#pragma mark - 类方法
+ (instancetype)bannerViewWithFrame:(CGRect)frame images:(NSArray *)images clickFeedBack:(void (^)(NSUInteger))clickFeedBack{
    return [[self alloc] initWithFrame:frame images:images clickFeedBack:clickFeedBack];
}

/**
 初始化界面
 */
- (void)setupUI{
    
    //1.UIScrollView
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.bounces = NO;
    self.scrollView.contentSize = CGSizeMake(kWidth * 3, kHeight);
    self.scrollView.contentOffset = CGPointMake(kWidth, 0);
    self.scrollView.delegate = self;
    [self.scrollView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)]];
    [self addSubview:self.scrollView];
    
    //2.初始化imageView
    if (self.images.count != 1) {
        //2.1不止一张图片
        for (NSUInteger i = 0; i<3; i++) {
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.frame = CGRectMake(kWidth * i, 0, kWidth, kHeight);
            imageView.userInteractionEnabled = YES;
            NSInteger index = 0;
            if (i == 0) index = self.images.count - 1;
            if (i == 1) index = 0;
            if (i == 2) index = 1;
            [imageView setImage:self.images[index]];
            imageView.tag = index;
            [self.imageViews addObject:imageView];
            [self.scrollView addSubview:imageView];
        }
        
        //2.2页码
        self.pageControl.numberOfPages = self.images.count;
        self.pageControl.currentPage = 0;
        self.pageControl.currentPageIndicatorTintColor = [UIColor yellowColor];
        self.pageControl.pageIndicatorTintColor = [UIColor whiteColor];
        [self addSubview:self.pageControl];
        
    }else{
        //2.1只有单张图片
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.frame = CGRectMake(0, 0, kWidth, kHeight);
        imageView.userInteractionEnabled = YES;
        [imageView setImage:self.images.lastObject];
        [self.scrollView addSubview:imageView];
        self.scrollView.contentSize = CGSizeZero;
        self.scrollView.contentOffset = CGPointZero;
    }
    
}

#pragma mark - 点击手势事件
- (void)tapAction:(UIGestureRecognizer *)gesture{
    if ([gesture isKindOfClass:[UITapGestureRecognizer class]]) {
        self.clickFeedBack(self.currentIndex);
    }
}

#pragma mark - UIScrollView代理方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    //1.计算pageControl是否切换currentPage
    if (self.scrollView.contentOffset.x < kWidth * 0.5) {
        if ([_imageViews[1] tag] == 0) {
            self.pageControl.currentPage = self.images.count - 1;
        }else{
            self.pageControl.currentPage = [_imageViews[1] tag] - 1;
        }
    }else if (self.scrollView.contentOffset.x > kWidth * 1.5){
        if ([_imageViews[1] tag] == (self.images.count - 1)) {
            self.pageControl.currentPage = 0;
        }else{
            self.pageControl.currentPage = [_imageViews[1] tag] + 1;
        }
    }else{
        self.pageControl.currentPage = [_imageViews[1] tag];
    }
    self.currentIndex = self.pageControl.currentPage;
    
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self layoutImageViewsAndPageControl];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    [self layoutImageViewsAndPageControl];
}

/**
 更新imageView和pageControl
 */
- (void)layoutImageViewsAndPageControl{
    
    NSInteger dalta = 0;
    if (self.scrollView.contentOffset.x > kWidth){//左滑
        dalta = 1;
    }else if (self.scrollView.contentOffset.x == 0){//右滑
        dalta = -1;
    }else{
        return;
    }
    
    for (UIImageView *imageView in _imageViews) {
        NSInteger index = imageView.tag + dalta;
        if (index < 0) {
            index = self.pageControl.numberOfPages - 1;
        } else if (index >= self.pageControl.numberOfPages) {
            index = 0;
        }
        imageView.tag = index;
        [imageView setImage:_images[index]];
    }
    
    self.scrollView.contentOffset = CGPointMake(kWidth, 0);
    
}

#pragma mark - 系统布局方法
- (void)updateConstraints{
    
    //1.UIScrollView 布局
    NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:self.scrollView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.scrollView.superview attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0];
    NSLayoutConstraint *bottomConstraint = [NSLayoutConstraint constraintWithItem:self.scrollView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.scrollView.superview attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0];
    NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:self.scrollView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0.0 constant:kWidth];
    [self addConstraints:@[topConstraint,bottomConstraint]];
    [self.scrollView addConstraint:widthConstraint];
    
    //2.UIPageControl 布局
    //2.1中下
    void (^pageControlBottomCenter)() = ^{
        NSLayoutConstraint *leftConstraint = [NSLayoutConstraint constraintWithItem:self.pageControl attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.pageControl.superview attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0.0];
        NSLayoutConstraint *rightConstraint = [NSLayoutConstraint constraintWithItem:self.pageControl attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.pageControl.superview attribute:NSLayoutAttributeRight multiplier:1.0 constant:0.0];
        NSLayoutConstraint *bottomConstraint = [NSLayoutConstraint constraintWithItem:self.pageControl attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.pageControl.superview attribute:NSLayoutAttributeBottom multiplier:1.0 constant:self.offsetBottom ? -self.offsetBottom : 0.0];
        [self addConstraints:@[leftConstraint,rightConstraint,bottomConstraint]];
    };
    
    //2.2右下
    void (^pageControlBottomRight)() = ^{
        NSLayoutConstraint *rightConstraint = [NSLayoutConstraint constraintWithItem:self.pageControl attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.pageControl.superview attribute:NSLayoutAttributeRight multiplier:1.0 constant:self.offsetRight ? -self.offsetRight : -15.0];
        NSLayoutConstraint *bottomConstraint = [NSLayoutConstraint constraintWithItem:self.pageControl attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.pageControl.superview attribute:NSLayoutAttributeBottom multiplier:1.0 constant:self.offsetBottom ? -self.offsetBottom : 0.0];
        [self addConstraints:@[rightConstraint,bottomConstraint]];
    };
    
    if (self.images.count != 1) {
        
        switch (self.pageControlPosition) {
            case BBBannerViewPageControlPositionBottomCenter:
                pageControlBottomCenter();
                break;
            case BBBannerViewPageControlPositionBottomRight:
                pageControlBottomRight();
                break;
            default:
                pageControlBottomCenter();
                break;
        }
        
    }
    
    [super updateConstraints];
}

+ (BOOL)requiresConstraintBasedLayout{
    return YES;
}

@end
