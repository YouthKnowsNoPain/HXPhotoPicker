//
//  HXFullScreenCameraPlayView.m
//  照片选择器
//
//  Created by 洪欣 on 2017/5/23.
//  Copyright © 2017年 洪欣. All rights reserved.
//

#import "HXFullScreenCameraPlayView.h"

@interface HXFullScreenCameraPlayView ()
// 外界圆形
@property (nonatomic, strong) CAShapeLayer *whiteCircleLayer;
// 内部渐变圆形，或者方块，动画
@property (nonatomic, strong) CAGradientLayer *circleLayer;
// 进度扇形
@property (nonatomic, strong) CAShapeLayer *progressLayer;
// 中间白色圆
@property (nonatomic, strong) CALayer *centerCircleLayer;
// 最小进度标记
@property (nonatomic, strong) CALayer *minProgressMark;
// 最小进度扇形
@property (nonatomic, strong) CAShapeLayer *minProgressLayer;

@property (assign, nonatomic) CGFloat currentProgress;
@property (assign, nonatomic) CGPoint progressCenter;
@end

@implementation HXFullScreenCameraPlayView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame color:(UIColor *)color {
    if (self = [super initWithFrame:frame]) {
        self.color = color;
        [self setup];
    }
    return self;
}
- (UIColor *)color {
    if (!_color) {
        _color = [UIColor colorWithRed:253/255.0 green:142/255.0 blue:36/255.0 alpha:1];
    }
    return _color;
}

