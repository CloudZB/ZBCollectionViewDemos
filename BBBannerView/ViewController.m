//
//  ViewController.m
//  BBBannerView
//
//  Created by ibabyblue on 16/12/15.
//  Copyright © 2016年 mbp. All rights reserved.
//

#import "ViewController.h"
#import "ZBCollectionViewFlowLayout.h"
#import "ZBCollectionViewHoverLayout.h"
#import "ZBCollectionViewScanPhotosLayout.h"
#import "ZBCollectionViewCircleLayout.h"
#import "ZBCollectionViewPyramidLayout.h"

@interface ViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>

/**
 数据源数组
 */
@property (nonatomic, strong) NSMutableArray *items;
/**
 collectionView
 */
@property (nonatomic, strong) UICollectionView *collectionView;
@end

@implementation ViewController

/**
 数据源数组的懒加载
 */
-(NSMutableArray *)items{
    if (_items == nil) {
        _items = [NSMutableArray arrayWithObjects:@123,@34,@134,@45,@78,@69,@121,@234,@23,@85,@75,@85,@53,@74,@83,@35,@173,@63,@199,@56,@84,@52,@42,@84,@43,@123,@234,@134,@45,@78,@69,@121,@234,@23,@85,@75,@85,@53,@74,@83, nil];
    }
    return _items;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    //1.自定义布局
    //1.1 瀑布流
    ZBCollectionViewFlowLayout *flowLayout = [[ZBCollectionViewFlowLayout alloc] init];
    flowLayout.edgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    flowLayout.columnCount = 3;
    flowLayout.columnMargin = 5;
    flowLayout.rowMargin = 5;
    flowLayout.itemHeightBlock = ^CGFloat(NSIndexPath *indexPath){
        return [self.items[indexPath.row] floatValue];
    };
    
    //1.2 悬顶效果
    ZBCollectionViewHoverLayout *hoverLayout = [[ZBCollectionViewHoverLayout alloc] init];
    hoverLayout.itemSize = CGSizeMake(self.view.frame.size.width, 50);
    hoverLayout.minimumLineSpacing = -1;
    
    //1.3 圆环展示
    ZBCollectionViewCircleLayout *circleLayout = [[ZBCollectionViewCircleLayout alloc] init];
    circleLayout.itemSize = CGSizeMake(50, 50);
    circleLayout.circleRadius = 80;
    circleLayout.circleCenter = CGPointMake(CGRectGetWidth(self.view.frame) * 0.5, CGRectGetHeight(self.view.frame) * 0.5);
    
    //1.4 line布局 图片浏览
    ZBCollectionViewScanPhotosLayout *scanPhotoLayout = [[ZBCollectionViewScanPhotosLayout alloc] init];
    scanPhotoLayout.itemSize = CGSizeMake(300, 500);
    
    //1.5 pyramid布局 电影售卖 选择
    ZBCollectionViewPyramidLayout *pyramidLayout = [[ZBCollectionViewPyramidLayout alloc] init];
    pyramidLayout.itemSize = CGSizeMake(300, 500);
    pyramidLayout.minimumLineSpacing = -150;
    
    //2.实例化collectionView
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) collectionViewLayout:scanPhotoLayout];
    //2.1设置collectionView的代理
    collectionView.delegate = self;
    collectionView.dataSource = self;
    //2.2赋值给全局变量
    self.collectionView = collectionView;
    //2.3添加到当前控制器view上
    [self.view addSubview:collectionView];
    
    //3.collectionView 注册cell
    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:ZB_WaterFallCell_identifier];
    
}

#pragma mark - UICollectionView 代理/数据源方法
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.items.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    //1.实例化collectionView cell
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ZB_WaterFallCell_identifier forIndexPath:indexPath];
    
    //2.cell设置随机色
    if (cell) {
        cell.backgroundColor = ZB_RandomColor;
    }
    
    //3.cell设置圆角
    cell.layer.cornerRadius = 4;
    cell.clipsToBounds = YES;
    
    //4.返回cell
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    //1.数据源数组 删除indexPath.row 对应的数据
    [self.items removeObjectAtIndex:indexPath.item];
    //2.删除collectionView单元格 自动重新布局
    [self.collectionView deleteItemsAtIndexPaths:@[indexPath]];
}

@end
