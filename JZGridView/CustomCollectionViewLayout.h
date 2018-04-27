//
//  CustomCollectionViewLayout.h
//  iPhoneStock
//
//  Created by JZTech-xuz on 2017/3/30.
//  Copyright © 2017年 com.jingzhuan. All rights reserved.
//
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
#import <UIKit/UIKit.h>

@protocol customCollectionViewLayoutDelegate <NSObject>

- (CGSize)sizeForItemAtIndexPath:(NSIndexPath *)indexPath;



@end

@interface CustomCollectionViewLayout : UICollectionViewLayout

@property (nonatomic,assign) id<customCollectionViewLayoutDelegate> delegate;

// 设置固定section
@property (nonatomic,assign) NSInteger fixedSection;

//@property (nonatomic,assign) NSInteger row0Zindex;

//@property (nonatomic,assign) BOOL isSelectStock;
@property (nonatomic,assign) BOOL invalidLayout;

@property (nonatomic,strong) NSMutableArray *arrowIndexPaths;


@end
