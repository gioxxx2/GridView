//
//  JZGirdViewDataSource.h
//  iPhoneStock
//
//  Created by JZTech-xuz on 2018/4/23.
//  Copyright © 2018年 com.jingzhuan. All rights reserved.
//

#import <Foundation/Foundation.h>
@class JZGridViewModel;
@protocol JZGridViewDataSource <NSObject>


- (CGSize)sizeForItemAtIndexPath:(NSIndexPath *)indexPath;

- (NSInteger)numberOfSections;

- (NSInteger)numberOfItemsInSection:(NSInteger)section;

- (__kindof UICollectionViewCell *)cellForItemAtIndexPath:(NSIndexPath *)indexPath collectionView:(UICollectionView *)collectionView;

- (void)registCellClassInCollectionView:(UICollectionView *)collectionView;


@optional



@end
