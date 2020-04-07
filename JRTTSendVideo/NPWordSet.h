//
//  NPWordSet.h
//  JRTTSendVideo
//
//  Created by mac on 2020/4/3.
//  Copyright © 2020 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NPWordSet : NSObject

//取消
+(NSString *)cancelWord;

//下一步
+(NSString *)nextStep;

//编辑
+(NSString *)editVideoImageBtn;

//截取
+(NSString *)cutVideoImageBtn;
@end

NS_ASSUME_NONNULL_END
