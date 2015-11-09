//
//  LoadingView.m
//  profileSlide
//
//  Created by S on 15/10/16.
//  Copyright © 2015年 S. All rights reserved.
//

#import "LoadingView.h"
#import "Masonry.h"


#define ANGLE(angle) ((M_PI*angle)/180)

#define RotationAnimation @"rotationAnimation"


static CAShapeLayer * subLayer;

@implementation LoadingView


+ (instancetype)share {
    static LoadingView * view;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        view = [[LoadingView alloc] init];
        view.radius = 25;
    });
    return view;
}


#pragma mark - 开启加载
- (void)startLoading {

    [self startLoadingWithView:[[[UIApplication sharedApplication] delegate] window]];
}

#pragma mark - 开启加载 withView
- (void)startLoadingWithView:(UIView *)view {
    if (!_isLoading) {
        // 半径
        CGFloat radius = self.radius;
        
        // 画圆
        UIBezierPath * path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(radius*2, radius)];
        [path addArcWithCenter:CGPointMake(radius, radius) radius:radius startAngle:0 endAngle:ANGLE(330) clockwise:YES];
        path.lineWidth = 2;
        path.lineCapStyle = kCGLineCapRound;
        [path stroke];
        
        // 渲染
        subLayer = [CAShapeLayer layer];
        subLayer.path = path.CGPath;
        subLayer.strokeColor = [UIColor grayColor].CGColor;
        subLayer.fillColor = [UIColor clearColor].CGColor;
        subLayer.strokeStart = 0;
        subLayer.strokeEnd = 0;
        subLayer.lineWidth = 2;
        
        // 画线动画
        CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        pathAnimation.duration = 2.0;
        pathAnimation.fromValue = [NSNumber numberWithFloat:0];
        pathAnimation.toValue = [NSNumber numberWithFloat:1];
        pathAnimation.removedOnCompletion = NO;
        pathAnimation.fillMode = kCAFillModeForwards;
        [subLayer addAnimation:pathAnimation forKey:nil];
        
        // 旋转动画
        CABasicAnimation * rotaion = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        rotaion.duration = 1;
        rotaion.removedOnCompletion = NO;
        rotaion.fillMode = kCAFillModeForwards;
        rotaion.repeatCount = 100;
        rotaion.toValue = [NSNumber numberWithFloat:M_PI*2];
        [self.layer addAnimation:rotaion forKey:RotationAnimation];
        
        [self.layer addSublayer:subLayer];
        
        [view addSubview:self];
        
        _isLoading = YES;
        
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(view);
            make.size.mas_equalTo(radius*2);
        }];
    }
}

#pragma mark - 关闭加载
- (void)stopLoading {
    // 移除旋转动画
    [self.layer removeAnimationForKey:RotationAnimation];
    [subLayer removeFromSuperlayer];
    _isLoading = NO;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end


static CAShapeLayer * pullLayer;
static CAShapeLayer * lineLayer;

// 最大下拉距离
#define MaxPullDistance -100.0

@implementation PullLoadingView

+ (instancetype)share {
    static PullLoadingView * view;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        view = [[PullLoadingView alloc] init];
        view.radius = 15;
    });
    return view;
}

#pragma mark - 开启
- (void)startPullLoadingWithView:(UIView *)view withPullDistance:(CGFloat)distance {
    
    if (!_isPullLoading) {
        // 半径
        CGFloat radius = self.radius;
        pullLayer.path = nil;
        lineLayer.path = nil;
        // 画圆
        UIBezierPath * roundPath = [UIBezierPath bezierPath];
        [roundPath moveToPoint:CGPointMake(radius*2, radius)];
        CGFloat angle = distance<MaxPullDistance ? 330:(distance *330)/MaxPullDistance;
        CGFloat angle1 = angle>0 ?angle:0;
        [roundPath addArcWithCenter:CGPointMake(radius, radius) radius:radius startAngle:0 endAngle:ANGLE(angle1) clockwise:YES];
        [roundPath stroke];
        
        // 画箭头
        UIBezierPath * linePath = [UIBezierPath bezierPath];
        [linePath moveToPoint:CGPointMake(radius, radius/2)];
        [linePath addLineToPoint:CGPointMake(radius, radius*2-radius/2)];
        [linePath addLineToPoint:CGPointMake(radius*2/3, radius+radius/4)];
        [linePath moveToPoint:CGPointMake(radius, radius*2-radius/2)];
        [linePath addLineToPoint:CGPointMake(radius/3+radius, radius+radius/4)];
        linePath.lineCapStyle = kCGLineCapRound;
        linePath.lineJoinStyle = kCGLineJoinRound;
        [linePath stroke];
        
        // 渲染
        pullLayer = [CAShapeLayer layer];
        pullLayer.path = roundPath.CGPath;
        pullLayer.strokeColor = [UIColor grayColor].CGColor;
        pullLayer.fillColor = [UIColor clearColor].CGColor;
        pullLayer.lineJoin = kCALineJoinRound;
        pullLayer.lineCap = kCALineCapRound;
        pullLayer.strokeStart = 0;
        pullLayer.strokeEnd = 1;
        pullLayer.lineWidth = 1.5;
        
        lineLayer = [CAShapeLayer layer];
        lineLayer.path = linePath.CGPath;
        lineLayer.frame = self.frame;
        lineLayer.strokeColor = [UIColor grayColor].CGColor;
        lineLayer.fillColor = [UIColor clearColor].CGColor;
        lineLayer.lineJoin = kCALineJoinRound;
        lineLayer.lineCap = kCALineCapRound;
        lineLayer.strokeStart = 0;
        lineLayer.strokeEnd = 1;
        lineLayer.lineWidth = 1.5;
        
        if (![lineLayer.superlayer isEqual:self.superview.layer]) {
            [self.superview.layer addSublayer:lineLayer];
        }
        
        // 超过下拉警戒线后，开启旋转
        if (distance < MaxPullDistance) {
            // 旋转动画
            CABasicAnimation * rotaion = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
            rotaion.duration = 1;
            rotaion.removedOnCompletion = NO;
            rotaion.fillMode = kCAFillModeForwards;
            rotaion.repeatCount = 100;
            rotaion.toValue = [NSNumber numberWithFloat:M_PI*2];
            [self.layer addAnimation:rotaion forKey:RotationAnimation];
            
            [lineLayer removeFromSuperlayer];
            _isPullLoading = YES;
        }
        
        if (![pullLayer.superlayer isEqual:self.layer]) {
            [self.layer addSublayer:pullLayer];
            
        }
        
        [view addSubview:self];
        
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(view.mas_centerX).offset(-radius);
            make.bottom.equalTo(view.mas_top).offset(-5);
            make.size.mas_equalTo(radius*2);
        }];
    }
}

#pragma mark - 关闭
- (void)stopLoading {
    // 移除旋转动画
    [self.layer removeAnimationForKey:RotationAnimation];
    _isPullLoading = NO;
}

#pragma mark - 移除layer
- (void)removeLayer {
    [lineLayer removeFromSuperlayer];
    [pullLayer removeFromSuperlayer];
}

@end









