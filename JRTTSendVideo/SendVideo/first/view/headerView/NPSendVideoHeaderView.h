//
//  NPSendVideoHeaderView.h
//  JRTTSendVideo
//
//  Created by mac on 2020/4/3.
//  Copyright © 2020 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NPSendVideoHeaderView : UIView

@property (nonatomic, copy) void (^dismissBLock)(void);

@property (nonatomic, copy) void (^nextBLock)(void);

@property (nonatomic, copy) NSURL *url;

@end

NS_ASSUME_NONNULL_END
