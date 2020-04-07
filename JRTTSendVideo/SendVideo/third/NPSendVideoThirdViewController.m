//
//  NPSendVideoThirdViewController.m
//  JRTTSendVideo
//
//  Created by mac on 2020/4/6.
//  Copyright © 2020 mac. All rights reserved.
//

#import "NPSendVideoThirdViewController.h"
#import "NPBaseVideoPlay.h"
#import "NPMediaFetcher.h"
#import <Masonry.h>
#import "NPSliderView.h"
#import "NPWordSet.h"

@interface NPSendVideoThirdViewController ()

@property (nonatomic, strong) NPBaseVideoPlay *headerView;

@property (nonatomic, strong) NPSliderView *umberSlider;

@property (nonatomic, strong) UIButton *cutBtn;//截取图片

@end

@implementation NPSendVideoThirdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = UIColor.whiteColor;
    
    [self _initViews];
   
    [NPMediaFetcher getVideoUrlWithTime:self.asset handler:^(NSURL * _Nonnull url, NSString * _Nonnull time) {
           
        self.headerView.url = url;
        NSLog(@"time:%@",time);
        self.umberSlider.maximumValue = [time floatValue];

    }];
        
    // Do any additional setup after loading the view.
}

- (void)_initViews {
    
    [self.view addSubview:self.headerView];
           
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
       make.left.mas_equalTo(self.view.mas_left);
       make.top.mas_equalTo(self.view.mas_top).mas_offset(100);
       make.right.mas_equalTo(self.view.mas_right);
       make.height.mas_equalTo(300);
    }];
       
    self.umberSlider = [[NPSliderView alloc] initWithFrame:CGRectMake(50,300, self.view.frame.size.width-100, 30)];
   
    self.umberSlider.titleStyle = TopTitleStyle;
      
    self.umberSlider.isShowTitle = YES;
   
    //设置最大和最小值
  
    self.umberSlider.minimumValue = 0;
  
    self.umberSlider.maximumTrackTintColor = [UIColor orangeColor];//设置滑块线条的颜色（右边）,默认是灰色
  
    self.umberSlider.thumbTintColor = [UIColor purpleColor];///设置滑块按钮的颜色
  
    [self.view addSubview:self.umberSlider];
   
    [self.umberSlider mas_makeConstraints:^(MASConstraintMaker *make) {
       make.left.mas_equalTo(self.view.mas_left).mas_offset(50);
       make.top.mas_equalTo(self.headerView.mas_bottom).mas_offset(30);
       make.right.mas_equalTo(self.view.mas_right).mas_offset(-50);
       make.height.mas_equalTo(30);
    }];
  
    [self.umberSlider addTarget:self action:@selector(sliderValue:) forControlEvents:UIControlEventValueChanged];
       
    
    [self.view addSubview:self.cutBtn];
    
    [self.cutBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       make.centerX.mas_equalTo(self.view.mas_centerX);
       make.top.mas_equalTo(self.umberSlider.mas_bottom).mas_offset(30);
        make.size.mas_equalTo(CGSizeMake(90, 90));
    }];
}

- (void)sliderValue:(NPSliderView *)sliderValue {
    NSLog(@"value：%f",sliderValue.value);
    
    [self.headerView editValue:sliderValue.value];
}

- (void)cutBtnAction:(UIButton *)btn {
    
    NSLog(@"value：%f",self.umberSlider.value);

    UIImage *cutImage = [NPMediaFetcher getVideoPreViewImage:self.headerView.url timeValue:CMTimeMakeWithSeconds(self.umberSlider.value, 600)];
    
    if (self.selectValue) {
        self.selectValue(cutImage);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (NPBaseVideoPlay *)headerView {
    if (_headerView == nil) {
        _headerView = [[NPBaseVideoPlay alloc]init];
        _headerView.backgroundColor = UIColor.blackColor;
    }
    return _headerView;
}

- (UIButton *)cutBtn {
    if (_cutBtn == nil) {
        _cutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cutBtn setTitle:[NPWordSet cutVideoImageBtn] forState:UIControlStateNormal];
        _cutBtn.backgroundColor = UIColor.orangeColor;
        [_cutBtn addTarget:self action:@selector(cutBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cutBtn;
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
