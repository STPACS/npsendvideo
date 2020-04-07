//
//  ViewController.m
//  JRTTSendVideo
//
//  Created by mac on 2020/4/3.
//  Copyright © 2020 mac. All rights reserved.
//

#import "ViewController.h"
#import "NPSendVideoViewController.h"
#import "NPSendVideoMiddleExchangeViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    UIButton *sendVideoBtn = [UIButton buttonWithType: UIButtonTypeCustom];
    [sendVideoBtn setTitle:@"发视频" forState:UIControlStateNormal];
    sendVideoBtn.frame = CGRectMake(90, 90, 90, 90);
    sendVideoBtn.backgroundColor = UIColor.orangeColor;
    [self.view addSubview:sendVideoBtn];
    [sendVideoBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    // Do any additional setup after loading the view.
}

- (void)btnAction:(UIButton *)btn {
    NPSendVideoMiddleExchangeViewController *sendVC = [[NPSendVideoMiddleExchangeViewController alloc]init];
    sendVC.modalPresentationStyle = UIModalPresentationFullScreen;

    [self presentViewController:sendVC animated:YES completion:nil];
//    [self.navigationController pushViewController:sendVC animated:YES];
}

@end
