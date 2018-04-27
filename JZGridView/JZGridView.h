//
//  JZGridView.h
//  iPhoneStock
//
//  Created by JZTech-xuz on 2018/4/21.
//  Copyright © 2018年 com.jingzhuan. All rights reserved.
//
#import <MJRefresh/MJRefresh.h>
#import "JZGridViewDelegate.h"
#import "JZGridViewDataSource.h"
#import <UIKit/UIKit.h>


@interface JZGridView : UIView

@property (nonatomic,weak) id<JZGridViewDataSource> dataSource;

@property (nonatomic,weak) id<JZGridViewDelegate> delegate;

@property (nonatomic,assign,readonly) ScrollDirection  scrollDirection;

@property (nonatomic,assign) CGPoint contentOffset;

@property (nonatomic,assign) UIEdgeInsets contentInset;

@property (nonatomic,assign) UIEdgeInsets scrollIndicatorInsets;

@property (nonatomic,strong) MJRefreshFooter *gridFooter;

@property (nonatomic,strong) MJRefreshHeader *gridHeader;

- (void)setContentOffset:(CGPoint)offset animated:(BOOL)animated;

- (void)setLayoutArrowIndexPaths:(NSArray <NSIndexPath *>*)indexPaths;

- (void)setLayoutFixSection:(NSInteger)fixSection;

- (void)setLayoutUpdate:(BOOL)update;

- (void)reloadData;

- (void)reloadSections:(NSIndexSet *)sections;

- (void)performBatchUpdates:(void(^)(void))update completion:(void(^)(BOOL finished))completion;

- (void)insertSections:(NSIndexSet *)sections;

- (void)deleteSections:(NSIndexSet *)sections;

- (UICollectionViewCell *)cellForItemAtIndexPath:(NSIndexPath *)indexPath;

- (NSInteger)numberOfSections;

@end
