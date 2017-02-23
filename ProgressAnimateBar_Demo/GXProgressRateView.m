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
    NSLock * _theLock;
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
    [_theLock unlock];
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

    _progressNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, 30)];
    _progressNumLabel.center        = _progressView.center;
    _progressNumLabel.textAlignment = NSTextAlignmentCenter;
    
    [self addSubview:self.progressView];
    [self addSubview:self.progressNumLabel];
}
- (void)setRateLabelFont:(UIFont *)rateLabelFont {

    _rateLabelFont = rateLabelFont;
    self.progressNumLabel.font = rateLabelFont;
}
#pragma mark - Public
- (void)updateProgressRate:(CGFloat)rate {
    //保存下当前进度
    _rate = rate;
    if (rate == 0) {
        return;
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        if (!_theLock) {
            _theLock = [[NSLock alloc]init];
        }
        [_theLock lock];
        
        if (_animateEnabled) { //带动画
            
            _timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(timerClick) userInfo:nil repeats:YES];
        } else { //不带动画
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                
                self.progressNumLabel.text = [NSString stringWithFormat:@"%.1f%%",rate * 100];
                //不断重新画圈圈
                [self quarz:self.progressView withPercent:rate];
            });
        }
        NSRunLoop * loop = [NSRunLoop currentRunLoop];
        [loop run];
        
    });
}
#pragma mark - Private
- (void)timerClick {
    if (_number >= _rate) {
        [_timer invalidate];
        _timer  = nil;
        _number = 0;
        NSRunLoop * loop    = [NSRunLoop currentRunLoop];
        CFRunLoopRef cfloop = [loop getCFRunLoop];
        CFRunLoopStop(cfloop);
        [_theLock unlock];
        return;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
       
        self.progressNumLabel.text = [NSString stringWithFormat:@"%.1f%%",_number * 100];
        //不断重新画圈圈
        [self quarz:self.progressView withPercent:_number];
        _number += 0.01;
    });
}
#pragma mark - Private
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
    shapeLayer.strokeColor = [UIColor orangeColor].CGColor;
    shapeLayer.path        = circle.CGPath;
    [view.layer addSublayer:shapeLayer];
    
    self.shapeLayer = shapeLayer;
}

@end
