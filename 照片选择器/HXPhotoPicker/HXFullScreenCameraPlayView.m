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
// 内部圆形
@property (nonatomic, strong) CAGradientLayer *circleLayer;
// 进度扇形
@property (nonatomic, strong) CAShapeLayer *progressLayer;
// 中间方块
@property (nonatomic, strong) CALayer *centerSquareLayer;
// 最小进度标记
@property (nonatomic, strong) CALayer *minProgressMark;

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
    
    CAGradientLayer *circleLayer = [CAGradientLayer layer];
    UIColor *start = [UIColor colorWithRed:88.0/255.0 green: 164.0/255.0 blue:1 alpha:1];
    UIColor *end = [UIColor colorWithRed:67.0/255.0 green: 122.0/255.0 blue:235.0/255.0 alpha:1];
    circleLayer.colors = @[(__bridge id)start.CGColor,(__bridge id)end.CGColor];
    circleLayer.locations = @[@0,@1];
    circleLayer.startPoint = CGPointMake(0.5, 0);
    circleLayer.endPoint = CGPointMake(0.5, 1);
    circleLayer.cornerRadius = 31.0;
    circleLayer.masksToBounds = YES;
    circleLayer.frame = CGRectMake(3, 3, self.frame.size.width-6.0, self.frame.size.width-6.0);
    [self.layer addSublayer:circleLayer];
    self.circleLayer = circleLayer;
    
    self.centerSquareLayer = [CALayer layer];
    self.centerSquareLayer.frame = CGRectMake((self.frame.size.width-20)/2.0, (self.frame.size.width-20)/2.0, 20, 20);
    self.centerSquareLayer.masksToBounds = YES;
    self.centerSquareLayer.cornerRadius = 2.0;
    self.centerSquareLayer.backgroundColor = [UIColor colorWithRed:67.0/255.0 green: 122.0/255.0 blue:235.0/255.0 alpha:1].CGColor;
    self.centerSquareLayer.hidden = YES;
    [self.layer addSublayer:self.centerSquareLayer];
    
    self.progressCenter = CGPointMake(self.frame.size.width * 0.5, self.frame.size.height * 0.5);
    CAShapeLayer *progressLayer = [CAShapeLayer layer];
    progressLayer.strokeColor = self.color.CGColor;
    progressLayer.fillColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0].CGColor;
    progressLayer.lineWidth = 6;
    progressLayer.path = [UIBezierPath bezierPathWithArcCenter:self.progressCenter radius:self.frame.size.width * 0.5 startAngle:-M_PI / 2 endAngle:-M_PI / 2 + M_PI * 2 * 1 clockwise:true].CGPath;
    progressLayer.hidden = YES;
    [self.layer addSublayer:progressLayer];
    self.progressLayer = progressLayer;
    self.currentProgress = 0.f;
    
    self.minProgressMark = [CALayer layer];
    self.minProgressMark.backgroundColor = [UIColor whiteColor].CGColor;
    self.minProgressMark.frame = CGRectMake(0, 0, 2, 6);
    self.minProgressMark.affineTransform = CGAffineTransformMakeRotation(self.minProgress*2*M_PI);
    self.minProgressMark.allowsEdgeAntialiasing = YES;
    CGFloat angle = M_PI/2 - self.minProgress*2*M_PI;
    CGFloat positionY = (self.frame.size.width/2.0) * (1 - sin(angle));
    CGFloat positionX = (self.frame.size.width/2.0) * (1 + cos(angle));
    self.minProgressMark.position = CGPointMake(positionX, positionY);
    self.minProgressMark.hidden = YES;
    [self.layer addSublayer:self.minProgressMark];
}
- (UIBezierPath *)circlePath:(CGFloat)radius {
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.frame.size.width * 0.5, self.frame.size.height * 0.5) radius:radius startAngle:0 endAngle:M_PI * 2 clockwise:true];
    path.lineWidth = 1;
    return path;
}
- (void)clean {
    self.progressLayer.hidden = YES;
    self.centerSquareLayer.hidden = YES;
    self.minProgressMark.hidden = YES;
    UIColor *start = [UIColor colorWithRed:88.0/255.0 green: 164.0/255.0 blue:1 alpha:1];
    UIColor *end = [UIColor colorWithRed:67.0/255.0 green: 122.0/255.0 blue:235.0/255.0 alpha:1];
    self.circleLayer.colors = @[(__bridge id)start.CGColor,(__bridge id)end.CGColor];
    self.whiteCircleLayer.strokeColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1].CGColor;
    self.currentProgress = 0;
}
- (void)setProgress:(CGFloat)progress {
    _progress = progress; 
    self.progressLayer.hidden = NO;
    self.minProgressMark.hidden = NO;
    self.centerSquareLayer.hidden = NO;
    self.circleLayer.colors = @[(__bridge id)[UIColor whiteColor].CGColor,(__bridge id)[UIColor whiteColor].CGColor];
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
    
//    self.progressLayer.path = [UIBezierPath bezierPathWithArcCenter:self.progressCenter radius:self.progressCenter.x startAngle:-M_PI / 2.f endAngle:-M_PI / 2.f + M_PI * 2.f * progress clockwise:true].CGPath;
    
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
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:-M_PI / 2 endAngle:-M_PI / 2 + M_PI * 2 * progress clockwise:true];
    path.lineWidth = 1;
    return path;
}

@end
