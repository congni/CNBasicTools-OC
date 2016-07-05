//
//  DataStoreTool.m
//
//
//  Created by haoju-congni on 15/1/12.
//  Copyright (c) 2015年 好居. All rights reserved.
//

#import "DataStoreTool.h"
#import <CNKit/CNKit.h>


@implementation DataStoreTool


static DataStoreTool *sharedTool = nil;
static NSUserDefaults *userDefaults = nil;
static NSMutableDictionary *staticMulDictionary;

#pragma mark 静态临时存储数据
-(void)didSaveStaicDataWithKey:(NSString *)key value:(id)valueID {
    if (staticMulDictionary==Nil) {
        staticMulDictionary = [[NSMutableDictionary alloc] init];
    }
    
    if (key && valueID) {
        [staticMulDictionary setObject:valueID forKey:key];
    }
}

#pragma mark 获取临时存储数据  如果key为nil则自定不查询  如果没有则返回nil
- (id)didGetStaticDataForKey:(NSString *)key {
    if (key) {
        NSString *valueStr = [staticMulDictionary objectForKey:key];
        return valueStr;
    }
    
    return nil;
}

#pragma mark  根据key检查是否存在对应的数据  传入的key为nil  则返回nil
- (BOOL)CheckStaticCahceForKey:(NSString *)key {
    if (key) {
        NSArray *allKeyArray = [[NSArray alloc] initWithArray:[staticMulDictionary allKeys]];
        
        if ([allKeyArray containsObject:key]) {
            return YES;
        }
    }
    
    return NO;
}

#pragma mark 静态数据 删除
- (void)didRemoveStaticDataForKey:(NSString *)key {
    if (key && [self CheckStaticCahceForKey:key]) {
        [staticMulDictionary removeObjectForKey:key];
    }
}

#pragma mark NSUserDefaults本地数据存储 key/value 为nil 则不存储
- (void)didSaveUserDefaultsDataWithKey:(NSString *)key value:(id)obj {
    if (key && obj) {
        [DataStoreTool initUserDefaults];
        [userDefaults setObject:obj forKey:key];
    }
}

#pragma mark NSUserDefaults本地数据获取 传入的key为nil  则返回nil
- (id)didGeteUserDefaultsDataWithKey:(NSString *)key {
    if (key) {
        [DataStoreTool initUserDefaults];
        id obj = [userDefaults objectForKey:key];
        
        return obj;
    }
    return nil;
}

#pragma mark NSUserDefaults 删除数据
- (void)didRemoveUserDefaultsDataWithKey:(NSString *)key {
    if (key && [self CheckUserDefaultDataWithKey:key]) {
        [DataStoreTool initUserDefaults];
        [userDefaults removeObjectForKey:key];
    }
}

#pragma mark 检查NSUserDefaults 是否有相关的值
- (BOOL)CheckUserDefaultDataWithKey:(NSString *)key {
    [DataStoreTool initUserDefaults];
    BOOL isHaveValue_Bool = NO;
    if (key && [userDefaults objectForKey:key]) {
        isHaveValue_Bool = YES;
    }
    return isHaveValue_Bool;
}

#pragma mark 将字典转成网络请求语句类型的字符串
+ (NSString *)ChangeDictToNetworkString:(NSMutableDictionary *)dict {
    if (dict) {
        NSArray *keyArray = [dict allKeys];
        NSUInteger count = [keyArray count];
        NSMutableString *addMulString = [[NSMutableString alloc] init];
        
        for (int i = 0; i < count; i++) {
            NSString *key_str = [keyArray objectAtIndex:i];
            NSString *value_str = [dict objectForKey:key_str];
            
            if ((i + 1) >= count) {
                NSString *dd = [NSString stringWithFormat:@"%@=%@",key_str,value_str];
                [addMulString appendString:dd];
            } else {
                NSString *dd = [NSString stringWithFormat:@"%@=%@&",key_str,value_str];
                [addMulString appendString:dd];
            }
        }
        
        return addMulString;
    }
    
    return nil;
}

#pragma mark 新增 将字典转成新增的sql语句类型的字符串
+ (NSString *)ChangeDictToSQLString:(NSMutableDictionary *)dict {
    if (dict) {
        NSString *str = [[NSString alloc] init];
        NSArray *key_arr = [dict allKeys];
        NSUInteger count = [key_arr count];
        NSMutableString *key_mut_str = [[NSMutableString alloc] init];
        NSMutableString *value_mut_str = [[NSMutableString alloc] init];
        
        for (int i = 0; i<count; i++) {
            NSString *key_str = [key_arr objectAtIndex:i];
            NSString *value_str = [dict objectForKey:key_str];
            
            if ((i + 1) >= count) {
                [key_mut_str appendString:key_str];
                [value_mut_str appendString:[NSString stringWithFormat:@"'%@'",value_str]];
            } else {
                [key_mut_str appendString:[NSString stringWithFormat:@"%@,",key_str]];
                [value_mut_str appendString:[NSString stringWithFormat:@"'%@',",value_str]];
            }
        }
        
        str = [NSString stringWithFormat:@"(%@) VALUES (%@)",key_mut_str,value_mut_str];
        
        return str;
    }
    return nil;
}

