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

    GXProgressRateView * progressView1 = [[GXProgressRateView alloc]initWithFrame:CGRectMake(100, 100, 80, 80)];
    progressView1.rateLabelFont        = [UIFont systemFontOfSize:12.0];
    [progressView1 updateProgressRate:0.6996 animate:YES];
    [self.view addSubview:progressView1];
    
    GXProgressRateView * progressView2 = [[GXProgressRateView alloc]initWithFrame:CGRectMake(100, 200, 80, 80)];
    progressView2.rateLabelFont        = [UIFont systemFontOfSize:12.0];
    [progressView2 updateProgressRate:1.00 animate:NO];
    [self.view addSubview:progressView2];
    
    GXProgressRateView * progressView3 = [[GXProgressRateView alloc]initWithFrame:CGRectMake(100, 300, 80, 80)];
    progressView3.rateLabelFont        = [UIFont systemFontOfSize:12.0];
    [progressView3 updateProgressRate:0.00 animate:NO];
    [self.view addSubview:progressView3];


}




@end
