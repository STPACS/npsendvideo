//
//  NPSendVideoThirdViewController.h
//  JRTTSendVideo
//
//  Created by mac on 2020/4/6.
//  Copyright © 2020 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

NS_ASSUME_NONNULL_BEGIN

@interface NPSendVideoThirdViewController : UIViewController
@property (nonatomic, strong) PHAsset *asset;

//截取的图片
@property (nonatomic, copy) void (^selectValue)(UIImage *cutImage);

@end

NS_ASSUME_NONNULL_END