#pragma mark 删除 将字典转成删除的sql语句类型的字符串
+ (NSString *)DeleteDictToSQLString:(NSMutableDictionary *)dict {
    if (dict) {
        NSString *str = [[NSString alloc] init];
        NSArray *key_arr = [dict allKeys];
        NSUInteger count = [key_arr count];
        NSMutableString *addStr = [[NSMutableString alloc] init];
        
        for (int i = 0; i < count; i++) {
            NSString *key_str = [key_arr objectAtIndex:i];
            NSString *value_str = [dict objectForKey:key_str];
            
            if ((i + 1) >= count) {
                NSString *dd = [NSString stringWithFormat:@"%@ = '%@'",key_str,value_str];
                [addStr appendString:dd];
            } else {
                NSString *dd = [NSString stringWithFormat:@"%@ = '%@' AND ",key_str,value_str];
                [addStr appendString:dd];
            }
        }
        
        str = [NSString stringWithFormat:@"%@",addStr];
        
        return str;
    }
    return nil;
}

#pragma mark 更新 将字典转成更新的sql语句类型的字符串
+ (NSString *)UpdataDictToSQLString:(NSMutableDictionary *)dict {
    if (dict) {
        NSString *str = [[NSString alloc] init];
        NSArray *key_arr = [dict allKeys];
        NSUInteger count = [key_arr count];
        NSMutableString *addStr = [[NSMutableString alloc] init];
        
        for (int i = 0; i < count; i++) {
            NSString *key_str = [key_arr objectAtIndex:i];
            NSString *value_str = [dict objectForKey:key_str];
            
            if ((i + 1) >= count) {
                NSString *dd = [NSString stringWithFormat:@"%@ = '%@'",key_str,value_str];
                [addStr appendString:dd];
            } else {
                NSString *dd = [NSString stringWithFormat:@"%@ = '%@',",key_str,value_str];
                [addStr appendString:dd];
            }
        }
        
        str = [NSString stringWithFormat:@"%@",addStr];
        
        return str;
    }
    return nil;
}

#pragma mark 连表查询的sql语句类型的字符串
+ (NSString *)SelectConditionToSQLString:(NSMutableDictionary *)dict tableAs:(NSString *)str {
    if (dict) {
        NSString *whereSQL_str = [[NSString alloc] init];
        NSArray *key_arr = [dict allKeys];
        NSUInteger count = [key_arr count];
        NSMutableString *addStr = [[NSMutableString alloc] init];
        
        for (int i = 0; i < count; i++) {
            NSString *key_str = [key_arr objectAtIndex:i];
            NSString *value_str = [dict objectForKey:key_str];
            
            if (str) {
                if ((i + 1) >= count) {
                    NSString *dd = [NSString stringWithFormat:@"%@.%@ = '%@'",str,key_str,value_str];
                    [addStr appendString:dd];
                } else {
                    NSString *dd = [NSString stringWithFormat:@"%@.%@ = '%@' AND ",str,key_str,value_str];
                    [addStr appendString:dd];
                }
            } else {
                if ((i + 1) >= count) {
                    NSString *dd = [NSString stringWithFormat:@"%@ = '%@'",key_str,value_str];
                    [addStr appendString:dd];
                } else {
                    NSString *dd = [NSString stringWithFormat:@"%@ = '%@' AND ",key_str,value_str];
                    [addStr appendString:dd];
                }
            }
            
        }
        
        whereSQL_str = [NSString stringWithFormat:@"%@",addStr];
        
        return whereSQL_str;
    }
    return nil;
}

#pragma mark 根据key值获取plist里面对应的数据 如果key为nil则返回nil  如果key值在plist不存在也返回nil
+ (id)didGetPlistDataWithKey:(NSString *)key plist:(NSString *)plistName {
    if (key) {
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:plistName ofType:@"plist"];
        NSDictionary *plist_Dict = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
        if (plist_Dict) {
            if ([[plist_Dict allKeys] containsObject:key]) {
                id valueForKey_Id = [plist_Dict objectForKey:key];
                return valueForKey_Id;
            }
        }
    }
    
    return nil;
}

#pragma mark NSUserDefaults一次初始化
+ (void)initUserDefaults {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        @autoreleasepool {
            if (userDefaults == nil) {
                userDefaults =[NSUserDefaults standardUserDefaults];
            }
        }
    });
}

#pragma mark 自己
+(id)instance {
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        if (sharedTool==nil) {
            sharedTool = [[super alloc] init];
        }
    });
    
    return sharedTool;
}

@end
