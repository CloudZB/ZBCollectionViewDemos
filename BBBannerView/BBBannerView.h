//
//  BBBannerView.h
//  BBBannerView
//
//  Created by ibabyblue on 2017/12/27.
//  Copyright © 2017年 mbp. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, BBBannerViewPageControlPosition) {
    BBBannerViewPageControlPositionBottomCenter = 1 << 0,
    BBBannerViewPageControlPositionBottomRight  = 1 << 1,
};

@interface BBBannerView : UIView

/**页码的位置,默认在中下*/
@property (nonatomic, assign) BBBannerViewPageControlPosition   pageControlPosition;

/**是否需要设置页码，默认显示(多张图片显示，单张图片不显示)*/
@property (nonatomic, assign) BOOL                              isNeedPageControl;

/**设置当前页码的颜色，默认黄色*/
@property (nonatomic, strong, nullable) UIColor                 *currentPageTintColor;

/**设置页码的颜色，默认白色*/
@property (nonatomic, strong, nullable) UIColor                 *pageTintColor;

/**设置UIPageControl右侧偏移量*/
@property (nonatomic, assign) CGFloat                           offsetRight;

/**设置UIPageControl底侧偏移量*/
@property (nonatomic, assign) CGFloat                           offsetBottom;

/**设置是否需要自动轮播,默认为YES*/
@property (nonatomic, assign) BOOL                              isNeedAutoCarousel;

/**设置轮播时间间隔,默认为2s*/
@property (nonatomic, assign) CGFloat                           intervalTime;


/**
 轮播器初始化动态方法

 @param images 图片数组
 @param clickFeedBack 点击图片回调
 @return 轮播器组件
 */
- (instancetype _Nonnull )initWithFrame:(CGRect)frame images:(NSArray * _Nonnull)images clickFeedBack:(void (^_Nullable)(NSUInteger index))clickFeedBack;

/**
 轮播器初始化静态方法

 @param images 图片数组
 @param clickFeedBack 点击图片回调
 @return 轮播器组件
 */
+ (instancetype _Nullable )bannerViewWithFrame:(CGRect)frame images:(NSArray *_Nonnull)images clickFeedBack:(void (^_Nullable)(NSUInteger index))clickFeedBack;

@end
