//
//  StartView.m
//  profileSlide
//
//  Created by S on 15/10/19.
//  Copyright © 2015年 S. All rights reserved.
//

#import "StartView.h"
#import "Masonry.h"

static CAShapeLayer * lineLayer;

#define LeftDistance 20
#define RGB(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]

@implementation StartView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (instancetype)init {
    self = [super init];
    if (self) {
        self.time = 5;
        self.height = 80;
    }
    return self;
}

- (void)loadAnimationWithView:(UIView *)view {
    
    CGFloat ScreenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = self.height;
    // 画心
    UIBezierPath* bezierPath = UIBezierPath.bezierPath;
    [bezierPath moveToPoint:CGPointMake(LeftDistance, height)];
    [bezierPath addLineToPoint:CGPointMake(ScreenWidth/2, height)];
    [bezierPath addCurveToPoint:CGPointMake(ScreenWidth/2, 0) controlPoint1:CGPointMake(ScreenWidth/2-height, height/2) controlPoint2:CGPointMake(ScreenWidth/2-height, -height*3/8)];
    [bezierPath addCurveToPoint:CGPointMake(ScreenWidth/2, height) controlPoint1:CGPointMake(ScreenWidth/2+height, -height*3/8) controlPoint2:CGPointMake(ScreenWidth/2+height, height/2)];
    [bezierPath addLineToPoint:CGPointMake(ScreenWidth-LeftDistance, height)];
    bezierPath.lineWidth = 1;
    [bezierPath stroke];
    
    lineLayer = [CAShapeLayer layer];
    lineLayer.lineCap = kCALineCapRound;
    lineLayer.lineJoin = kCALineJoinRound;
    lineLayer.lineWidth = 2;
    lineLayer.strokeColor = RGB(123, 104, 238).CGColor;
    lineLayer.path = bezierPath.CGPath;
    lineLayer.fillColor = [UIColor clearColor].CGColor;
    lineLayer.strokeStart = 0;
    lineLayer.strokeEnd = 0;
    
    // 画线动画
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation.duration = self.time;
    pathAnimation.fromValue = [NSNumber numberWithFloat:0];
    pathAnimation.toValue = [NSNumber numberWithFloat:1];
    pathAnimation.removedOnCompletion = NO;
    pathAnimation.fillMode = kCAFillModeForwards;
    [lineLayer addAnimation:pathAnimation forKey:nil];
    
    [self.layer addSublayer:lineLayer];
   
    [view addSubview:self];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.width.equalTo(view);
        make.height.mas_equalTo(height);
    }];
}





@end
