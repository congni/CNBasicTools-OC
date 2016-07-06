//
//  CNFirUpdateVersionManager.m
//  CNBasicDemo
//
//  Created by 葱泥 on 16/7/6.
//  Copyright © 2016年 quanXiang. All rights reserved.
//

#import "CNFirUpdateVersionManager.h"
#import <CNKit/CNKit.h>


static CNFirUpdateVersionManager *share = nil;


@implementation CNFirUpdateVersionManager


#pragma mark -Public Method
#pragma mark 自动更新
- (void)firAutoUpdate:(NSString *)appId token:(NSString *)apiToken {
#if DEBUG
    _appID = appId;
    _apiToken = apiToken;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checking) name:UIApplicationDidBecomeActiveNotification object:nil];
#endif
}

#pragma mark -Private Method
#pragma mark 更新
- (void)firVersionChecking:(NSString *)appId token:(NSString *)apiToken {
#if DEBUG
    NSString *idUrlString = [NSString stringWithFormat:@"http://api.fir.im/apps/latest/%@?api_token=%@", appId, apiToken];
    NSURL *requestURL = [NSURL URLWithString:idUrlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:requestURL];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (!connectionError) {
            NSError *jsonError = nil;
            id object = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
            
            if (!jsonError && [object isKindOfClass:[NSDictionary class]]) {
                if (data) {
                    @try {
                        NSDictionary *result= [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                        //对比版本
                        NSString * build = result[@"version"]; //对应 CFBundleVersion, 对应Xcode项目配置"General"中的 Build
                        NSString * version = result[@"versionShort"]; //对应 CFBundleShortVersionString, 对应Xcode项目配置"General"中的 Version
                        
                        NSString * localBuild = [[NSBundle mainBundle] infoDictionary][@"CFBundleVersion"];
                        NSString * localVersion = [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"];
                        
                        NSString *url = result[@"update_url"]; //如果有更新 需要用Safari打开的地址
                        
                        if (([build floatValue] > [localBuild floatValue]) || ![version isEqualToString:localVersion]) {
                            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"更新提示" message:@"有最新的版本更新，是否需要更新" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"更新", nil];
                            alertView.description = url;
                            alertView.tag = 1000;
                            [alertView show];
                        }
                    }
                    @catch (NSException *exception) {
                        //返回格式错误 忽略掉
                    }
                }
            }
        }
    }];
#endif
}

#pragma mark 检查更新
- (void)checking {
    [self firVersionChecking:_appID token:_apiToken];
}

#pragma mark -UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 1000) {
        //更新
        if (buttonIndex != 0) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:alertView.description]];
        }
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
