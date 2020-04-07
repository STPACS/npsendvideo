//
//  NPSendVideoBottomView.h
//  JRTTSendVideo
//
//  Created by mac on 2020/4/6.
//  Copyright © 2020 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

NS_ASSUME_NONNULL_BEGIN

@interface NPSendVideoBottomCollectionViewCell : UICollectionViewCell

@end

@interface NPSendVideoBottomView : UIView
@property (nonatomic,strong) NSArray *dataList;

@property (nonatomic, copy) void (^selectValue)(PHAsset *asset);

@end

NS_ASSUME_NONNULL_END
