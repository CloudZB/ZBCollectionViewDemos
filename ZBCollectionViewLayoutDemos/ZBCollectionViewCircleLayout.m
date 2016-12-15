
//
//  ZBCollectionViewCircleLayout.m
//  waterfall
//
//  Created by zhangb on 16/12/14.
//  Copyright © 2016年 mbp. All rights reserved.
//

#import "ZBCollectionViewCircleLayout.h"

@interface ZBCollectionViewCircleLayout ()
/**
 *  布局属性
 */
@property (nonatomic, strong) NSMutableArray *attrs;

@end

@implementation ZBCollectionViewCircleLayout
- (NSMutableArray *)attrs {
    
    if(!_attrs) {
        
        _attrs = [NSMutableArray array];
        
    }
    
    return _attrs;
}

/**
 初始化布局属性
 */
- (void)prepareLayout {
    [super prepareLayout];
    
    // 先删除之前的布局属性
    [self.attrs removeAllObjects];
    
    // 获取item的个数
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    
    for (NSInteger i = 0; i < count; i++) {
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        
        UICollectionViewLayoutAttributes *attr = [self layoutAttributesForItemAtIndexPath:indexPath];
        
        [self.attrs addObject:attr];
    }
}


- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    
    return self.attrs;
}


/**
 * 这个方法需要返回indexPath位置对应cell的布局属性
 */
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    
    CGFloat radius = self.circleRadius;
    // 圆心的位置
    CGFloat oX = self.circleCenter.x;
    CGFloat oY = self.circleCenter.y;
    
    // 创建布局属性
    UICollectionViewLayoutAttributes *attrs = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    attrs.size = self.itemSize;
    
    if (count == 1) {
        attrs.center = CGPointMake(oX, oY);
    } else {
        CGFloat angle = (2 * M_PI / count) * indexPath.item;
        CGFloat centerX = oX + radius * cos(angle);
        CGFloat centerY = oY - radius * sin(angle);
        attrs.center = CGPointMake(centerX, centerY);
    }
    
    return attrs;
}
@end
