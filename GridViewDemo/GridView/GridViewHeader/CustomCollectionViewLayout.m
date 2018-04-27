//
//  CustomCollectionViewLayout.m
//  iPhoneStock
//
//  Created by JZTech-xuz on 2017/3/30.
//  Copyright © 2017年 com.jingzhuan. All rights reserved.
//
#import "MJRefresh.h"
#import "JZDecorationLineView.h"
#import "CustomCollectionViewLayout.h"

@interface CustomCollectionViewLayout ()
@property (nonatomic,strong) NSMutableArray *itemAttributes;
@property (nonatomic,assign) CGSize contentSize;
@property (nonatomic,strong) NSMutableDictionary *itemSizeMap;
@end

@implementation CustomCollectionViewLayout

- (NSMutableArray *)itemAttributes{
    if (!_itemAttributes) {
        _itemAttributes = [NSMutableArray array];
    }
    return _itemAttributes;
}

- (void)prepareLayout{
    [super prepareLayout];
    NSInteger sections = [self.collectionView numberOfSections];
    if (sections == 0) {
        return;
    }
    
    // 由于之前已经存入数组，下面只需每次滑动调用该方法使 第一行和第一列跟随collectionView滑动更新originY 和 originX
    if (self.itemAttributes.count == 0) {
        [self setItemAttributes];
        
    }else{
        if (sections != self.itemAttributes.count || self.invalidLayout) {
            [self setItemAttributes];
        }else{
            [self updateOffset];
        }
    }

}

//- (UICollectionViewLayoutAttributes *)initialLayoutAttributesForAppearingItemAtIndexPath:(NSIndexPath *)itemIndexPath{
//    return self.itemAttributes[itemIndexPath.section][itemIndexPath.row];
//}
//
//- (UICollectionViewLayoutAttributes *)finalLayoutAttributesForDisappearingItemAtIndexPath:(NSIndexPath *)itemIndexPath{
//    return self.itemAttributes[itemIndexPath.section][itemIndexPath.row];
//}


// 使用缓存 更新offset
- (void)updateOffset{
    NSInteger sections = [self.collectionView numberOfSections];
    if (self.collectionView.mj_header && self.collectionView.contentOffset.y < 0) {
        for (int section = 0; section < sections; section++) {
            NSInteger rows = [self.collectionView numberOfItemsInSection:section];
            for (int row = 0; row < rows; row++) {
                UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForRow:row inSection:section]];
                // 修复有header时，下拉过快导致固定的section偏移BUG
                if (section <= self.fixedSection) {
                    for (NSInteger i = 0; i <= self.fixedSection; i++) {
                        CGRect frame = attributes.frame;
                        frame.origin.y = 0;
                        if (section > 0) {
                            for (int j = 0; j < section; j++) {
                                NSValue *sizeValue = self.itemSizeMap[[NSIndexPath indexPathForRow:row inSection:j]];
                                CGSize itemSize = sizeValue.CGSizeValue;
                                frame.origin.y += itemSize.height;
                            }
                        }
                        attributes.frame = frame;
                    }
                }
                
            }
        }
        return;
    }
    NSInteger isKline = 0;
    for (int section = 0; section < sections; section++) {
        NSInteger rows = [self.collectionView numberOfItemsInSection:section];
        NSIndexPath *arrowIndex ;
        if (self.arrowIndexPaths.count && section > 0) {
            NSInteger index = isKline > 0 ? section - 2 : section - 1;
            // 判断分时图
            if (rows > 1) {
                if (index < self.arrowIndexPaths.count) {
                    arrowIndex = self.arrowIndexPaths[index];
                }
            }else{
                isKline = 1;
            }
        }
        for (int row = 0; row < rows; row++) {
            NSArray *sectionAttributes = self.itemAttributes[section];
            if (rows > sectionAttributes.count) {
                // 校验 不合重新reset
                [self setItemAttributes];
                return;
            }
            BOOL isArrowRow = arrowIndex && row == arrowIndex.row;
            UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForRow:row inSection:section]];
            
            // 加入可设置的固定section 如果只固定section0,就不需要循环
            if (section <= self.fixedSection) {
                for (NSInteger i = 0; i <= self.fixedSection; i++) {
                    CGRect frame = attributes.frame;
                    frame.origin.y = self.collectionView.contentOffset.y;
                    if (section > 0) {
                        for (int j = 0; j < section; j++) {
                            NSValue *sizeValue = self.itemSizeMap[[NSIndexPath indexPathForRow:row inSection:j]];
                            CGSize itemSize = sizeValue.CGSizeValue;
                            frame.origin.y += itemSize.height;
                        }
                    }
                    attributes.frame = frame;
                }
            }
            if (row == 0) {
                CGRect frame = attributes.frame;
                frame.origin.x = self.collectionView.contentOffset.x;
                attributes.frame = frame;
            }
            if (isArrowRow) {
                CGRect frame = attributes.frame;
                frame.origin.x = self.collectionView.contentOffset.x+(ScreenWidth-frame.size.width)/2.0;
                attributes.frame = frame;
            }
            continue;
        }
    }
}

