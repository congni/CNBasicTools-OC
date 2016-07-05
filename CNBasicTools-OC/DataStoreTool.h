//
//  DataStoreTool.h
//  sales_monitors
//
//  Created by 葱泥 on 15/1/12.
//  Copyright (c) 2015年 葱泥. All rights reserved.
//

/**
 *  数据处理类：
 *  1. 临时数据存储
 *  2。临时数据获取
 *  3. 检查数据有否有临时数据
 *  4. 数据操作 包括读取和设置
 *  5. NSUserDefaults 数据存储
 *  6. NSUserDefaults 数据读取
 *  7. plist文件 数据读取
 *  8. dict字典转sql语句的条件语句，包括查询、新增、删除、更新，查询支持连表查询带表别名
 */

#import <Foundation/Foundation.h>

@interface DataStoreTool : NSObject

/**
 *  临时数据存储  如果key/value 任意一个为nil则自动不存储
 *
 *  @param key     存储数据的key值
 *  @param valueID 要存储的数据
 */
- (void)didSaveStaicDataWithKey:(NSString *)key value:(id)valueID;

/**
 *  获取临时存储数据  如果key为nil则自定不查询  如果没有则返回nil
 *
 *  @param key 获取数据的key值
 *
 *  @return 返回存储的数据
 */
- (id)didGetStaticDataForKey:(NSString *)key;

/**
 *  静态数据 删除
 *
 *  @param key key值 如果key为nil则自定不操作
 */
- (void)didRemoveStaticDataForKey:(NSString *)key;

/**
 *  根据key检查是否存在对应的数据  传入的key为nil  则返回nil
 *
 *  @param key key值
 *
 *  @return YES/NO
 */
- (BOOL)CheckStaticCahceForKey:(NSString *)key;

/**
 *  NSUserDefaults本地数据存储 key/value 为nil 则不存储
 *
 *  @param key key值
 *  @param value value值
 */
- (void)didSaveUserDefaultsDataWithKey:(NSString *)key value:(id)obj;

/**
 *  NSUserDefaults本地数据获取 传入的key为nil  则返回nil
 *
 *  @param key key
 *
 *  @return 返回存储的数据
 */
- (id)didGeteUserDefaultsDataWithKey:(NSString *)key;

/**
 *  NSUserDefaults根据Key值删除相关键值
 *
 *  @param key key值 传入的key为nil  则不操作
 */
- (void)didRemoveUserDefaultsDataWithKey:(NSString *)key;

/**
 *  NSUserDefaults检查是否存在相关键值
 *
 *  @param key key值，如为nil 则返回NO
 *
 *  @return YES/NO
 */
- (BOOL)CheckUserDefaultDataWithKey:(NSString *)key;

/**
 *  新增 将字典转成新增的sql语句类型的字符串
 *
 *  @param dict 字典
 *
 *  @return sql语句类型的字符串
 */

+ (NSString *)ChangeDictToSQLString:(NSDictionary *)dict;
/**
 *  更新 将字典转成更新的sql语句类型的字符串
 *
 *  @param dict dict 字典
 *
 *  @return sql语句类型的字符串
 */

+ (NSString *)UpdataDictToSQLString:(NSDictionary *)dict;

/**
 *  删除 将字典转成删除的sql语句类型的字符串
 *
 *  @param dict 字典
 *
 *  @return sql语句类型的字符串
 */
+ (NSString *)DeleteDictToSQLString:(NSDictionary *)dict;

/**
 *  连表查询  带表的别名
 *
 *  @param dict 查询条件
 *  @param str  表的别名 如果只是查询  没有别名则传nil
 *
 *  @return 格式化的语句
 */
+ (NSString *)SelectConditionToSQLString:(NSMutableDictionary *)dict tableAs:(NSString *)str;

/**
 *  将字典转成网络请求语句类型的字符串
 *
 *  @param dict 字典
 *
 *  @return NSString
 */
+ (NSString *)ChangeDictToNetworkString:(NSMutableDictionary *)dict;

/**
 *  根据key值获取plist里面对应的数据  key值为nil时返回nil  不存在时返回nil
 *
 *  @param key       key值
 *  @param plistName plist文件名  若为nil  则会有默认值 如果工程文件里面只有一个plist文件  则传nil
 *
 *  @return 返回id类型
 */
+ (id)didGetPlistDataWithKey:(NSString *)key plist:(NSString *)plistName;

/**
 *  self
 *
 *  @return self
 */
+ (id)instance;

@end
