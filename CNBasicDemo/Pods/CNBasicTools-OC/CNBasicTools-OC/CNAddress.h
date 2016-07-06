//
//  CNAddress.h
//  CNBasicDemo
//
//  Created by 葱泥 on 16/7/5.
//  Copyright © 2016年 quanXiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface CNAddress : NSObject

/**
 *  国家
 */
@property (nonatomic, strong) NSString *country;
/**
 *  省份
 */
@property (nonatomic, strong) NSString *province;
/**
 *  城市
 */
@property (nonatomic, strong) NSString *city;
/**
 *  区域
 */
@property (nonatomic, strong) NSString *district;
/**
 *  街道
 */
@property (nonatomic, strong) NSString *street;
/**
 *  地址
 */
@property (nonatomic, strong) NSString *address;
/**
 *  坐标
 */
@property (nonatomic, assign) CLLocationCoordinate2D location;

@end
