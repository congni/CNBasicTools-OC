//
//  CNLocation.h
//  CNBasicDemo
//
//  Created by 葱泥 on 16/7/5.
//  Copyright © 2016年 quanXiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "CNAddress.h"
#import <UIKit/UIKit.h>

/**
 *  回调代理
 */
@protocol CNLocationDelegate <NSObject>

/**
 *  回调方法
 *
 *  @param addressInfomation 定位成功 返回CNAddress数据，失败则返回nil
 *  @param locationError     定位成功 返回nil 失败则返回NSError
 */
- (void)locationCompleteHandle:(CNAddress *)addressInfomation error:(NSError *)locationError;

@end

@interface CNLocation : NSObject<CLLocationManagerDelegate> {
    CLLocationManager *_locationManager;
    BOOL _isReverseGeocodeLocation;
    CNAddress *_addressInfomation;
}

/**
 *  定时清除定位数据 设置为0则不定时清除
 */
@property (nonatomic, assign) NSTimeInterval clearDataTimeInterval;
/**
 *  回调代理
 */
@property (nonatomic, weak) id<CNLocationDelegate>delegate;

/**
 *  单例
 *
 *  @return self
 */
+ (id)instance;

/**
 *  开启定位 并设置回调
 *
 *  @param target 回调
 */
- (void)startLocationWithDelegate:(id)target;

/**
 *  停止定位
 */
- (void)stopLocation;

/**
 *  清除定位数据
 */
- (void)clearLocationInfomation;

@end
