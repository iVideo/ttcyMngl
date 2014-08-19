////
////  LoginViewController.m
////  TtcyMngl
////
////  Created by 青格勒图 on 14-6-27.
////  Copyright (c) 2014年 hqglt. All rights reserved.
////
//
#import "LoginViewController.h"
#import "AccountManager.h"
#import "LoginView.h"
#import "LooksPwdViewController.h"
#import "RegisterViewController.h"
#import <JSONKit.h>
#import "HUD.h"

@interface LoginViewController ()< AccountManagerDelegate,LoginViewDelegate,RegisterViewControllerDelegate>

@property (nonatomic,strong)LoginView * loginView;
@property (nonatomic,strong,setter = setCurrentAccount:)AccountInfo * currentAccount;
@property (nonatomic,strong)NSMutableArray * otherAccount;

@end

@implementation LoginViewController
SINGLETON_IMPLEMENT(LoginViewController);

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
    self._isChangeAccount = NO;
    self.loginView = [[LoginView alloc] init];
    _loginView.delegate = self;
    
    [self.view addSubview:_loginView];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void) viewDidAppear:(BOOL)animated
{
    [self getLoginHistory];
    if (self._isChangeAccount) {
        
    }
    [super viewDidAppear:animated];
    [[AccountManager shareInstance] addListener:self];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - LoginViewDelegate methods
- (void) login:(NSString *)user pwd:(NSString *)pwd savepwd:(BOOL)save
{
    if ([@"" isEqualToString:user]) {
        
    }else if ([@"" isEqualToString:pwd]){
        
        [HUD message:@"     "];
    }else{
        [HUD messageForBuffering];
        
        [[AccountManager shareInstance] addListener:self];
        [[AccountManager shareInstance] login:user withPwd:pwd SavePWD:save];
    }
}
-(void)registButtonPressed
{
    RegisterViewController * RVC = [RegisterViewController shareInstance];
    RVC.registerDelegate = self;
    [self.navigationController pushViewController:RVC animated:YES];
}
-(void)forgetButtonPressed
{
    LooksPwdViewController * lvc = [[LooksPwdViewController alloc]init];
    [self.navigationController pushViewController:lvc animated:YES];
}
-(void)showAlert:(NSString *)message
{
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:message delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [alert show];
}
- (void) deleteAccount:(NSString *)user
{
    [[AccountManager shareInstance] deleteAccount:user callback:^(BOOL isSucess) {
        if (isSucess) {
            [self getLoginHistory];
        }
    }];
}

#pragma mark AccountManagerDelegate

- (void)disconnected:(NSDictionary*) data
{
#warning 重新连接
    [HUD message:@""];
}

- (void)loginSucess
{
    [HUD clearHudFromApplication];
    __unsafe_unretained AccountManager * acManager = [AccountManager shareInstance];
    [self.delegate loginSuccessByAccount:acManager.currentAccount];
    
    
    [acManager addAccount:acManager.currentAccount callback:^(BOOL OK) {
        if (OK) {
            [acManager fetchAccountHistory:^(NSArray *list) {
                if (list.count>0) {
                    acManager.historyAccounts = list;
                    [self setOtherAccount:list];
                }
            }];
        }
    }];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)loginFailure:(NSDictionary*) data
{
#warning 登录失败
    [HUD message:[data objectForKeyedSubscript:@"returnMsg"]];
   
}
- (void) setCurrentAccount:(AccountInfo*) account
{
    _loginView.currentAccount = account;
    _loginView.phone = [account.phone copy];
    _loginView.pass = [account.pass copy];
    _loginView.rememberPwd = account.savePasswd;
    _loginView.head = [account.userIcon copy];
    AccountManager * manager = [AccountManager shareInstance];
    if (account.savePasswd && !(self._isChangeAccount)&&manager.status == offLine) {
        
        [[AccountManager shareInstance] login:account.phone withPwd:account.pass SavePWD:YES];
    }
}

- (void) setOtherAccount:(NSArray*) users
{
    _loginView.moreAccount = users;
}
- (void) getLoginHistory
{
    [[AccountManager shareInstance] fetchAccountHistory:^(NSArray *user) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (user && user.count > 0) {
                [self setCurrentAccount: user[0]];
                [self setOtherAccount:user];
            }else{
                [self setCurrentAccount:nil];
                [self setOtherAccount:nil];
            }
        });
    }];
}
#pragma mark - RegisterViewControllerDelegate methods
-(void)registerSuccessByAccount:(AccountInfo *)acc
{
    self._isChangeAccount = NO;
    [self setCurrentAccount:acc];
}

@end
