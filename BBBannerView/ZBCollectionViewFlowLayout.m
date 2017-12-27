//
//  ZBCollectionViewFlowLayout.m
//  waterfall
//
//  Created by ibabyblue on 16/12/13.
//  Copyright © 2016年 mbp. All rights reserved.
//

#import "ZBCollectionViewFlowLayout.h"

@interface ZBCollectionViewFlowLayout ()
/**
 UICollectionView contentSize的高度
 */
@property (nonatomic, assign) NSInteger contentSizeHeight;

/**
 记录每列当前高度
 */
@property (nonatomic, strong) NSMutableArray *columnHeights;

/**
 布局属性数组
 */
@property (nonatomic, strong) NSMutableArray *attributes;
@end

@implementation ZBCollectionViewFlowLayout

- (NSMutableArray *)columnHeights{
    if (_columnHeights == nil) {
        _columnHeights = [NSMutableArray array];
    }
    return _columnHeights;
}

- (NSMutableArray *)attributes{
    if (_attributes == nil) {
        _attributes = [NSMutableArray array];
    }
    return _attributes;
}

-(void)prepareLayout{
    [super prepareLayout];
    //初始化布局contentSize的高度
    self.contentSizeHeight = 0;
    //清空列布局高度
    [self.columnHeights removeAllObjects];
    //默认高度为sectionEdge.top
    for (NSInteger i = 0; i < self.columnCount; i++) {
        [self.columnHeights addObject:@(self.edgeInsets.top)];
    }
    //清空属性数组
    [self.attributes removeAllObjects];
    
    //获取数据源数量
    NSInteger items = [self.collectionView numberOfItemsInSection:0];
    for (NSInteger index = 0; index < items; index++) {
        //创建index
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
        //获取cell布局属性
        UICollectionViewLayoutAttributes *attribute = [self layoutAttributesForItemAtIndexPath:indexPath];
        [self.attributes addObject:attribute];
    }
    
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    //获取一个UICollectionViewLayoutAttributes对象
    UICollectionViewLayoutAttributes *attribute = [super layoutAttributesForItemAtIndexPath:indexPath];
    //获取宽度
    CGFloat collectionViewW = CGRectGetWidth(self.collectionView.frame);
    CGFloat itemWidth = (collectionViewW - self.edgeInsets.left - self.edgeInsets.right - (self.columnCount - 1) * self.columnMargin) / self.columnCount;
    
    CGFloat itemHeight = 0;
    if (self.itemHeightBlock) {
        itemHeight = self.itemHeightBlock(indexPath);
    }
    
    //找到数组内目前高度最小的那一列
    NSInteger destinationColumn = 0;
    CGFloat minColumnHeight = [self.columnHeights[0] doubleValue];
    for (NSInteger index = 1; index < self.columnCount; index++) {
        CGFloat columnHeight = [self.columnHeights[index] doubleValue];
        if (minColumnHeight > columnHeight) {
            minColumnHeight = columnHeight;
            destinationColumn = index;
            break;
        }
    }
    //根据列信息，计算出origin的x
    CGFloat x = self.edgeInsets.left + destinationColumn * (itemWidth +self.columnMargin);
    CGFloat y = minColumnHeight;
    if (y != self.edgeInsets.top) {//不是第一行就加上行间距
        y += self.rowMargin;
    }
    //得到布局属性的frame信息
    attribute.frame = CGRectMake(x, y, itemWidth, itemHeight);
    //更新最短那列高度
    self.columnHeights[destinationColumn] = @(CGRectGetMaxY(attribute.frame));
    //更新展示布局所需的高度
    CGFloat columnHeight = [self.columnHeights[destinationColumn] doubleValue];
    if (self.contentSizeHeight < columnHeight) {
        self.contentSizeHeight = columnHeight;
    }
    return attribute;
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    //返回可见item属性数组
    NSMutableArray *visibleArray = [NSMutableArray array];
    for (UICollectionViewLayoutAttributes *cacheAttribute in _attributes) {
        if (CGRectIntersectsRect(cacheAttribute.frame, rect)) {
            [visibleArray addObject:cacheAttribute];
        }
    }
    return visibleArray;
}


- (CGSize)collectionViewContentSize{
    return CGSizeMake(CGRectGetWidth(self.collectionView.frame), self.contentSizeHeight + self.edgeInsets.bottom);
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds{
    return YES;
}

@end
