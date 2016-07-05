//
//  MobileNumberTool.h
//  SalesAssistantApp
//
//  Created by 葱泥 on 14-9-3.
//  Copyright (c) 2014年 好居. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 *  号码处理类
 *  1、号码格式化
 *  2、判断号码是否有效
 *  3、号码全数字化
 *  4、是否支持打电话发短信
 */

@interface MobileNumberTool : NSObject

/**
 *  号码格式化  包括手机号码、电话号码
 *
 *  @param number 号码  字符串
 *
 *  @return 格式化后的字符串
 */
+ (NSString *)formateAllNumber:(NSString *)number;

/**
 *  判断是否有效
 *
 *  @param number 号码字符串
 *
 *  @return YES/NO
 */
+ (BOOL)judgeModeAndValid:(NSString *)number;

/**
 *  全数字电话  返回是11位的电话数字
 *
 *  @param mobile 电话号码
 *
 *  @return 返回是11位的电话数字  完整的电话数字
 */
+ (NSString *)mobilePhoneWithNumber:(NSString *)mobile;

/**
 *  动态格式化手机格式
 *
 *  @param textFieldText 文本输入的完整字符
 *
 *  @return NSString
 */
+ (NSString *)dynamicFormatPhoneNumber:(NSString *)textFieldText;

/**
 *  提出号码中的多余元素 比如-、空格、17951等
 *
 *  @param mobile 号码
 *
 *  @return 完整的号码格式
 */
+ (NSMutableString *)mobileSort:(NSString *)mobile;

/**
 *  是否支持打电话发短信
 */
+ (BOOL)isCanCallPhone;

/**
 *  self
 *
 *  @return self
 */
+ (id)instance;

@end
