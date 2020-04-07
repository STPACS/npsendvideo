//
//  NSObject+NPMediaJurisdiction.h
//  JRTTSendVideo
//
//  Created by mac on 2020/4/6.
//  Copyright © 2020 mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (NPMediaJurisdiction)

/**
 获取相册权限
 @param handler 获取权限结果
 */
+ (void)requestPhotosLibraryAuthorization:(void(^)(BOOL ownAuthorization))handler;

/**
 进入app设置页面
 */
+ (void)openAppSettings;

@end

NS_ASSUME_NONNULL_END
