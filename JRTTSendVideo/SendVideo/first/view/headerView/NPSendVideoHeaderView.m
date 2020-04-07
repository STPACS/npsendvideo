//
//  NPSendVideoHeaderView.m
//  JRTTSendVideo
//
//  Created by mac on 2020/4/3.
//  Copyright © 2020 mac. All rights reserved.
//

#import "NPSendVideoHeaderView.h"
#import "NPWordSet.h"
#import <Masonry.h>
#import "NPBaseVideoPlay.h"

@interface NPSendVideoHeaderView()

@property (nonatomic, strong) UIButton *dismissBtn;

@property (nonatomic, strong) UIButton *nextBtn;

@property (nonatomic, strong) NPBaseVideoPlay *videoPlay;

@end

@implementation NPSendVideoHeaderView

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        [self addSubview:self.videoPlay];
        [self.videoPlay mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
        
        [self addSubview:self.dismissBtn];
        [self.dismissBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left);
            make.top.mas_equalTo(self.mas_top);
            make.size.mas_equalTo(CGSizeMake(90, 90));
        }];
        
        [self addSubview:self.nextBtn];
        [self.nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.mas_right);
            make.top.mas_equalTo(self.mas_top);
            make.size.mas_equalTo(CGSizeMake(90, 90));
        }];
    }
    return self;
}

- (void)setUrl:(NSURL *)url {
    _url = url;
    [self.videoPlay videoUrl:url autoplay:YES];

}

- (NPBaseVideoPlay *)videoPlay {
    if (_videoPlay == nil) {
        _videoPlay = [[NPBaseVideoPlay alloc]init];
        
    }
    return _videoPlay;
}

//取消事件
- (void)dismissBtnAction:(UIButton *)btn {
    if (self.dismissBLock) {
        self.dismissBLock();
    }
}

//下一步
- (void)nextStepAction:(UIButton *)btn {
    if (self.nextBLock) {
        self.nextBLock();
    }
}


- (UIButton *)dismissBtn {
    if (_dismissBtn == nil) {
        _dismissBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_dismissBtn setTitle:[NPWordSet cancelWord] forState:UIControlStateNormal];
        [_dismissBtn addTarget:self action:@selector(dismissBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _dismissBtn;
}

- (UIButton *)nextBtn {
    if (_nextBtn == nil) {
        _nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_nextBtn setTitle:[NPWordSet nextStep] forState:UIControlStateNormal];
        [_nextBtn addTarget:self action:@selector(nextStepAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nextBtn;
}



@end
