//
//  MobileNumberTool.m
//  SalesAssistantApp
//
//  Created by 葱泥 on 14-9-3.
//  Copyright (c) 2014年 好居. All rights reserved.
//

#import "MobileNumberTool.h"
#import <CNKit/CNKit.h>


static MobileNumberTool *share = nil;
@implementation MobileNumberTool


#pragma mark 根据传入号码格式，判断号码格式是否正确
+ (BOOL)judgeModeAndValid:(NSString *)number {
    if ([number hasPrefix:@"0"] || [number hasPrefix:@"85"]) {
        //含3、4位区号
        NSString * cm = @"^0(10|2[0-5789]|[3-9]\\d{2})\\d{7,8}$";
        //香港、澳门
        NSString * ct = @"^8(5[2-3])\\d{7,8}$";
        
        NSPredicate *regextestCM = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", cm];
        NSPredicate *regextestCH = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", ct];
        
        if (([regextestCM evaluateWithObject:number] == YES)
            || ([regextestCH evaluateWithObject:number] == YES)){
            return YES;
        }
    } else if ([number hasPrefix:@"1"]) {
        BOOL result = [MobileNumberTool validateMobile:number];
        return result;
    }
    
    return NO;
}

#pragma mark 根据传入号码格式，判断使用那种格式化方案
+ (NSString *)formateAllNumber:(NSString *)number {
    NSString *newNumber_Str = [self mobileSort:number];
    NSString *formatMobile = nil;

    if (number.length <= 1) {
        return @"";
    }
    
    if (number.length <= 5) {
        return number;
    }
    
    if ([newNumber_Str hasPrefix:@"0"] || [newNumber_Str hasPrefix:@"85"]) {
        formatMobile = [MobileNumberTool telNumberFormat:newNumber_Str];
    } else if ([newNumber_Str hasPrefix:@"1"]) {
        formatMobile = [MobileNumberTool mobilePhoneNumberFormat:newNumber_Str];
    } else {
        formatMobile = newNumber_Str;
    }
    
    return formatMobile;
}

#pragma mark 固话号码格式化 344 443 444  有空格
+ (NSString *)telNumberFormat:(NSString *)tel {
    NSString *formatMobile = nil;
    NSMutableString *originalMobile = [self mobileSort:tel];
    
    //含3位区号
    NSString * cm = @"^0(10|2[0-5789])\\d{7,8}$";
    //含4位区号
    NSString * cn = @"^0([3-9]\\d{2})\\d{7,8}$";
    //香港、澳门
    NSString * ct = @"^8(5[2-3])\\d{7,8}$";
    
    NSPredicate *regextestCM = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", cm];
    NSPredicate *regextestCN = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", cn];
    NSPredicate *regextestCT = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", ct];
    
    if (([regextestCM evaluateWithObject:tel] == YES)
        || ([regextestCN evaluateWithObject:tel] == YES)
        || ([regextestCT evaluateWithObject:tel] == YES)){
        int pre_Int = 4;
        
        if (([regextestCM evaluateWithObject:tel] == YES)
            || ([regextestCT evaluateWithObject:tel] == YES)) {
            pre_Int = 3;
        }
        
        NSString *pre_str = [originalMobile substringToIndex:pre_Int];
        NSString *last_str = [originalMobile substringFromIndex:pre_Int + 1];
        
        formatMobile = [NSString stringWithFormat:@"%@ %@ %@",pre_str,[last_str substringToIndex:4],[last_str substringFromIndex:5]];
    } else {
        if (tel.length == 7 || tel.length == 8 ) {
            formatMobile = [NSString stringWithFormat:@"%@ %@",[originalMobile substringToIndex:4],[originalMobile substringFromIndex:5]];
        } else{
            formatMobile =tel;
        }
    }
    return formatMobile;
}

#pragma mark 全数字电话  返回是11位的电话数字
+ (NSString *)mobilePhoneWithNumber:(NSString *)mobile {
    NSString *formatMobile;
    NSMutableString *originalMobile = [self mobileSort:mobile];
    
    if ([originalMobile hasPrefix:@"0"]) {
        formatMobile = [NSString stringWithFormat:@"%@%@",[originalMobile substringToIndex:4],[originalMobile substringFromIndex:4]];
    } else {
        if (originalMobile.length > 10) {
            formatMobile = [NSString stringWithFormat:@"%@%@%@",[originalMobile substringToIndex:3],[originalMobile substringWithRange:NSMakeRange(3, 4)],[originalMobile substringFromIndex:7]];
        } else {
            formatMobile = [NSString stringWithFormat:@"%@",originalMobile];
        }
    }
    
    return formatMobile;
}

