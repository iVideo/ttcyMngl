//
//  OnlineViewController.m
//  TtcyMngl
//
//  Created by 牛利江 on 14-7-1.
//  Copyright (c) 2014年 hqglt. All rights reserved.
//

#import "OnlineViewController.h"
#import "ImScrollView.h"
#import "Celebrity.h"
#import "CommonClass.h"
#import "CelebrityCell.h"
#import "Celebrity.h"
#import "OnlineCelebritView.h"
#import "Model.h"
#import "HUD.h"

#define navigationWhile 51
#define sideLabelColor whiteColor
#define celebrityCellHeight kMainScreenHeight-120-44

@interface OnlineViewController ()

@end

@implementation OnlineViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
 
    return self;
}

-(void)initView{
    CGRect frame=self.view.frame;
    
    frame.origin.y=0;
    if (isIOS7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.modalPresentationCapturesStatusBarAppearance = NO;
    }
    
    self.mostlyView=[[UIView alloc]initWithFrame:frame];

    
    [self.view addSubview: self.mostlyView];

}
- (void)OnlineviewDidLoad
{
    [super viewDidLoad];
    getTopDistance()
    getPlayBarHeight()
    [CommonClass backgroundColorWhitUIView:self.mostlyView];
    [self addNavigationView];
    
//    [self initialize];
//    _nonceType=1;
//    [self loadMore];
}
#pragma mark 添加右侧导航
-(void)addNavigationView{
    
    OnlineCelebritView *onlineCelebritView;
    if (_navigationUrl!=nil) {
     onlineCelebritView=[OnlineCelebritView addCelebritTypesViewWhitFram:CGRectMake(0, 0, navigationWhile, self.view.frame.size.height) ViewTitle:_navigationTitle url:_navigationUrl];
    }else{
        onlineCelebritView=[OnlineCelebritView addCelebritTypesViewWhitFram:CGRectMake(0, 0, navigationWhile, self.view.frame.size.height) ViewTitle:_navigationTitle stringtypes:_navigationArray];
        
    }
    onlineCelebritView.delegate=self;
    [self.mostlyView addSubview: onlineCelebritView ];
   // addCelebritTypesViewWhitFram
   
}
//初始化  UITableView
-(void)initialize{
    _pageCount=0;
    _models=[[NSMutableArray alloc]init];
    [celebrityTableView removeFromSuperview];
    celebrityTableView=[[UITableView alloc]init];
    celebrityTableView.dataSource=self;
    celebrityTableView.delegate=self;
    celebrityTableView.transform =CGAffineTransformMakeRotation(-M_PI_2);
    celebrityTableView.frame=CGRectMake(navigationWhile+2,86, kMainScreenWidth-navigationWhile,self.view.frame.size.height);
    [celebrityTableView setBackgroundColor:[UIColor clearColor]];
    celebrityTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_mostlyView addSubview:celebrityTableView];
    
    celebrityTableView.showsVerticalScrollIndicator = FALSE;
    celebrityTableView.showsHorizontalScrollIndicator = FALSE;
}
#pragma mark  数据源方法
#pragma mark 有多少数据
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_pageSize==0) {
        NSLog(@"%de",_models.count);
        return _models.count;
    }
     NSLog(@"%de",_models.count==0?0:_models.count+1);
    return _models.count==0?0:_models.count+1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CelebrityCell *cell= [tableView dequeueReusableCellWithIdentifier:[CelebrityCell ID]];
    if (cell==nil) {
        cell=[CelebrityCell  newCell];
        [cell setBackgroundColor:[UIColor clearColor]];
    }
    if([indexPath row] ==_models.count) {
        //创建loadMoreCell
        cell=[CelebrityCell  newCell];
        [cell setBackgroundColor:[UIColor clearColor]];
        [cell setLoadTitle:@"  "];
    }else
        if (indexPath.row<_models.count) {
            Celebrity *cel=_models[indexPath.row];
            
            [cell celebrityWithModel:cel];
        }
    cell.transform = CGAffineTransformMakeRotation(M_PI);
    return cell;
}
#pragma mark --代理方法
#pragma mark  行高  旋转后的行宽
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
}
#pragma mark 加载数据
-(void)loadMore
{
    _pageCount++;

    NSMutableArray *mutabs=[[NSMutableArray alloc]init];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSArray *array = [CommonClass getJosnNSArrayUrl:_Url  sid:@"Model"];
        //通知主线程刷新
        dispatch_async(dispatch_get_main_queue(), ^{
            [HUD clearHudFromApplication];
            NSIndexPath    *newPath =  [NSIndexPath indexPathForRow:_models.count inSection:0];
            CelebrityCell *loadMoreCell=(CelebrityCell *)[celebrityTableView cellForRowAtIndexPath:newPath];
            loadMoreCell.userInteractionEnabled = NO;
            if (array==nil) {
                
                [loadMoreCell setLoadTitle:@"  "];
            }else{
                for (NSDictionary *dict in array) {
                    Class class= NSClassFromString(_modeName);
                    
                    Model *model=[class  initWithDict:dict];
                    [_models addObject:model];
                    [mutabs addObject:model];
                }
                [self performSelectorOnMainThread:@selector(appendTableWith:) withObject:mutabs waitUntilDone:NO];
            }
        });
    });
}
-(void) appendTableWith:(NSMutableArray *)data
{
    [HUD clearHudFromApplication];
    int dd=_pageCount==1?1:0;
     if (_pageSize==0) {
         dd=0;
     }
    NSMutableArray *insertIndexPaths = [NSMutableArray arrayWithCapacity:_pageSize];
    for (int ind =0 ; ind <data.count+dd; ind++) {
        NSIndexPath    *newPath =  [NSIndexPath indexPathForRow:ind+((_pageCount*_pageSize)-_pageSize) inSection:0];
        [insertIndexPaths addObject:newPath];
    }
    [celebrityTableView insertRowsAtIndexPaths:insertIndexPaths withRowAnimation:UITableViewRowAnimationFade];
}
#pragma mark 歌曲分类导航按钮单击事件
-(void)TypebtnClick:(UIButton *)selButton{
    [self initialize];
    _nonceType=selButton.tag;
    [self loadMore];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}


@end
