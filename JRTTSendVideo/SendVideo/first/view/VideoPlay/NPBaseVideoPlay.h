//
//  NPBaseVideoPlay.h
//  JRTTSendVideo
//
//  Created by mac on 2020/4/6.
//  Copyright © 2020 mac. All rights reserved.
//基本的视频播放

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NPBaseVideoPlay : UIView


@property (nonatomic, copy)NSURL *url;//视频URL

- (void)videoUrl:(NSURL *)url autoplay:(BOOL)autoplay;

//编辑时间
- (void)editValue:(CGFloat)time;

@end

NS_ASSUME_NONNULL_END
