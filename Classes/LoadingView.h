//
//  LoadingView.h
//  profileSlide
//
//  Created by S on 15/10/16.
//  Copyright © 2015年 S. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoadingView : UIView

/* 正在加载
 */
@property (nonatomic,assign) BOOL isLoading;

/* 半径 (默认：25)
 */
@property (nonatomic,assign) CGFloat radius;

/* 初始化
 */
+ (instancetype)share;

/* 开启加载
 */
- (void)startLoading;

/* 开启加载 withView
 */
- (void)startLoadingWithView:(UIView *)view;

/* 关闭加载
 */
- (void)stopLoading;

@end



@interface PullLoadingView : UIView

/* 下拉正在刷新
 */
@property (nonatomic,assign) BOOL isPullLoading;

/* 半径 (默认：30)
 */
@property (nonatomic,assign) CGFloat radius;

/* 初始化
 */
+ (instancetype)share;

/* 开启加载 withView withDistance
 */
- (void)startPullLoadingWithView:(UIView *)view withPullDistance:(CGFloat)distance;

/* 关闭加载
 */
- (void)stopLoading;

/* 移除layer
 */
- (void)removeLayer;


@end




