//
//  NPSendVideoSecondHeaderView.m
//  JRTTSendVideo
//
//  Created by mac on 2020/4/6.
//  Copyright © 2020 mac. All rights reserved.
//

#import "NPSendVideoSecondHeaderView.h"
#import "NPBaseVideoPlay.h"
#import <Masonry.h>
#import "NPMediaFetcher.h"
#import "NPWordSet.h"

@interface NPSendVideoSecondHeaderView()

@property (nonatomic, strong) NPBaseVideoPlay *videoPlay;


@property (nonatomic, strong) UIButton *editDisplayBtn;

@end

@implementation NPSendVideoSecondHeaderView

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
 
        [self addSubview:self.videoPlay];
        [self.videoPlay mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
        self.videoPlay.hidden = YES;
        
        [self addSubview:self.displayImageView];
        [self.displayImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
        
        [self addSubview:self.editDisplayBtn];
        [self.editDisplayBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.mas_right);
            make.bottom.mas_equalTo(self.mas_bottom);
            make.size.mas_equalTo(CGSizeMake(60, 60));
        }];
        
    }
    return self;
}

- (void)setUrl:(NSURL *)url {
    _url = url;
    [self.videoPlay videoUrl:url autoplay:NO];
    
    //获取视频第一帧
    UIImage *image = [NPMediaFetcher getVideoPreViewImage:self.url timeValue:CMTimeMakeWithSeconds(0.0, 600)];

    self.displayImageView.image = image;

}

- (void)editBtnAction:(UIButton *)btn {
    if (self.editDisplayBlock) {
        self.editDisplayBlock(self.asset);
    }
}

- (UIButton *)editDisplayBtn {
    if (_editDisplayBtn == nil) {
        _editDisplayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_editDisplayBtn setTitle:[NPWordSet editVideoImageBtn] forState:UIControlStateNormal];
        _editDisplayBtn.backgroundColor = UIColor.orangeColor;
        [_editDisplayBtn addTarget:self action:@selector(editBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _editDisplayBtn;
}

- (UIImageView *)displayImageView {
    if (_displayImageView == nil) {
        _displayImageView = [[UIImageView alloc]init];
        _displayImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _displayImageView;
}

- (NPBaseVideoPlay *)videoPlay {
    if (_videoPlay == nil) {
        _videoPlay = [[NPBaseVideoPlay alloc]init];
        
    }
    return _videoPlay;
}


@end