// 第一次布局 初始化
- (void)setItemAttributes{
    [self.itemAttributes removeAllObjects];
    self.itemSizeMap = @{}.mutableCopy;
    NSInteger column = 0;
    CGFloat xOffset = 0;
    CGFloat yOffset = 0;
    CGFloat contentWidth = 0;
    CGFloat contentHeight = 0;
    NSInteger sections = [self.collectionView numberOfSections];
    NSInteger isKline = 0;
    for (int section = 0; section < sections; section++) {
        NSMutableArray *sectionAttributes = @[].mutableCopy;
        NSInteger rows = [self.collectionView numberOfItemsInSection:section];
        NSIndexPath *arrowIndex ;
        if (self.arrowIndexPaths.count && section > 0) {
            NSInteger index = isKline > 0 ? section - 2 : section - 1;
            // 判断分时图
            if (rows > 1) {
                if (index < self.arrowIndexPaths.count) {
                    arrowIndex = self.arrowIndexPaths[index];
                }
            }else{
                isKline = 1;
            }
        }
        for (int row = 0; row < rows; row++) {
            CGSize itemSize = [self.delegate sizeForItemAtIndexPath:[NSIndexPath indexPathForRow:row inSection:section]];
            [self.itemSizeMap setObject:[NSValue valueWithCGSize:itemSize] forKey:[NSIndexPath indexPathForRow:row inSection:section]];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
            UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
            // 设置cell frame
            BOOL isArrowRow = arrowIndex && row == arrowIndex.row;
            
            if (isArrowRow) {
                CGSize lastItemSize = [self.itemSizeMap[[NSIndexPath indexPathForRow:row-1 inSection:section]] CGSizeValue];
                attributes.frame = CGRectIntegral(CGRectMake((ScreenWidth-itemSize.width)/2.0+self.collectionView.contentOffset.x, yOffset+lastItemSize.height-itemSize.height-4, itemSize.width, itemSize.height));
                attributes.zIndex = 1022;
            }else{
                attributes.frame = CGRectIntegral(CGRectMake(xOffset, yOffset, itemSize.width, itemSize.height));
            }
            if (row == 0) {
                attributes.zIndex = 1022;
            }
            if (section <= self.fixedSection) {
                for (NSInteger i = 0; i <= self.fixedSection; i++) {
                    if (section == i){
                        attributes.zIndex = 1023;
                        if (section == i && row == 0) {
                            attributes.zIndex = 1024;
                        }
                    }
                }
            }
            
            if (section <= self.fixedSection) {
                for (NSInteger i = 0; i <= self.fixedSection; i++) {
                    CGRect frame = attributes.frame;
                    frame.origin.y = self.collectionView.contentOffset.y;
                    if (section > 0) {
                        for (int j = 0; j < section; j++) {
                            NSValue *sizeValue = self.itemSizeMap[[NSIndexPath indexPathForRow:row inSection:j]];
                            CGSize itemSize = sizeValue.CGSizeValue;
                            frame.origin.y += itemSize.height;
                        }
                    }
                    attributes.frame = frame;
                }
            }
            if (row == 0) {
                CGRect frame = attributes.frame;
                frame.origin.x = self.collectionView.contentOffset.x;
                attributes.frame = frame;
            }
            [sectionAttributes addObject:attributes];
            
            // xOffset 按列增加width
            if (!isArrowRow) {
               xOffset = xOffset + itemSize.width;
            }
        
            // 递增列
            column++;
            // 最后一列 准备换行， 重置列数
            if (column == rows) {
                if (xOffset > contentWidth) {
                    contentWidth = xOffset;
                }
                column = 0;
                xOffset = 0;
                // 换行增加yOffset
                yOffset += itemSize.height;
            }
        }
        [self.itemAttributes addObject:sectionAttributes];
    }
    
    UICollectionViewLayoutAttributes *attributes = [[self.itemAttributes lastObject] lastObject];
    contentHeight = attributes.frame.origin.y + attributes.frame.size.height;
    self.contentSize = CGSizeMake(contentWidth, contentHeight);
}

//- (UICollectionViewLayoutAttributes *)layoutAttributesForDecorationViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath{
//    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForDecorationViewOfKind:NSStringFromClass([JZDecorationLineView class]) withIndexPath:indexPath];
//    attributes.zIndex = -1;
//    return attributes;
//}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    NSMutableArray *attributes = @[].mutableCopy;
    for (NSArray *section in self.itemAttributes) {
        [attributes addObjectsFromArray:[section filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(UICollectionViewLayoutAttributes *evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
            // 返回两个矩形 是否 交集
            return CGRectIntersectsRect(rect, [evaluatedObject frame]);
        }]]];
    }
//    [self.itemAttributes enumerateObjectsUsingBlock:^(NSArray *section, NSUInteger i, BOOL * _Nonnull stop) {
//        [section enumerateObjectsUsingBlock:^(UICollectionViewLayoutAttributes *cellAttributes , NSUInteger j, BOOL * _Nonnull stop) {
//            if (j == 1 && i > 0) {
//                 UICollectionViewLayoutAttributes *decorationAttri = [self layoutAttributesForDecorationViewOfKind:NSStringFromClass([JZDecorationLineView class]) atIndexPath:[NSIndexPath indexPathForRow:j inSection:i]];
//                CGRect rect = cellAttributes.frame;
//                decorationAttri.frame = CGRectMake(0, CGRectGetMaxY(rect)-1, ScreenWidth, 1);
//                [attributes addObject:decorationAttri];
//                *stop = YES;
//            }
//        }];
//    }];

    return attributes;
}

// 根据indexPath 返回每个cell 对应的 attribute
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    return self.itemAttributes[indexPath.section][indexPath.row];
}

- (CGSize)collectionViewContentSize{
    return self.contentSize;
}

// 只有YES 才会每次改变bounds时 重新调用prepateLayout 更新保证第一行和第一列置顶
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds{
    return YES;
}

@end
