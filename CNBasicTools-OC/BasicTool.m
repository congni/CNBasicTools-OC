//
//  BasicTool.m
//  DemoTest
//
//  Created by allenmedia on 14-2-10.
//  Copyright (c) 2014年 luo. All rights reserved.
//

#import "BasicTool.h"
#import <SystemConfiguration/SystemConfiguration.h>
#import <CNKit/CNKit.h>


static BasicTool *sharedTool = nil;


@implementation BasicTool

#pragma mark 金额格式化
+ (NSString *)moneyFormant:(NSString *)money {
    //查找然后将其删除
    NSRange range = [money rangeOfString:@"."];
    
    NSString *needFormant = money;
    NSString *lastStr = nil;
    
    if (range.location != NSNotFound){
        needFormant = [money substringToIndex:range.location];
        lastStr = [money substringFromIndex:range.location + range.length];
    }
    
    NSMutableString *moneyFormant_MulString = [[NSMutableString alloc] initWithString:needFormant];
    NSUInteger moneyCount_int = moneyFormant_MulString.length;
    
    if (moneyCount_int > 3) {
        NSMutableString *newMoneyFormant_MulString = [[NSMutableString alloc] init];
        int m_int = 0;
        int newSy_int = newMoneyFormant_MulString.length % 3;
        for (NSUInteger i = moneyCount_int-1; i > 0; i--) {
            NSString *single_String = [moneyFormant_MulString substringWithRange:NSMakeRange(i, 1)];
            
            int ys_int = (newMoneyFormant_MulString.length - m_int) % 3;
            if (ys_int == 0) {
                
                if ( newSy_int == 0  && i == moneyCount_int-1) {
                    
                } else {
                    [newMoneyFormant_MulString insertString:@"," atIndex:0];
                    m_int++;
                }
            }
            
            [newMoneyFormant_MulString insertString:single_String atIndex:0];
            
        }
        moneyFormant_MulString = newMoneyFormant_MulString;
    }
    
    if (lastStr) {
        [moneyFormant_MulString appendString:[NSString stringWithFormat:@".%@",lastStr]];
    }
    
    return moneyFormant_MulString;
}

#pragma mark 获取完整的deviceToken  去除<>、空格等
+ (NSString *)deviceTokenSortBy:(NSString *)uuid {
    NSMutableString *deviceToken_Str = [[NSMutableString alloc] initWithString:uuid];
    NSUInteger length = deviceToken_Str.length;
    NSArray *deleteArr = [[NSArray alloc] initWithObjects:@"-",@"<",@">",@" ", nil];
    NSUInteger deleteCount = [deleteArr count];
    
    for (int i = 0; i < deleteCount; i++) {
        NSString *str = [NSString stringWithFormat:@"%@",[deleteArr objectAtIndex:i]];
        
        for (int j = 0; j < length; j++) {
            NSRange range = [deviceToken_Str rangeOfString:str];
            
            if (range.location != NSNotFound) {
                [deviceToken_Str deleteCharactersInRange:[deviceToken_Str rangeOfString:str]];
            }
        }
    }
    
    return deviceToken_Str;
}

#pragma mark 判断当前系统
+ (BOOL)ISIOS7Version {
    return ([[UIDevice currentDevice].systemVersion doubleValue]>6&&[[UIDevice currentDevice].systemVersion doubleValue]<7)?NO:YES;
}

#pragma mark  获取屏幕尺寸
+ (CGRect)returnAppFrame {
    CGRect r = [ UIScreen mainScreen ].bounds;
    return r;
}

#pragma mark 颜色转Image
+ (UIImage*)createImageWithColor: (UIColor*) color {
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return theImage;
}

+ (id)instance {
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        if (sharedTool==nil)
        {
            sharedTool = [[super alloc] init];
        }
    });
    
    return sharedTool;
}

@end
