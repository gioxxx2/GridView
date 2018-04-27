//
//  JZGridView.m
//  iPhoneStock
//
//  Created by JZTech-xuz on 2018/4/21.
//  Copyright © 2018年 com.jingzhuan. All rights reserved.
//
#import <Masonry/Masonry.h>
#import "JZGridViewModel.h"
#import "JZDecorationLineView.h"
#import "CustomCollectionViewLayout.h"
#import "JZGridView.h"
#define HexRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define IS_IOS_11 @available(iOS 11.0, *)
#define AppBlack HexRGB(0x181B24)
// gridWidth
#define GridContentWidth 105.0
#define GridTitleContentWidth 105.0
#define GridTitleContentHeight 30.0
#define GridContentHeight 50.0
@interface JZGridView()<UICollectionViewDelegate,UICollectionViewDataSource,customCollectionViewLayoutDelegate>


@property (nonatomic,strong) CustomCollectionViewLayout *layout;
@property (nonatomic,assign) ScrollDirection  scrollDirection;
@property (nonatomic,assign) CGPoint scrollViewStartPosPoint;
@property (nonatomic,strong) UICollectionView *collectionView;

// 插入动画标志位 互斥关系
@property (nonatomic,assign) BOOL inserting;
@property (nonatomic,assign) BOOL deleting;
@property (nonatomic,assign) BOOL sorting;
@end


@implementation JZGridView

@dynamic contentOffset;
@dynamic contentInset;
@dynamic scrollIndicatorInsets;
@dynamic gridHeader;
@dynamic gridFooter;

- (CustomCollectionViewLayout *)layout{
    if (!_layout) {
        _layout = [[CustomCollectionViewLayout alloc]init];
        _layout.delegate = self;
        [_layout registerClass:[JZDecorationLineView class] forDecorationViewOfKind:NSStringFromClass([JZDecorationLineView class])];
    }
    return _layout;
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = YES;
        _collectionView.showsHorizontalScrollIndicator = YES;
        _collectionView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
        // 只能保证大方向，在一些特殊角度无法保证 比如45度
        _collectionView.directionalLockEnabled = YES;
        UIView *bg = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenWidth)];
        bg.backgroundColor = AppBlack;
        _collectionView.backgroundView = bg;
        if (IS_IOS_11) {
            _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _collectionView;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        [self addSubview:self.collectionView];
        if (IS_IOS_11) {
            [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.mas_safeAreaLayoutGuideLeft);
                make.right.equalTo(self.mas_safeAreaLayoutGuideRight);
                make.top.equalTo(self.mas_safeAreaLayoutGuideTop);
                make.bottom.equalTo(self.mas_safeAreaLayoutGuideBottom);
            }];
        }else{
            [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.bottom.top.equalTo(self);
            }];
        }

        self.collectionView.backgroundColor = AppBlack;
        self.collectionView.alwaysBounceVertical = YES;
       
    }
    return self;
}


- (void)setDataSource:(id<JZGridViewDataSource>)dataSource{
    _dataSource = dataSource;
    if (dataSource && [dataSource respondsToSelector:@selector(registCellClassInCollectionView:)]) {
        [dataSource registCellClassInCollectionView:self.collectionView];
    }
}

- (void)setDelegate:(id<JZGridViewDelegate>)delegate{
    _delegate = delegate;
 
}

- (void)setLayoutArrowIndexPaths:(NSArray<NSIndexPath *> *)indexPaths{
    self.layout.arrowIndexPaths = indexPaths.mutableCopy;
}

- (void)setLayoutFixSection:(NSInteger)fixSection{
    self.layout.fixedSection = fixSection;
}

- (void)setLayoutUpdate:(BOOL)update{
    self.layout.invalidLayout = update;
}

- (void)reloadData{
    [self.collectionView reloadData];
}


- (void)setContentOffset:(CGPoint)contentOffset{
    self.collectionView.contentOffset = contentOffset;
}

- (CGPoint)contentOffset{
    return self.collectionView.contentOffset;
}

- (void)setContentInset:(UIEdgeInsets)contentInset{
    self.collectionView.contentInset = contentInset;
}

- (UIEdgeInsets)contentInset{
    return self.collectionView.contentInset;
}

- (void)setScrollIndicatorInsets:(UIEdgeInsets)scrollIndicatorInsets{
    self.collectionView.scrollIndicatorInsets = scrollIndicatorInsets;
}

- (UIEdgeInsets)scrollIndicatorInsets{
    return self.collectionView.scrollIndicatorInsets;
}

- (void)setGridFooter:(MJRefreshFooter *)gridFooter{
    self.collectionView.mj_footer = gridFooter;
}

- (MJRefreshFooter *)gridFooter{
    return self.collectionView.mj_footer;
}

- (void)setGridHeader:(MJRefreshHeader *)gridHeader{
    self.collectionView.mj_header = gridHeader;
}

