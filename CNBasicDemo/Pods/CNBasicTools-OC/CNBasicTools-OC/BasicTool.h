//
//  BasicTool.h
//  DemoTest
//
//  Created by 葱泥 on 15-2-10.
//  Copyright (c) 2014年 葱泥. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface BasicTool : NSObject


+ (id)instance;

/**
 *  获取完整的deviceToken  去除<>、空格等
 *
 *  @param uuid 原始UUID
 *
 *  @return NSString
 */
+ (NSString *)deviceTokenSortBy:(NSString *)uuid;

/**
 *  获取屏幕尺寸
 *
 *  @return CGRect
 */
+ (CGRect)returnAppFrame;

/**
 *  金额格式化
 *
 *  @param money 需要格式化的金额数据
 *
 *  @return 返回字符串形式的新的格式化后的数据
 */
+ (NSString *)moneyFormant:(NSString *)money;

/**
 *  颜色转Image
 *
 *  @param color 颜色
 *
 *  @return UIImage
 */
+ (UIImage *)createImageWithColor:(UIColor*)color;

/**
 *  禁用系统休眠
    [UIApplication sharedApplication].idleTimeDisabled = YES
 */
+ (BOOL)ISIOS7Version;

@end
