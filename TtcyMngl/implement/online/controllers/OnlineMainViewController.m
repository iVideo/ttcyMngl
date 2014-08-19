//
//  OnlineMainViewController.m
//  TtcyMngl
//
//  Created by admin on 14-6-9.
//  Copyright (c) 2014年 hqglt. All rights reserved.
//

#import "OnlineMainViewController.h"
#import "ImScrollView.h"
#import "OnlineCelebritysViewController.h"
#import "OnlineAlbumViewController.h"
#import "OnlineRecViewController.h"
#import "OnlineTaxisViewController.h"
#import "CommonClass.h"
@interface OnlineMainViewController (){
   
}

@end

@implementation OnlineMainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [CommonClass backgroundColorWhitUIView:self.view];
    getTopDistance()
    getPlayBarHeight()
    
    
    UIScrollView *m_scrollView=[ImScrollView  ImScrollViewWithFrame:CGRectMake(0, TopBarHeight, kMainScreenWidth, 86) jsonUrl:nil];
    [self.view addSubview:m_scrollView];
    //菜单按钮
    
    CGFloat meunBtnW=64;
    CGFloat meunBtnH=56 + 100 +14;
    
    UIView *meunView=[[UIView alloc]initWithFrame:CGRectMake(0,TopBarHeight+86,self.view.frame.size.width,self.view.frame.size.height-86)];
    
    NSArray *titleArr=[NSArray arrayWithObjects:@"",@"",@"",@"", nil];
    NSArray *imageArray = @[@"online_song",@"online_album",@"online_singer",@"online_rank"];
    
    static NSInteger index = 0;
    
    for(int i=0;i<4;i++){
        UIButton *meunBtn=[[UIButton alloc] init];
        [meunBtn setBackgroundColor:[UIColor clearColor]];
         meunBtn.transform = CGAffineTransformMakeRotation(M_PI_2);
        meunBtn.frame = CGRectMake(0,0, meunBtnW, meunBtnH);
        
        [meunBtn setImage:[UIImage imageNamed:imageArray[i]] forState:UIControlStateNormal];
        meunBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 130);
        meunBtn.imageView.transform = CGAffineTransformMakeRotation(-M_PI_2);
        
        
        UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 40)];
        titleLabel.center = CGPointMake(meunBtn.center.y+20, meunBtn.center.x-2);
        titleLabel.text = titleArr[i];
        
        titleLabel.font = [UIFont fontWithName:@"Menksoft Qagan" size:18.0f];
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.backgroundColor = [UIColor clearColor];
        [meunBtn addSubview:titleLabel];
        
        meunBtn.tag=i+1;
        [meunBtn addTarget:self action:@selector(meunBtnClicked:) forControlEvents:UIControlEventTouchUpInside];

        CGFloat centerX = kMainScreenWidth/8.0 + (index * kMainScreenWidth/4.0);
        CGFloat centerY = kMainScreenWidth/5.0+50;
        
        meunBtn.center = CGPointMake(centerX, centerY);
        [meunBtn setShowsTouchWhenHighlighted:YES];
        [meunView addSubview:meunBtn];

        index ++;
        index %= 4;
    }
    
    [self.view addSubview:meunView];
}
-(void)meunBtnClicked:(UIButton *)sender
{
    
    switch (sender.tag) {
        case 1://推荐
        {
         
            OnlineRecViewController *onlineRecViewController = [[OnlineRecViewController alloc] init];
            [self.navigationController pushViewController: onlineRecViewController animated:true];
            
        }
            break;
        case 2://专辑
        {
         
            OnlineAlbumViewController *onlineAlbumViewController = [[OnlineAlbumViewController alloc] init];
            [self.navigationController pushViewController: onlineAlbumViewController animated:true];
        }
            break;
        case 3://歌手
        {
            
            OnlineCelebritysViewController *onlineMusicsViewController = [[OnlineCelebritysViewController alloc] init];
            [self.navigationController pushViewController: onlineMusicsViewController animated:true];
        }
            break;
        case 4://排行
        {
           
            OnlineTaxisViewController *onlineTaxisViewController = [[OnlineTaxisViewController alloc] init];
            [self.navigationController pushViewController: onlineTaxisViewController animated:true];
            
        }
            break;
            
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
