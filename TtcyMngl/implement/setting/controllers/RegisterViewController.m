//
//  RegisterViewController.m
//  TtcyMngl
//
//  Created by 青格勒图 on 14-7-1.
//  Copyright (c) 2014年 hqglt. All rights reserved.
//

#import "RegisterViewController.h"
#import "RegisterView.h"
#import "AccountManager.h"
#import "AccountInfo.h"
#import "HUD.h"
@interface RegisterViewController ()<RegisterViewDelegate,AccountManagerDelegate>
{
    NSString * _user;
    NSString * _pwd;
}

@property (nonatomic,strong)RegisterView * registView;

@end

@implementation RegisterViewController

SINGLETON_IMPLEMENT(RegisterViewController)

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        [Utils createImageWithColor:[UIColor whiteColor]];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createRegistView];
}
-(void)createRegistView
{
    self.registView = [[RegisterView alloc]initWithFrame:self.view.bounds];
    _registView.delegate = self;
    [self.view addSubview:_registView];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self resetSubviews];
}
-(void)resetSubviews
{
    [_registView reset];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - RegisterViewDelegate methods
-(void)regist:(NSString *)userName pwd:(NSString *)pwd
{
    [HUD messageForBuffering];
    
    [[AccountManager shareInstance] addListener:self];
    [[AccountManager shareInstance] regist:userName withPwd:pwd];
    _user = userName;
    _pwd = pwd;
}
#pragma mark - AccountManagerDelegate methods
-(void)registSucess
{
    [HUD message:@"         "];
    [self performSelector:@selector(registerSuccessBack) withObject:nil afterDelay:1];
    
}
-(void)registerSuccessBack
{
    [HUD clearHudFromApplication];
    [self.registerDelegate registerSuccessByAccount:[[AccountManager shareInstance] currentAccount]];
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)registFailure:(NSDictionary *)data
{
#warning 注册失败
    [HUD message:[data objectForKey:@"returnMsg"]];
}
@end



















