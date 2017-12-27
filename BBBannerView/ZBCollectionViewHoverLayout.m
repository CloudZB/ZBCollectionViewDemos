
//
//  ZBCollectionViewHoverLayout.m
//  waterfall
//
//  Created by ibabyblue on 16/12/13.
//  Copyright © 2016年 mbp. All rights reserved.
//

#import "ZBCollectionViewHoverLayout.h"

@implementation ZBCollectionViewHoverLayout

-(NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    NSArray *items = [super layoutAttributesForElementsInRect:rect];
    [items enumerateObjectsUsingBlock:^(UICollectionViewLayoutAttributes *attributes, NSUInteger idx, BOOL * _Nonnull stop) {
        [self recomputeCellAttributesFrame:attributes];
    }];
    return items;
}

- (void)recomputeCellAttributesFrame:(UICollectionViewLayoutAttributes *)attributes{
    //获取悬停处的y值
    CGFloat minY = CGRectGetMinY(self.collectionView.bounds) + self.collectionView.contentInset.top;
    //拿到布局属性应该出现的位置
    CGFloat finalY = MAX(minY, attributes.frame.origin.y);
    
    CGPoint origin = attributes.frame.origin;
    origin.y = finalY;
    attributes.frame = (CGRect){origin, attributes.frame.size};
    //根据IndexPath设置zIndex能确立顶部悬停的cell被后来的cell覆盖的层级关系
    attributes.zIndex = attributes.indexPath.row;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds{
    return YES;
}

@end
