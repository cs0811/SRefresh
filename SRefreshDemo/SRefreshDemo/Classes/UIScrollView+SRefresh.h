//
//  UIScrollView+SRefresh.h
//  profileSlide
//
//  Created by S on 15/10/16.
//  Copyright © 2015年 S. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    Pull = 0,
    Push,
}PanState;

typedef void(^SRefreshBlock)(PanState state);


@interface UIScrollView (SRefresh)

/* 下拉即将刷新文字 (默认为：下拉即可刷新...)
 */
@property (nonatomic ,copy) NSString * pullWillLoadingTitle;
/* 下拉正在刷新文字 (默认为： 正在刷新...)
 */
@property (nonatomic ,copy) NSString * pullIsLoadingTitle;
/* 上拉警戒线 （距离contentSize底部距离，小于line自动加载上拉, 默认为：30）
 */
@property (nonatomic ,assign) CGFloat pushDeadLine;

/* 添加下拉刷新
 */
- (void)addRefreshBlock:(SRefreshBlock)completion;

/* 停止刷新动画
 */
- (void)stopRefresh;

/* 移除刷新
 */
- (void)removeRrefresh;


@end
