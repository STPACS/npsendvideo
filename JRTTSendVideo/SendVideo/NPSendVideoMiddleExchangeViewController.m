//
//  NPSendVideoMiddleExchangeViewController.m
//  JRTTSendVideo
//
//  Created by mac on 2020/4/6.
//  Copyright © 2020 mac. All rights reserved.
//

#import "NPSendVideoMiddleExchangeViewController.h"
#import "NPSendVideoViewController.h"

@interface NPSendVideoMiddleExchangeViewController ()

@end

@implementation NPSendVideoMiddleExchangeViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self = [super initWithRootViewController:[[NPSendVideoViewController alloc]init]];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
