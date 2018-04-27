//
//  JZGridViewModel.h
//  iPhoneStock
//
//  Created by JZTech-xuz on 2017/3/31.
//  Copyright © 2017年 com.jingzhuan. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface JZGridViewModel : NSObject

@property (nonatomic,copy) NSString *title;

@property (nonatomic,copy) NSString *detailTitle;

@property (nonatomic,assign) CGSize cellSize;
//
@property (nonatomic,assign) BOOL isShowArrow;
//
@property (nonatomic,assign) BOOL isShowR;

@property (nonatomic,assign) BOOL upArrow;

@property (nonatomic,strong) UIColor *backgroudColor;

@property (nonatomic,strong) UIColor *titleColor;

@property (nonatomic,copy) NSString *code;

@property (nonatomic,assign) BOOL canPull;

@property (nonatomic,copy) NSString *name;

@property (nonatomic,strong) NSIndexPath *indexPath;
// 子类VM持有的数据源model
@property (nonatomic,strong) id model;

- (instancetype)initWithTitle:(NSString *)title detailTitle:(NSString *)detatilTitle titleColor:(UIColor *)titleColor cellSize:(CGSize )cellSize;

+ (instancetype)initWithTitle:(NSString *)title detailTitle:(NSString *)detatilTitle titleColor:(UIColor *)titleColor cellSize:(CGSize )cellSize;

- (instancetype)initWithName:(NSString *)name code:(NSString *)code cellSize:(CGSize)cellSize pull:(BOOL)pull;




@end
