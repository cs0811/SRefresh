//
//  UIScrollView+SRefresh.m
//  profileSlide
//
//  Created by S on 15/10/16.
//  Copyright © 2015年 S. All rights reserved.
//

#import "UIScrollView+SRefresh.h"
#import "Masonry.h"
#import <objc/runtime.h>
#import "LoadingView.h"


typedef enum{
    WillLoading = 0,
    PullIsLoading ,
    PushIsLoading ,
}RefreshState;


static RefreshState refreshState = WillLoading;

@interface UILabel (refresh)

+ (instancetype)share;

@end

@implementation UILabel (refresh)

+ (instancetype)share {
    static UILabel * label;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        label = [[UILabel alloc] init];
    });
    return label;
}

@end



#define ContentOfSet @"contentOffset"

#define PullWillLoadingTitle @"下拉即可刷新..."
#define PullIsLoadingTitle @"正在刷新..."
// 上拉刷新警戒线
#define PushDeadLine 30

static char RefreshBlockKey;
static char PullWillLoadingTitleKey;
static char PullIsLoadingTitleKey;
static char PushDeadLineKey;

@implementation UIScrollView (SRefresh)

#pragma mark - 添加刷新
- (void)addRefreshBlock:(SRefreshBlock)completion {
    
    objc_setAssociatedObject(self, &RefreshBlockKey, completion, OBJC_ASSOCIATION_COPY_NONATOMIC);
    // 添加监听
   [self addObserver:self forKeyPath:ContentOfSet options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
}

#pragma mark - 监听事件
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([object isEqual:self]) {
        CGPoint new = [[change objectForKey:@"new"] CGPointValue];
        CGPoint old = [[change objectForKey:@"old"] CGPointValue];
        if (new.y == old.y) return;
        
        if (new.y <= 0) {
            // 下拉逻辑
            [self pullRefreshWithChange:change];
        }else {
            // 上拉逻辑
            [self pushRefreshWithChange:change];
        }
    }
}

#pragma mark - 下拉
- (void)pullRefreshWithChange:(NSDictionary *)change {
    /**
     charge = @{kind:@"",new:@"",old:@""}
     */
    CGPoint new = [[change objectForKey:@"new"] CGPointValue];
    
    SRefreshBlock headerBlock = objc_getAssociatedObject(self, &RefreshBlockKey);
    
    // 文字
    UILabel * titleLabel = [UILabel share];
    titleLabel.textColor = [UIColor grayColor];
    titleLabel.font = [UIFont systemFontOfSize:16];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:titleLabel];
    
    __weak typeof(self) wself = self;
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wself.mas_centerX);
        make.bottom.equalTo(wself.mas_top).offset(-5);
        make.size.mas_equalTo(CGSizeMake(150, 30));
    }];
    
    // 动画
    PullLoadingView * loading = [PullLoadingView share];
    
    // 修改文字
    titleLabel.text = loading.isPullLoading ? [self pullIsLoadingTitle] : [self pullWillLoadingTitle];
    
    if (new.y<0) {
        [loading startPullLoadingWithView:self withPullDistance:new.y];
        if (!self.dragging && loading.isPullLoading && refreshState == WillLoading) {
            
            refreshState = PullIsLoading;
            [UIView animateWithDuration:0.25 animations:^{
                self.contentInset = UIEdgeInsetsMake(60, 0, 0, 0);
            } completion:^(BOOL finished) {
                
            }];
            
            headerBlock(Pull);
        }
    }
    
    if (self.contentOffset.y == 0) {
        [loading stopLoading];
    }

}

#pragma mark - 上拉
- (void)pushRefreshWithChange:(NSDictionary *)change {
    /**
     charge = @{kind:@"",new:@"",old:@""}
     */
    CGPoint new = [[change objectForKey:@"new"] CGPointValue];
    CGPoint old = [[change objectForKey:@"old"] CGPointValue];
    
    SRefreshBlock footerBlock = objc_getAssociatedObject(self, &RefreshBlockKey);
    
    /**
     超过警戒线开始加载更多数据
     */
    if (new.y >= self.contentSize.height-self.frame.size.height-[self pushDeadLine] && new.y>old.y && refreshState == WillLoading) {
        refreshState = PushIsLoading;
        footerBlock(Push);
    }
}

#pragma mark - 停止刷新
- (void)stopRefresh {
    refreshState = WillLoading;
    [UIView animateWithDuration:0.25 animations:^{
        self.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }];
    PullLoadingView * loading = [PullLoadingView share];
    [loading stopLoading];
}

#pragma mark - 移除刷新
- (void)removeRrefresh {
    // 移除监听
    [self removeObserver:self forKeyPath:ContentOfSet];
        
    [self stopRefresh];
}


- (NSString *)pullWillLoadingTitle {
    return objc_getAssociatedObject(self, &PullWillLoadingTitleKey)?:PullWillLoadingTitle;
}

- (void)setPullWillLoadingTitle:(NSString *)pullWillLoadingTitle {
    objc_setAssociatedObject(self, &PullWillLoadingTitleKey, pullWillLoadingTitle, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)pullIsLoadingTitle {
    return objc_getAssociatedObject(self, &PullIsLoadingTitleKey)?:PullIsLoadingTitle;
}

- (void)setPullIsLoadingTitle:(NSString *)pullIsLoadingTitle {
    objc_setAssociatedObject(self, &PullIsLoadingTitleKey, pullIsLoadingTitle, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)pushDeadLine {
    return [objc_getAssociatedObject(self, &PushDeadLineKey) floatValue] ?:PushDeadLine;
}

- (void)setPushDeadLine:(CGFloat)pushDeadLine {
    objc_setAssociatedObject(self, &PushDeadLineKey, [NSNumber numberWithFloat:pushDeadLine], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end


