//
//  NPSendVideoSecondHeaderView.h
//  JRTTSendVideo
//
//  Created by mac on 2020/4/6.
//  Copyright © 2020 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

NS_ASSUME_NONNULL_BEGIN

@interface NPSendVideoSecondHeaderView : UIView

@property (nonatomic, strong) UIImageView *displayImageView;

@property (nonatomic, copy) NSURL *url;

@property (nonatomic, copy) PHAsset *asset;

@property (nonatomic, copy) void (^editDisplayBlock)(PHAsset *asset);

@end

NS_ASSUME_NONNULL_END
