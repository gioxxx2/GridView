//
//  JZGridViewModel.m
//  iPhoneStock
//
//  Created by JZTech-xuz on 2017/3/31.
//  Copyright © 2017年 com.jingzhuan. All rights reserved.
//

#import "JZGridViewModel.h"
#define HexRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define AppGray HexRGB(0x818EA5)
@implementation JZGridViewModel


+ (instancetype)initWithTitle:(NSString *)title detailTitle:(NSString *)detatilTitle titleColor:(UIColor *)titleColor cellSize:(CGSize )cellSize{
    return [[self alloc]initWithTitle:title detailTitle:detatilTitle titleColor:titleColor cellSize:cellSize];
}

- (instancetype)initWithTitle:(NSString *)title detailTitle:(NSString *)detatilTitle titleColor:(UIColor *)titleColor cellSize:(CGSize )cellSize{
    if ([super init]) {
        _title = title ? title : @"--";
        _detailTitle = detatilTitle ? detatilTitle : @"--";
        _titleColor = title ? titleColor : AppGray;
        _cellSize = cellSize;
    }
    return self;
}

- (instancetype)initWithName:(NSString *)name code:(NSString *)code cellSize:(CGSize)cellSize pull:(BOOL)pull{
    if ([super init]) {
        _name = [name copy];
        _canPull = pull;
        _cellSize = cellSize;
        _code = [code copy];
    }
    return self;
}



@end
