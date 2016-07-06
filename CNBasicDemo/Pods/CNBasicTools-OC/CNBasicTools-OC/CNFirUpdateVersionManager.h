//
//  CNFirUpdateVersionManager.h
//  CNBasicDemo
//
//  Created by 葱泥 on 16/7/6.
//  Copyright © 2016年 quanXiang. All rights reserved.
//
//  使用须知：
//      1、此工具适用于在Fir.im上做的测试分发，测试端app自动更新，省去每次通知QA人员更新麻烦；
//      2、基于此适用场景，所以此工具只能在DEBUG模式下使用，工具内部已做了逻辑判断；
//      3、基于此适用场景，如果你们的分发不用Fir，则忽略本工具；
//      4、题外话：build打包ipa文件，可以用AMAppExportToIPA-Xcode-Plugin(https://github.com/MellongLau/AMAppExportToIPA-Xcode-Plugin)插件，一键导出IPA文件
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface CNFirUpdateVersionManager : NSObject<UIAlertViewDelegate> {
    NSString *_appID;
    NSString *_apiToken;
}

/**
 *  单例模式
 *
 *  @return self
 */
+ (id)instance;

/**
 *  FIR.im自动更新
 *
 *  @param apiId    appID
 *  @param apiToken apiToken
 */
- (void)firAutoUpdate:(NSString *)appId token:(NSString *)apiToken;

@end