- (void)setup {
    
    self.minProgress = 0.1;
    
    self.backgroundColor = [UIColor clearColor];
    CAShapeLayer *whiteCircleLayer = [CAShapeLayer layer];
    whiteCircleLayer.strokeColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1].CGColor;
    whiteCircleLayer.fillColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0].CGColor;
    whiteCircleLayer.lineWidth = 6;
    whiteCircleLayer.path = [self circlePath:self.frame.size.width * 0.5].CGPath;
    [self.layer addSublayer:whiteCircleLayer];
    self.whiteCircleLayer = whiteCircleLayer;
    
    // 内部白色圆
    self.centerCircleLayer = [CALayer layer];
    self.centerCircleLayer.frame = CGRectMake(3, 3, self.frame.size.width-6.0, self.frame.size.width-6.0);
    self.centerCircleLayer.masksToBounds = YES;
    self.centerCircleLayer.cornerRadius = _centerCircleLayer.bounds.size.width/2.0;
    self.centerCircleLayer.backgroundColor = [UIColor whiteColor].CGColor;
    [self.layer addSublayer:self.centerCircleLayer];
    
    CAGradientLayer *circleLayer = [CAGradientLayer layer];
    UIColor *start = [UIColor colorWithRed:88.0/255.0 green: 164.0/255.0 blue:1 alpha:1];
    UIColor *end = [UIColor colorWithRed:67.0/255.0 green: 122.0/255.0 blue:235.0/255.0 alpha:1];
    circleLayer.colors = @[(__bridge id)start.CGColor,(__bridge id)end.CGColor];
    circleLayer.locations = @[@0,@1];
    circleLayer.startPoint = CGPointMake(0.5, 0);
    circleLayer.endPoint = CGPointMake(0.5, 1);
    circleLayer.masksToBounds = YES;
    circleLayer.bounds = CGRectMake(0, 0, self.frame.size.width-6.0, self.frame.size.width-6.0);
    circleLayer.cornerRadius = circleLayer.bounds.size.width/2.0;
    circleLayer.position = CGPointMake(self.frame.size.width/2.0, self.frame.size.width/2.0);
    [self.layer addSublayer:circleLayer];
    self.circleLayer = circleLayer;
    
    // 最小进度扇形
    self.minProgressLayer = [CAShapeLayer layer];
    self.minProgressLayer.strokeColor = [[UIColor whiteColor] colorWithAlphaComponent:0.4].CGColor;
    self.minProgressLayer.fillColor = [UIColor clearColor].CGColor;
    self.minProgressLayer.lineWidth = 6;
    UIBezierPath *minProgressPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.frame.size.width * 0.5, self.frame.size.height * 0.5)
                                                                   radius:self.frame.size.width * 0.5 startAngle:-M_PI/2.0
                                                                 endAngle:self.minProgress*2*M_PI-M_PI/2.0
                                                                clockwise:true];
    minProgressPath.lineWidth = 1;
    self.minProgressLayer.hidden = YES;
    self.minProgressLayer.path = minProgressPath.CGPath;
    [self.layer addSublayer:self.minProgressLayer];
    
    // 进度
    self.progressCenter = CGPointMake(self.frame.size.width * 0.5, self.frame.size.height * 0.5);
    CAShapeLayer *progressLayer = [CAShapeLayer layer];
    progressLayer.strokeColor = self.color.CGColor;
    progressLayer.fillColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0].CGColor;
    progressLayer.lineWidth = 6;
    progressLayer.path = [UIBezierPath bezierPathWithArcCenter:self.progressCenter
                                                        radius:(self.frame.size.width * 0.5)
                                                    startAngle:-M_PI / 2
                                                      endAngle:-M_PI / 2 + M_PI * 2 * 1
                                                     clockwise:true].CGPath;
    progressLayer.hidden = YES;
    [self.layer addSublayer:progressLayer];
    self.progressLayer = progressLayer;
    self.currentProgress = 0.f;
    
    self.minProgressMark = [CALayer layer];
    self.minProgressMark.backgroundColor = [UIColor whiteColor].CGColor;
    self.minProgressMark.frame = CGRectMake(0, 0, 2, 6);
    self.minProgressMark.affineTransform = CGAffineTransformMakeRotation(self.minProgress*2*M_PI);
    // 抗锯齿
    self.minProgressMark.allowsEdgeAntialiasing = YES;
    CGFloat angle = M_PI/2 - self.minProgress*2*M_PI;
    CGFloat positionY = (self.frame.size.width/2.0) * (1 - sin(angle));
    CGFloat positionX = (self.frame.size.width/2.0) * (1 + cos(angle));
    self.minProgressMark.position = CGPointMake(positionX, positionY);
    self.minProgressMark.hidden = YES;
    [self.layer addSublayer:self.minProgressMark];
}
- (UIBezierPath *)circlePath:(CGFloat)radius {
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.frame.size.width * 0.5, self.frame.size.height * 0.5)
                                                        radius:radius
                                                    startAngle:0
                                                      endAngle:M_PI * 2
                                                     clockwise:true];
    path.lineWidth = 1;
    return path;
}
- (void)clean {
    self.progressLayer.hidden = YES;
    self.minProgressMark.hidden = YES;
    self.minProgressLayer.hidden = YES;
    UIColor *start = [UIColor colorWithRed:88.0/255.0 green: 164.0/255.0 blue:1 alpha:1];
    UIColor *end = [UIColor colorWithRed:67.0/255.0 green: 122.0/255.0 blue:235.0/255.0 alpha:1];
    self.circleLayer.colors = @[(__bridge id)start.CGColor,(__bridge id)end.CGColor];
    self.circleLayer.bounds = CGRectMake(0, 0, self.frame.size.width-6.0, self.frame.size.width-6.0);
    self.circleLayer.cornerRadius = _centerCircleLayer.bounds.size.width/2.0;;
    self.whiteCircleLayer.strokeColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1].CGColor;
    self.currentProgress = 0;
}
- (void)setProgress:(CGFloat)progress {
    _progress = progress; 
    self.progressLayer.hidden = NO;
    self.minProgressMark.hidden = NO;
    self.minProgressLayer.hidden = NO;
    _circleLayer.cornerRadius = 2.0;
    _circleLayer.masksToBounds = YES;
    _circleLayer.bounds = CGRectMake(0, 0, 20.0, 20.0);
    UIColor *start = [UIColor colorWithRed:67.0/255.0 green: 122.0/255.0 blue:235.0/255.0 alpha:1];
    UIColor *end = [UIColor colorWithRed:67.0/255.0 green: 122.0/255.0 blue:235.0/255.0 alpha:1];
    _circleLayer.colors = @[(__bridge id)start.CGColor,(__bridge id)end.CGColor];
    
    self.whiteCircleLayer.strokeColor = [[UIColor colorWithRed:1 green:1 blue:1 alpha:1] colorWithAlphaComponent:0.19].CGColor;
    [self.progressLayer removeAnimationForKey:@"circle"];
    CABasicAnimation *circleAnim = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    circleAnim.fromValue = @(self.currentProgress);
    circleAnim.toValue = @(progress);
    circleAnim.duration = 0.2f;
    circleAnim.fillMode = kCAFillModeForwards;
    circleAnim.removedOnCompletion = NO;
    circleAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    [self.progressLayer addAnimation:circleAnim forKey:@"circle"];

    self.currentProgress = progress;
}

- (void)setMinProgress:(CGFloat)minProgress {
    _minProgress = minProgress;
    self.minProgressMark.affineTransform = CGAffineTransformMakeRotation(_minProgress*2*M_PI);
    CGFloat angle = M_PI/2 - _minProgress*2*M_PI;
    CGFloat positionY = (self.frame.size.width/2.0) * (1 - sin(angle));
    CGFloat positionX = (self.frame.size.width/2.0) * (1 + cos(angle));
    self.minProgressMark.position = CGPointMake(positionX, positionY);
}

- (UIBezierPath *)pathForProgress:(CGFloat)progress {
    CGPoint center = CGPointMake(self.frame.size.width * 0.5, self.frame.size.height * 0.5);
    CGFloat radius = self.frame.size.height * 0.5;
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center
                                                        radius:radius
                                                    startAngle:-M_PI / 2
                                                      endAngle:-M_PI / 2 + M_PI * 2 * progress
                                                     clockwise:true];
    path.lineWidth = 1;
    return path;
}

@end
