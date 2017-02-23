//
//  ViewController.m
//  ProgressAnimateBar_Demo
//
//  Created by yingcan on 17/2/23.
//  Copyright © 2017年 yingcan. All rights reserved.
//

#import "ViewController.h"
#import "GXProgressRateView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    GXProgressRateView * progressView = [[GXProgressRateView alloc]initWithFrame:CGRectMake(100, 100, 40, 40)];
    [progressView updateProgressRate:0.694];
    progressView.animateEnabled = YES;
    progressView.rateLabelFont  = [UIFont systemFontOfSize:12.0]; 
    [self.view addSubview:progressView];
}




@end
