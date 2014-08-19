//
//  OnlineCelebritView.m
//  TtcyMngl
//
//  Created by 牛利江 on 14-6-24.
//  Copyright (c) 2014年 hqglt. All rights reserved.
//

#import "OnlineCelebritView.h"
#import "CommonClass.h"
@implementation OnlineCelebritView
#define navigationWhile 51
#define sideLabelColor whiteColor
#define PageSize 15

@synthesize delegate;

#define celebrityCellHeight kMainScreenHeight-120-44
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    _nonceType=1;
    return self;
}
#pragma mark 添加右侧导航
+(id)addCelebritTypesViewWhitFram:(CGRect)frame ViewTitle:(NSString *)viewTitle url:(NSString*)url {
    OnlineCelebritView *onlineCelebritView=[[OnlineCelebritView alloc]initWithFrame:frame];
    UILabel *sideLabel=[[UILabel alloc]initWithFrame:CGRectMake(navigationWhile,0, 1, frame.size.height)];
    sideLabel.backgroundColor=[UIColor sideLabelColor];
    [onlineCelebritView addSubview:sideLabel];
    UILabel *titleLabel=[[UILabel alloc]init];
    titleLabel.text=viewTitle;//
    titleLabel.font=[CommonClass setTransformUIView:titleLabel uiFont:titleLabel.font];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [onlineCelebritView addSubview:titleLabel];
    titleLabel.frame=CGRectMake(0, 10, navigationWhile-1, 100);
    UILabel *side2Label=[[UILabel alloc]initWithFrame:CGRectMake(0, 120, navigationWhile, 1)];
    side2Label.backgroundColor=[UIColor sideLabelColor];
    [onlineCelebritView addSubview: side2Label];
    UIScrollView *navigationScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 122, navigationWhile, celebrityCellHeight)];
    navigationScrollView.tag=92;
    navigationScrollView.showsVerticalScrollIndicator = FALSE;
    navigationScrollView.showsHorizontalScrollIndicator = FALSE;

       NSString * path = [[NSBundle mainBundle] pathForResource: url ofType:nil];
  
        NSDictionary* dic = [[NSDictionary alloc] initWithContentsOfFile:path];  //读取出来
    
     NSArray *array = [dic objectForKey:@"Model"];
    
    int count=0;
    UILabel *side3Label;
    UIButton *typeButton;
    for (NSDictionary *dict in array) {
        typeButton=[[UIButton alloc]init];
        typeButton.titleLabel.font=[CommonClass setTransformUIView:typeButton uiFont:typeButton.titleLabel.font];
        [typeButton setTitle:dict[@"MO_Name"] forState:UIControlStateNormal];
        typeButton.tag=[dict[@"id"] intValue];
        typeButton.frame=CGRectMake(0, (count*180), navigationWhile-1, 180);
        side3Label=[[UILabel alloc]initWithFrame:CGRectMake(typeButton.frame.size.height-1,0,1, navigationWhile)];
        side3Label.backgroundColor=[UIColor sideLabelColor];
        [typeButton addSubview: side3Label];
        [typeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [typeButton addTarget:onlineCelebritView action:@selector(TypebtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [navigationScrollView addSubview:typeButton];
        count++;
    }
    [onlineCelebritView addSubview:navigationScrollView];
    UIButton *butt=[[UIButton alloc]init];
    butt.tag=1;
    [onlineCelebritView TypebtnClick:butt];
    //设置水平和吹着滚动
    navigationScrollView.contentSize=CGSizeMake(0,count*190);
    return onlineCelebritView;
}

#pragma mark 添加右侧导航
+(id)addCelebritTypesViewWhitFram:(CGRect)frame ViewTitle:(NSString *)viewTitle stringtypes:(NSArray *)array{
    
    OnlineCelebritView *onlineCelebritView=[[OnlineCelebritView alloc]initWithFrame:frame];
    UILabel *sideLabel=[[UILabel alloc]initWithFrame:CGRectMake(navigationWhile,0, 1, frame.size.height)];
    sideLabel.backgroundColor=[UIColor sideLabelColor];
    [onlineCelebritView addSubview:sideLabel];
    UILabel *titleLabel=[[UILabel alloc]init];
    titleLabel.text=viewTitle;//@"";//歌手列表
    titleLabel.font=[CommonClass setTransformUIView:titleLabel uiFont:titleLabel.font];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    titleLabel.frame=CGRectMake(0, 10, navigationWhile-1, 100);
    [onlineCelebritView addSubview:titleLabel];
    
    UILabel *side2Label=[[UILabel alloc]initWithFrame:CGRectMake(0, 120, navigationWhile, 1)];
    side2Label.backgroundColor=[UIColor sideLabelColor];
    [onlineCelebritView addSubview: side2Label];
    UIScrollView *navigationScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 122, navigationWhile, celebrityCellHeight)];
    navigationScrollView.tag=92;
    navigationScrollView.showsVerticalScrollIndicator = FALSE;
    navigationScrollView.showsHorizontalScrollIndicator = FALSE;
    int count=0;
    UILabel *side3Label;
    UIButton *typeButton;
    int i=0;
    for (NSString *dict in array) {
        i++;
        typeButton=[[UIButton alloc]init];
        typeButton.titleLabel.font=[CommonClass setTransformUIView:typeButton uiFont:typeButton.titleLabel.font];
        [typeButton setTitle:dict forState:UIControlStateNormal];
        typeButton.tag=i;
        typeButton.frame=CGRectMake(0, (count*180), navigationWhile-1, 180);
        side3Label=[[UILabel alloc]initWithFrame:CGRectMake(typeButton.frame.size.height-1,0,1, navigationWhile)];
        side3Label.backgroundColor=[UIColor sideLabelColor];
        [typeButton addSubview: side3Label];
        [typeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [typeButton addTarget:onlineCelebritView action:@selector(TypebtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [navigationScrollView addSubview:typeButton];
        count++;
    }
    [onlineCelebritView addSubview:navigationScrollView];
    UIButton *butt=[[UIButton alloc]init];
    butt.tag=1;
    [onlineCelebritView TypebtnClick:butt];
    //设置水平和吹着滚动
    navigationScrollView.contentSize=CGSizeMake(0,count*200);
    return onlineCelebritView;
}



#pragma mark 分类导航按钮单击事件
-(void)TypebtnClick:(UIButton *)selButton{
    
    [[self viewWithTag:92] viewWithTag:_nonceType].backgroundColor=[UIColor clearColor];
    _nonceType=selButton.tag;
    [[self viewWithTag:92] viewWithTag:_nonceType].backgroundColor=[UIColor greenColor];
    [delegate TypebtnClick:selButton];
}


@end
