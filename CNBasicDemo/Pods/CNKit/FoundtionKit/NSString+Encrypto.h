//
//  NSString+Encrypto.h
//  MakeupLessons
//
//  Created by 汪君 on 16/6/29.
//  Copyright © 2016年 quanXiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Encrypto)

/**
 *  sha1加密
 *
 *  @return sha1加密
 */
- (NSString *)sha1Encryp;

/**
 *  md5加密
 *
 *  @return md5加密
 */
- (NSString *)md5Encryp;

// 以后加上
//- (NSString *)sha1_base64Encryp;
//- (NSString *)md5_base64Encryp;
//- (NSString *)base64;

@end
