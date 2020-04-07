//
//  NPSendVideoSecondSeptViewController.m
//  JRTTSendVideo
//
//  Created by mac on 2020/4/6.
//  Copyright © 2020 mac. All rights reserved.
//

#import "NPSendVideoSecondSeptViewController.h"
#import "NPSendVideoSecondHeaderView.h"
#import "NPMediaFetcher.h"
#import <Masonry.h>
#import "NPSendVideoThirdViewController.h"

@interface NPSendVideoSecondSeptViewController ()
@property (nonatomic, strong) NPSendVideoSecondHeaderView *headerView;

@end

@implementation NPSendVideoSecondSeptViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;


    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationController.navigationBar.translucent = YES;
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:(34/255.0) green:(34/255.0)  blue:(34/255.0) alpha:1.0];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [UIApplication sharedApplication].statusBarHidden = NO;

    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(onMore:) forControlEvents:UIControlEventTouchUpInside];
    button.backgroundColor = UIColor.orangeColor;
    [button setTitle:@"返回" forState:UIControlStateNormal];
    [button sizeToFit];
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = buttonItem;
    
    
    [self.view addSubview:self.headerView];
    
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left);
        make.top.mas_equalTo(self.view.mas_top).mas_offset(100);
        make.right.mas_equalTo(self.view.mas_right);
        make.height.mas_equalTo(300);
    }];
    
    
    [NPMediaFetcher getVideoUrlWithTime:self.asset handler:^(NSURL * _Nonnull url, NSString * _Nonnull time) {
        self.headerView.url = url;

    }];
    
    // Do any additional setup after loading the view.
}

- (NPSendVideoSecondHeaderView *)headerView {
    if (_headerView == nil) {
        _headerView = [[NPSendVideoSecondHeaderView alloc]init];
        _headerView.backgroundColor = UIColor.blackColor;
        _headerView.asset = self.asset;
        __weak NPSendVideoSecondSeptViewController *weakObj = self;
        _headerView.editDisplayBlock = ^(PHAsset * _Nonnull asset) {
            
            NPSendVideoThirdViewController *sendVideoThirdVC = [[NPSendVideoThirdViewController alloc]init];
            sendVideoThirdVC.asset = asset;
            sendVideoThirdVC.selectValue = ^(UIImage * _Nonnull cutImage) {
                weakObj.headerView.displayImageView.image = cutImage;
            };
            [weakObj.navigationController pushViewController:sendVideoThirdVC animated:YES];
            
        };
       
    }
    return _headerView;
}


- (void)onMore:(UIButton *)button {
    [self.navigationController popViewControllerAnimated:YES];
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
