//
//  LocalMainViewController.m
//  TtcyMngl
//
//  Created by admin on 14-6-9.
//  Copyright (c) 2014年 hqglt. All rights reserved.
//

#import "LocalMainViewController.h"
#import "LocalCententView.h"
#import "DownloadListViewController.h"
#import "AccountManager.h"
#import "HUD.h"

@interface LocalMainViewController ()

@property (nonatomic,strong)LocalCententView * contentView;

@end

@implementation LocalMainViewController

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
    self.view.backgroundColor = CENT_COLOR;
    
    [self createDetailView];
}

-(void)createDetailView
{
    self.contentView = [[LocalCententView alloc]initWithFrame:CGRectMake(0, topDistance+TopBarHeight, kMainScreenWidth, kMainScreenHeight-TopBarHeight-topDistance)];
    [self.view addSubview:_contentView];
    LOG_UI_INFO(@"Local cententView:%@",_contentView);
    
    __unsafe_unretained LocalMainViewController * main = self;
    _contentView.itemClick = ^(LocalMenuButon *item) {
        
        NSString *str1 = item.vcClass;
        NSString *str2 = @"CollectListViewController";
        NSString *str3 = @"DownloadListViewController";
        
        if ([str1 isEqualToString:str2]) {
            AccountManager *accountManger = [AccountManager shareInstance];
            if (accountManger.status == offLine) {
                [HUD message:@" "];
            }
            else {
                Class c = NSClassFromString(item.vcClass);
                UIViewController *vc = [[c alloc] init];
                [main.navigationController pushViewController:vc animated:YES];
            }
        }else if ([str1 isEqualToString:str3]){
            UIViewController *vc = [DownloadListViewController shareInstance];
            [main.navigationController pushViewController:vc animated:YES];
        }
        else{
            Class c = NSClassFromString(item.vcClass);
            UIViewController *vc = [[c alloc] init];
            [main.navigationController pushViewController:vc animated:YES];
        }
    };
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end















