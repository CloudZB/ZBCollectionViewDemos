//
//  ZBCollectionViewPyramidLayout.m
//  ZBCollectionViewLayoutDemos
//
//  Created by zhangb on 2017/1/4.
//  Copyright © 2017年 mbp. All rights reserved.
//

#import "ZBCollectionViewPyramidLayout.h"

@implementation ZBCollectionViewPyramidLayout
/**
 布局的初始化
 */
-(void)prepareLayout
{
    //1.设置滚动方向
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    //2.设置内边距
    CGFloat insert = (self.collectionView.frame.size.width - self.itemSize.width) * 0.5;
    self.sectionInset = UIEdgeInsetsMake(0, insert, 0, insert);
}
/**
 重新刷新布局时候调用
 */
-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //返回某个item对应的属性
    UICollectionViewLayoutAttributes *arrs = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    return arrs;
}

-(NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    //1.获取super计算的布局属性
    NSArray *arrary = [super layoutAttributesForElementsInRect:rect];
    //2.计算可见collectionview中心的X
    CGFloat centerX = self.collectionView.contentOffset.x + self.collectionView.frame.size.width * 0.5;
    //3.计算缩放比例
    for (UICollectionViewLayoutAttributes *arrs in arrary) {
        //3.1 cell中心和collectionview的中心距离
        CGFloat margin = ABS(centerX - arrs.center.x);
        //3.2 cell缩放比例
        CGFloat scale = 1 - (margin / self.collectionView.frame.size.width);
        
        if (scale > 0.7) {
            //3.2.1 设置透明度
            arrs.alpha = 1;
            //3.2.2 设置显示层级关系
            for (int i = 0; i < arrary.count; i++) {
                UICollectionViewLayoutAttributes *subAttr = [arrary objectAtIndex:i];
                if (i < [arrary indexOfObject:arrs]) {
                    subAttr.zIndex = i;
                }else if (i == [arrary indexOfObject:arrs]){
                    arrs.zIndex = 1024;
                }else{
                    subAttr.zIndex = -[arrary indexOfObject:arrs];
                }
            }
        }else
        {
            arrs.alpha = 0.7;
        }
        arrs.transform3D = CATransform3DMakeScale(scale, scale, scale);
    }
    return arrary;
}
/**
 滚动停止后collectionview的偏移量
 */
-(CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity
{
    //1.获取当前显示collectionView的rect
    CGRect CurrentRect;
    CurrentRect.origin.x = proposedContentOffset.x;
    CurrentRect.origin.y = 0;
    CurrentRect.size = CGSizeMake(self.collectionView.frame.size.width, self.collectionView.frame.size.height);
    
    //2.获取当前可见的item属性数组
    NSArray *array = [super layoutAttributesForElementsInRect:CurrentRect];
    
    //3.获取可见collectionView的中心
    CGFloat centerX = proposedContentOffset.x + self.collectionView.frame.size.width * 0.5;
    
    CGFloat MinMargin = MAXFLOAT;
    for (UICollectionViewLayoutAttributes *arr in array) {
        if (ABS(MinMargin) > ABS(arr.center.x - centerX)) {
            MinMargin = arr.center.x - centerX;
        }
    }
    proposedContentOffset.x += MinMargin;
    return proposedContentOffset;
    
}
/**
 显示范围发生变化后是否重新布局
 */
-(BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}

@end
