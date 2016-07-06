//
//  ViewController.m
//  CNBasicDemo
//
//  Created by 汪君 on 16/7/5.
//  Copyright © 2016年 quanXiang. All rights reserved.
//

#import "ViewController.h"
#import <CNKit/CNKit.h>
#import "CNBasicTools-OC/CNLocation.h"
//#import "CNFirUpdateVersionManager.h"


@interface ViewController ()<CNLocationDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
//    [[CNFirUpdateVersionManager instance] firAutoUpdate:@"5768e334f2fc426742000027" token:@"4d9f05234941cdd1c5a459910dde5b5e"];
}

- (void)locationCompleteHandle:(CNAddress *)addressInfomation error:(NSError *)locationError {
    NSLog(@"locationError   %@",locationError);
    NSLog(@"addressInfomation %@ %@ %@ %@ %@ %@", addressInfomation.country, addressInfomation.province, addressInfomation.city, addressInfomation.district, addressInfomation.street,addressInfomation.address);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [[CNLocation instance] startLocationWithDelegate:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
