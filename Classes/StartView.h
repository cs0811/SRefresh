//
//  StartView.h
//  profileSlide
//
//  Created by S on 15/10/19.
//  Copyright © 2015年 S. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StartView : UIImageView

/* 动画持续时间 (默认5s)
 */
@property (nonatomic,assign) CGFloat time;

/* 心的高度 (默认:80)
 */
@property (nonatomic,assign) CGFloat height;

/* 加载启动动画
 */
- (void)loadAnimationWithView:(UIView *)view;


@end
