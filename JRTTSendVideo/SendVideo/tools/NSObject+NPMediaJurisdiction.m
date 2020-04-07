//
//  NSObject+NPMediaJurisdiction.m
//  JRTTSendVideo
//
//  Created by mac on 2020/4/6.
//  Copyright © 2020 mac. All rights reserved.
//

#import "NSObject+NPMediaJurisdiction.h"

@implementation NSObject (NPMediaJurisdiction)

/**
 获取相册权限
 @param handler 获取权限结果
 */
+ (void)requestPhotosLibraryAuthorization:(void(^)(BOOL ownAuthorization))handler {
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        if (handler) {
            BOOL boolean = false;
            if (status == PHAuthorizationStatusAuthorized) {
                boolean = true;
            }
            handler(boolean);
        }
    }];
}

/**
 进入app设置页面
 */
+ (void)openAppSettings {
    NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    if([[UIApplication sharedApplication] canOpenURL:url]) {
        NSURL*url =[NSURL URLWithString:UIApplicationOpenSettingsURLString];
        [[UIApplication sharedApplication] openURL:url];
    } else {
        NSLog(@"无法打开设置");
    }
}
@end
