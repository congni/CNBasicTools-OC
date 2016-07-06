//
//  CNLocation.m
//  CNBasicDemo
//
//  Created by 葱泥 on 16/7/5.
//  Copyright © 2016年 quanXiang. All rights reserved.
//

#import "CNLocation.h"


static CNLocation *share = nil;


@implementation CNLocation


#pragma mark -Public Method
#pragma mark 开启定位回调
- (void)startLocationWithDelegate:(id)target {
    self.delegate = target;
    
    if (_addressInfomation) {
        if ([self.delegate respondsToSelector:@selector(locationCompleteHandle:error:)]) {
            [self.delegate locationCompleteHandle:_addressInfomation error:nil];
            
            self.delegate = nil;
        }
    }
    
    [self initStartLocationManager];
}

#pragma mark 停止定位
- (void)stopLocation {
    [_locationManager stopUpdatingLocation];
}

#pragma mark 清除数据
- (void)clearLocationInfomation {
    _isReverseGeocodeLocation = NO;
    _addressInfomation = nil;
    self.delegate = nil;
}

#pragma mark -Private Method
#pragma mark 启动定位
- (void)initStartLocationManager {
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
            // iOS 8 code
            [_locationManager requestAlwaysAuthorization];
        }
    }
    
    [_locationManager startUpdatingLocation];
}

#pragma mark 初始化数据
- (void)initData {
    self.clearDataTimeInterval = 60 * 10;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clearLocationInfomation) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clearLocationInfomation) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
}

#pragma mark -CLLocationManagerDelegate
#pragma mark 定位成功
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    CLGeocoder *geo = [[CLGeocoder alloc] init];
    
    if (_isReverseGeocodeLocation == NO) {
        _isReverseGeocodeLocation = YES;
        [self stopLocation];
        
        if (locations.count > 0) {
            // 定位成功，反编译数据
            [geo reverseGeocodeLocation:locations.lastObject completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
                if (error) {
                    _addressInfomation = nil;
                    
                    if ([self.delegate respondsToSelector:@selector(locationCompleteHandle:error:)]) {
                        [self.delegate locationCompleteHandle:nil error:error];
                    }
                    
                    return;
                }
                
                CLPlacemark *placemark = placemarks.lastObject;
                NSDictionary *addressDictionary = placemark.addressDictionary;
                NSLog(@"addressDictionary  %@", addressDictionary);
                
                if (addressDictionary) {
                    _addressInfomation = [[CNAddress alloc] init];
                    _addressInfomation.country = addressDictionary[@"Country"];
                    _addressInfomation.province = addressDictionary[@"State"];
                    _addressInfomation.city = addressDictionary[@"City"];
                    _addressInfomation.district = addressDictionary[@"SubLocality"];
                    _addressInfomation.street = addressDictionary[@"Thoroughfare"];
                    _addressInfomation.address = addressDictionary[@"Name"];
                    _addressInfomation.location = placemark.location.coordinate;
                } else {
                    _addressInfomation = nil;
                }
                
                // 回调
                if ([self.delegate respondsToSelector:@selector(locationCompleteHandle:error:)]) {
                    if (_addressInfomation == nil) {
                        NSError *error = [NSError errorWithDomain:@"定位失败" code:1 userInfo:nil];
                        [self.delegate locationCompleteHandle:nil error:error];
                    } else {
                        [self.delegate locationCompleteHandle:_addressInfomation error:nil];
                    }
                }
                
                if (self.clearDataTimeInterval != 0.0) {
                    // 定时清除数据，以便及时更新数据
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.clearDataTimeInterval * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self clearLocationInfomation];
                    });
                }
                
                [geo cancelGeocode];
            }];
        } else {
            // 回调
            if ([self.delegate respondsToSelector:@selector(locationCompleteHandle:error:)]) {
                NSError *error = [NSError errorWithDomain:@"定位失败" code:1 userInfo:nil];
                [self.delegate locationCompleteHandle:nil error:error];
            }
        }
   }
}

#pragma mark 定位失败
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    // 定位失败，清空数据, 重新定位(用于定位数据存储)
    [self clearLocationInfomation];
    [self initStartLocationManager];
    
    if ([self.delegate respondsToSelector:@selector(locationCompleteHandle:error:)]) {
        [self.delegate locationCompleteHandle:nil error:error];
    }
}

#pragma mark self
+ (id)instance {
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        if (share==nil) {
            share = [[super alloc] init];
        }
    });
    
    return share;
}

@end
