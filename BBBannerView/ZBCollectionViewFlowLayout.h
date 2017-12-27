//
//  ZBCollectionViewFlowLayout.h
//  waterfall
//
//  Created by ibabyblue on 16/12/13.
//  Copyright © 2016年 mbp. All rights reserved.
//  瀑布流layout（目前采用Block方式获取item的高度）

#import <UIKit/UIKit.h>

typedef CGFloat(^itemHeightBlock)(NSIndexPath *indexPath);

@interface ZBCollectionViewFlowLayout : UICollectionViewFlowLayout
/**
 UICollectionView 四周边距
 */
@property (nonatomic, assign) UIEdgeInsets edgeInsets;

/**
 列数
 */
@property (nonatomic, assign) NSInteger columnCount;

/**
 列间距
 */
@property (nonatomic, assign) NSInteger columnMargin;

/**
 行间距
 */
@property (nonatomic, assign) NSInteger rowMargin;
/**
 获取每个item高度Block
 */
@property (nonatomic, copy) itemHeightBlock itemHeightBlock;
@end
