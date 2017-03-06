//
//  GXProgressRateView.h
//  ProgressAnimateBar_Demo
//
//  Created by yingcan on 17/2/23.
//  Copyright © 2017年 yingcan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GXProgressRateView : UIView
//进度百分比字体大小
@property (nonatomic, strong) UIFont * rateLabelFont;
//进度百分比字体颜色
@property (nonatomic, strong) UIColor * rateLabelTextColor;

//更新进度
- (void)updateProgressRate:(CGFloat)rate animate:(BOOL)animate;
@end
