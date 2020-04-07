//
//  NPSendVideoViewController.m
//  JRTTSendVideo
//
//  Created by mac on 2020/4/3.
//  Copyright © 2020 mac. All rights reserved.
//

#import "NPSendVideoViewController.h"
#import "NPSendVideoHeaderView.h"
#import <Masonry.h>
#import "NPMediaFetcher.h"
#import "NPSendVideoBottomView.h"
#import <Photos/Photos.h>
#import "NPSendVideoSecondSeptViewController.h"

@interface NPSendVideoViewController ()

@property (nonatomic, strong) NPSendVideoHeaderView *headerView;

@property (nonatomic, strong) NPSendVideoBottomView *bottomView;

@property (nonatomic, strong) PHAsset *saveAsset;//保存，下一步用
@property (nonatomic, strong) NSURL *saveUrl;//保存，下一步用

@end

@implementation NPSendVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //获取相册里的视频
    
    [self initViews];
    
    [self getVideo];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

#pragma mark - fetchAuthorization
- (void)getVideo {
    [NSObject requestPhotosLibraryAuthorization:^(BOOL ownAuthorization) {
        if (ownAuthorization) {
            //action
            dispatch_async(dispatch_get_main_queue(), ^{
                NSArray *videoArray = [NPMediaFetcher allVideosAssets];
                self.bottomView.dataList = videoArray;
                
                //取数组第一个
                if (videoArray.count > 0) {
                    PHAsset *asset = videoArray[0];
                    self.saveAsset = asset;
                    [NPMediaFetcher getVideoUrlWithTime:asset handler:^(NSURL * _Nonnull url, NSString * _Nonnull time) {
                        self.headerView.url = url;
                        self.saveUrl = url;
                    }];
                }
            });
        } else {
            //提示可到设置页面获取权限
            [self showAlter];
        }
    }];
}

- (void)showAlter {
    UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"尚未获取到相册权限" message:@"是否到设置处进行权限设置" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *actionSure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [NSObject openAppSettings];
    }];
    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [alter dismissViewControllerAnimated:true completion:nil];
    }];
    [alter addAction:actionSure];
    [alter addAction:actionCancel];
    [self presentViewController:alter animated:true completion:nil];
}


- (void)initViews {
    [self.view addSubview:self.headerView];

    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left);
        make.top.mas_equalTo(self.view.mas_top);
        make.right.mas_equalTo(self.view.mas_right);
        make.height.mas_equalTo(self.view.frame.size.height/2);
    }];
    
    
    [self.view addSubview:self.bottomView];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left);
        make.top.mas_equalTo(self.headerView.mas_bottom);
        make.right.mas_equalTo(self.view.mas_right);
        make.height.mas_equalTo(self.view.frame.size.height/2);
    }];
}

- (NPSendVideoHeaderView *)headerView {
    if (_headerView == nil) {
        _headerView = [[NPSendVideoHeaderView alloc]init];
        _headerView.backgroundColor = UIColor.blackColor;
        
        __weak NPSendVideoViewController *weakObj = self;
        
        _headerView.dismissBLock = ^{
            [weakObj dismissViewControllerAnimated:YES completion:nil];
        };
        
        //下一步
        _headerView.nextBLock = ^{
            NPSendVideoSecondSeptViewController *sendVideoSecondVC = [[NPSendVideoSecondSeptViewController alloc]init];
            sendVideoSecondVC.asset = weakObj.saveAsset;
            [weakObj.navigationController pushViewController:sendVideoSecondVC animated:YES];
        };
    }
    return _headerView;
}

- (NPSendVideoBottomView *)bottomView {
    if (_bottomView == nil) {
        _bottomView = [[NPSendVideoBottomView alloc]init];
        _bottomView.backgroundColor = UIColor.orangeColor;
        __weak NPSendVideoViewController *weakObj = self;

        _bottomView.selectValue = ^(PHAsset * _Nonnull asset) {
            weakObj.saveAsset = asset;
            [NPMediaFetcher getVideoUrlWithTime:asset handler:^(NSURL * _Nonnull url, NSString * _Nonnull time) {
                weakObj.headerView.url = url;
                self.saveUrl = url;
            }];
            
        };
    }
    return _bottomView;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
