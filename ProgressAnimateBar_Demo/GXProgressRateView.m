//
//  GXProgressRateView.m
//  ProgressAnimateBar_Demo
//
//  Created by yingcan on 17/2/23.
//  Copyright © 2017年 yingcan. All rights reserved.
//

#import "GXProgressRateView.h"

@interface GXProgressRateView ()
{
    CGFloat _number;
}
@property (nonatomic, strong) UIView  * progressView;
@property (nonatomic, strong) UILabel * progressNumLabel;
@property (nonatomic, strong) NSTimer * timer;
@property (nonatomic, assign) CGFloat rate;
@property (nonatomic, strong) CAShapeLayer * shapeLayer;

@end

@implementation GXProgressRateView
- (void)dealloc {
    [_timer invalidate];
    _timer = nil;
}
- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        [self setupProgressViewWithFrame:frame];
    }
    return self;
}
- (void)setupProgressViewWithFrame:(CGRect)frame{
    
    _progressView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    _progressView.backgroundColor = [UIColor whiteColor];

    _progressNumLabel               = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, 30)];
    _progressNumLabel.center        = _progressView.center;
    _progressNumLabel.textAlignment = NSTextAlignmentCenter;
    _progressNumLabel.text          = @"0.00%";
    _progressNumLabel.textColor     = [UIColor orangeColor];
    _progressNumLabel.font          = [UIFont systemFontOfSize:12.0];
    
    [self addSubview:self.progressView];
    [self addSubview:self.progressNumLabel];
    
    //先画个背景圆
    [self quarzFullCircle:_progressView];

}
- (void)setRateLabelFont:(UIFont *)rateLabelFont {

    _rateLabelFont = rateLabelFont;
    self.progressNumLabel.font = rateLabelFont;
}
- (void)setRateLabelTextColor:(UIColor *)rateLabelTextColor {
    
    _rateLabelTextColor = rateLabelTextColor;
    self.progressNumLabel.textColor = rateLabelTextColor;
}
#pragma mark - Public 更新进度条
- (void)updateProgressRate:(CGFloat)rate animate:(BOOL)animate{
    //保存下当前进度
    _rate = rate;
    if (rate == 0) {
        return;
    }
    if (animate == YES) { //带有动画的话，开启定时器画圈圈
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            _timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(timerClick) userInfo:nil repeats:YES];
            //开启子线程的runloop，保活此定时器
            NSRunLoop * loop = [NSRunLoop currentRunLoop];
            [loop run];
            
        });

    } else {
        
        self.progressNumLabel.text = [NSString stringWithFormat:@"%.2f%%",rate * 100];
        //直接画出相应的圈圈
        [self quarz:self.progressView withPercent:rate];
    }
}
#pragma mark - Private
- (void)timerClick {
    if (_number > _rate) {
        
        self.progressNumLabel.text = [NSString stringWithFormat:@"%.2f%%",_rate * 100];
        [_timer invalidate];
        _timer  = nil;
        _number = 0;
        CFRunLoopRef cfloop = CFRunLoopGetCurrent();
        CFRunLoopStop(cfloop);
        return;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
       
        self.progressNumLabel.text = [NSString stringWithFormat:@"%.2f%%",_number * 100];
        //不断重新画圈圈
        [self quarz:self.progressView withPercent:_number];
        _number += 0.01;
    });
}

#pragma mark - Private 画一个背景填充圈
- (void)quarzFullCircle:(UIView *)view{
    
    UIBezierPath *fullCircle =
    [UIBezierPath bezierPathWithArcCenter:view.center
                                   radius:(view.bounds.size.width / 2)-2
                               startAngle: -M_PI * 1/ 2
                                 endAngle:M_PI*2 - M_PI * 1/ 2
                                clockwise:YES];
    
    CAShapeLayer *shapeFullLayer = [CAShapeLayer layer];
    shapeFullLayer.fillColor   = [UIColor clearColor].CGColor;
    shapeFullLayer.lineWidth   = 2.0f;
    shapeFullLayer.strokeColor = [UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1].CGColor;
    shapeFullLayer.path        = fullCircle.CGPath;
    [view.layer addSublayer:shapeFullLayer];
    
}

#pragma mark - Private 画完成进度圈
- (void)quarz:(UIView *)view withPercent:(CGFloat)percent {
    
    //第一步，通过UIBezierPath设置圆形的矢量路径
    UIBezierPath *circle =
    [UIBezierPath bezierPathWithArcCenter:view.center
                                   radius:(view.bounds.size.width / 2)-2
                               startAngle: -M_PI * 1/ 2
                                 endAngle:M_PI*2 * percent -M_PI * 1/ 2
                                clockwise:YES];
    
    [self.shapeLayer removeFromSuperlayer];
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.fillColor   = [UIColor clearColor].CGColor;
    shapeLayer.lineWidth   = 2.0f;
    //圈圈的颜色
    shapeLayer.strokeColor = [UIColor orangeColor].CGColor;
    shapeLayer.path        = circle.CGPath;
    [view.layer addSublayer:shapeLayer];
    
    self.shapeLayer = shapeLayer;
}

@end