- (MJRefreshHeader *)gridHeader{
    return self.collectionView.mj_header;
}

- (void)setContentOffset:(CGPoint)offset animated:(BOOL)animated{
    [self.collectionView setContentOffset:offset animated:animated];
}

- (UICollectionViewCell *)cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    return [self.collectionView cellForItemAtIndexPath:indexPath];
}

- (NSInteger)numberOfSections{
    return [self.collectionView numberOfSections];
}

- (void)reloadSections:(NSIndexSet *)sections{
    [self.collectionView reloadSections:sections];
}

- (void)performBatchUpdates:(void (^)(void))update completion:(void (^)(BOOL))completion{
    [self.collectionView performBatchUpdates:update completion:completion];
}

- (void)insertSections:(NSIndexSet *)sections{
    [self.collectionView insertSections:sections];
}

- (void)deleteSections:(NSIndexSet *)sections{
    [self.collectionView deleteSections:sections];
}

#pragma mark customLayout Delegate
- (CGSize)sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(sizeForItemAtIndexPath:)]) {
        return [self.dataSource sizeForItemAtIndexPath:indexPath];
    }
    return CGSizeZero;
}

#pragma mark UICollectionView delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.delegate && [self.delegate respondsToSelector:@selector(gridView:didSelectItemAtIndexPath:)]) {
        [self.delegate gridView:self didSelectItemAtIndexPath:indexPath];
    }
}

#pragma mark UICollectionView dataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(numberOfItemsInSection:)]) {
        return [self.dataSource numberOfItemsInSection:section];
    }
    return 0;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(numberOfSections)]) {
        return [self.dataSource numberOfSections];
    }
    return 0;
}


- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(cellForItemAtIndexPath:collectionView:)]) {
        return [self.dataSource cellForItemAtIndexPath:indexPath collectionView:collectionView];
    }
    return nil;
}


#pragma mark -- 保证滑动只有一个方向 ScrollViewDelegate
// 2
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.scrollDirection == ScrollDirectionNone){
        if (fabs(self.scrollViewStartPosPoint.x-scrollView.contentOffset.x)<
            fabs(self.scrollViewStartPosPoint.y-scrollView.contentOffset.y)){
            self.scrollDirection = ScrollDirectionVertical;
        } else {
            self.scrollDirection = ScrollDirectionHorizontal;
        }
    }
    if (self.scrollDirection == ScrollDirectionVertical) {
        scrollView.contentOffset = CGPointMake(self.scrollViewStartPosPoint.x < 0 ? 0 : self.scrollViewStartPosPoint.x,scrollView.contentOffset.y);
    } else if (self.scrollDirection == ScrollDirectionHorizontal){
        scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x < 0 ? 0 :  scrollView.contentOffset.x , self.scrollViewStartPosPoint.y < 0 ? 0 : self.scrollViewStartPosPoint.y);
        
        self.collectionView.mj_header.mj_x = scrollView.contentOffset.x;
        self.collectionView.mj_footer.mj_x = scrollView.contentOffset.x;
    }
    // 通过不断取消上一个延迟方法，取最后停止的一个延迟方法
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self performSelector:@selector(scrollViewDidEndScrollingAnimation:) withObject:nil afterDelay:0.1];
    if (self.delegate && [self.delegate respondsToSelector:@selector(gridViewDidScroll:)]) {
        [self.delegate gridViewDidScroll:scrollView];
    }
}
// 1
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    self.scrollViewStartPosPoint = scrollView.contentOffset;
    self.scrollDirection = ScrollDirectionNone;
}



#pragma mark 滚动加载方法 1.调用setContenoffset animated 也会触发该方法，2.在scrollViewDidscroll主动调用该方法
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    if (self.delegate && [self.delegate respondsToSelector:@selector(scrollViewDidEndScrollingAnimation:scrollDirection:)]) {
        [self.delegate scrollViewDidEndScrollingAnimation:scrollView scrollDirection:self.scrollDirection];
    }
    self.scrollDirection = ScrollDirectionNone;
}



//3 有加速度decelerate 才会调用4
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (self.scrollDirection == ScrollDirectionHorizontal && !decelerate) {
        CGPoint point = scrollView.contentOffset;
        point.x = round(point.x / GridContentWidth) * GridContentWidth;
        if ((scrollView.contentSize.width - point.x - GridTitleContentWidth) < ScreenWidth) {
            return;
        }
        [scrollView setContentOffset:point animated:true];
    }
}



// 4
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (self.scrollDirection == ScrollDirectionHorizontal) {
        CGPoint point = scrollView.contentOffset;
        point.x = round(point.x / GridContentWidth) * GridContentWidth;
        if ((scrollView.contentSize.width - point.x - GridTitleContentWidth) < ScreenWidth ) {
            return;
        }
        [scrollView setContentOffset:point animated:true];
    }
}

@end
