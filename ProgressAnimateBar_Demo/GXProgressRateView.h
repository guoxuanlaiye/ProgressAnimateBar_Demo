//
//  GXProgressRateView.h
//  ProgressAnimateBar_Demo
//
//  Created by yingcan on 17/2/23.
//  Copyright © 2017年 yingcan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GXProgressRateView : UIView
//是否带进度动画
@property (nonatomic, assign) BOOL animateEnabled;
//进度百分比字体大小
@property (nonatomic, strong) UIFont * rateLabelFont;
//更新进度
- (void)updateProgressRate:(CGFloat)rate;
@end
