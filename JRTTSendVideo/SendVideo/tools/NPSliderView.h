//
//  NPSliderView.h
//  JRTTSendVideo
//
//  Created by mac on 2020/4/7.
//  Copyright © 2020 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger{
    TopTitleStyle,
    BottomTitleStyle
}TitleStyle;


@interface NPSliderView : UISlider

//是否显示百分比
@property (nonatomic,assign) BOOL isShowTitle;
@property (nonatomic,assign) TitleStyle titleStyle;

@end

NS_ASSUME_NONNULL_END