#pragma mark 手机号码格式化  334
+ (NSString *)mobilePhoneNumberFormat:(NSString *)mobile {
    NSString *formatMobile;
    NSMutableString *originalMobile = [self mobileSort:mobile];
    BOOL isValidateMobile = [MobileNumberTool validateMobile:originalMobile];

    if (isValidateMobile) {
        if (originalMobile.length >= 11) {
            formatMobile = [NSString stringWithFormat:@"%@ %@ %@",[originalMobile substringToIndex:3],[originalMobile substringWithRange:NSMakeRange(3, 4)],[originalMobile substringFromIndex:7]];
        } else {
            formatMobile = [NSString stringWithFormat:@"%@",originalMobile];
        }
    } else {
        formatMobile = [NSString stringWithFormat:@"%@",originalMobile];
    }
    
    return formatMobile;
}

#pragma mark 号码梳理
+ (NSMutableString *)mobileSort:(NSString *)mobile {
    NSMutableString *originalMobile = [[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"%@",mobile]];
    //去除  没有用的字符
    NSRange range = [originalMobile rangeOfString:@"+86"];
    if (range.location != NSNotFound) {
        [originalMobile deleteCharactersInRange:[originalMobile rangeOfString:@"+86"]];
    }
    
    if ([originalMobile hasPrefix:@"17951"]) {
        [originalMobile deleteCharactersInRange:[originalMobile rangeOfString:@"17951"]];
    }
    
    if ([originalMobile hasPrefix:@"12593"]) {
        [originalMobile deleteCharactersInRange:[originalMobile rangeOfString:@"12593"]];
    }
    
    NSUInteger length = originalMobile.length;
    
    for (int i = 0; i < length; i++) {
        NSString *str = @" ";
        NSRange range = [originalMobile rangeOfString:str];
        
        if (range.location != NSNotFound) {
            [originalMobile deleteCharactersInRange:[originalMobile rangeOfString:str]];
        }
        
        NSString *str2 = @"-";
        NSRange range2 = [originalMobile rangeOfString:str2];
        
        if (range2.location != NSNotFound) {
            [originalMobile deleteCharactersInRange:[originalMobile rangeOfString:str2]];
        }
    }
    
    return originalMobile;
}

#pragma mark 动态格式化手机格式
+ (NSString *)dynamicFormatPhoneNumber:(NSString *)textFieldText {
    NSString *newString = @"";
    
    if ([textFieldText hasPrefix:@"0"] || [textFieldText hasPrefix:@"85"]) {
        if (textFieldText.length > 3) {
            int index = 4;
            
            if ([textFieldText hasPrefix:@"01"] || [textFieldText hasPrefix:@"02"] || [textFieldText hasPrefix:@"85"]) {
                index = 3;
            }
            
            NSString *subString = [textFieldText substringToIndex:index];
            NSString *last_Str = [textFieldText substringFromIndex:index];
            
            newString = [NSString stringWithFormat:@"%@ %@",subString,[last_Str insertStr:@" " cutCount:4]];
        } else {
            newString = textFieldText;
        }
    } else if ([textFieldText hasPrefix:@"1"]) {
        if (textFieldText.length > 3) {
            NSString *subString = [textFieldText substringToIndex:3];
            NSString *last_Str = [textFieldText substringFromIndex:3];
            
            newString = [NSString stringWithFormat:@"%@ %@",subString,[last_Str insertStr:@" " cutCount:4]];
        } else {
            newString = textFieldText;
        }
    } else {
        newString = [textFieldText insertStr:@" " cutCount:4];
    }
    
    return newString;
}

#pragma mark 检测手机号是否正确
+ (BOOL)validateMobile:(NSString *)mobileNum {
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[2378])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189
     22         */
    NSString * CT = @"^1((33|53|8[0-9]|7[0-9])[0-9]|349)\\d{7}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES)) {
        return YES;
    } else {
        return NO;
    }
}

#pragma mark 是否支持打电话发短信
+ (BOOL)isCanCallPhone{
    BOOL isCall = YES;
    NSString *deviceType = [UIDevice currentDevice].model;
    
    if([deviceType  isEqualToString:@"iPod touch"]||[deviceType  isEqualToString:@"iPad"]||[deviceType  isEqualToString:@"iPhone Simulator"]) {
        isCall = NO;
    }
    
    return isCall;
}

#pragma mark self
+(id)instance {
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        if (share==nil) {
            share = [[super alloc] init];
        }
    });
    
    return share;
}
@end
