# SRefresh
以Category的方法实现,模仿淘宝刷新，上拉滚到到一定位置开始自动加载更多。

pod "SRefresh" , "~>0.1.0"

~ 注册刷新

[_tableview addRefreshBlock:^(PanState state) {
        if (state == Pull) {
            NSLog(@"下拉");
        }else if (state == Push) {
            NSLog(@"上拉");
        }
}];
    
~ 停止刷新

[_tableview stopRefresh];

~ 移除刷新

-(void)dealloc 
{
    [_tableview removeRrefresh];
}
    
