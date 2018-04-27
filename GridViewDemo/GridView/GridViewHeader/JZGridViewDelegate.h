//
//  JZGridViewDelegate.h
//  iPhoneStock
//
//  Created by JZTech-xuz on 2018/4/23.
//  Copyright © 2018年 com.jingzhuan. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSUInteger, ScrollDirection) {
    ScrollDirectionNone,
    ScrollDirectionVertical,
    ScrollDirectionHorizontal,
};
@class JZGridView;
@protocol JZGridViewDelegate <NSObject>

@optional

- (void)gridViewDidScroll:(UIScrollView *)scrollView;

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView scrollDirection:(ScrollDirection)scrollDirection;

- (void)gridView:(JZGridView *)gridView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;

@end
