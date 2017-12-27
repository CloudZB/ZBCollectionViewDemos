//
//  ZBCollectionViewCircleLayout.h
//  waterfall
//
//  Created by ibabyblue on 16/12/14.
//  Copyright © 2016年 mbp. All rights reserved.
//  圆环型图片 layout

#import <UIKit/UIKit.h>

@interface ZBCollectionViewCircleLayout : UICollectionViewLayout
/**
 每个item的尺寸
 */
@property (nonatomic, assign) CGSize itemSize;
/**
 圆环中心
 */
@property (nonatomic, assign) CGPoint circleCenter;
/**
 圆环半径
 */
@property (nonatomic, assign) CGFloat circleRadius;
@end
